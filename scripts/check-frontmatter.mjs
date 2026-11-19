import { readFileSync, readdirSync } from "node:fs";
import { join, relative, basename, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { parseDocument } from "yaml";

const root = fileURLToPath(new URL("..", import.meta.url));

function* skillFiles(dir) {
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const fullPath = join(dir, entry.name);
    if (entry.isDirectory()) {
      yield* skillFiles(fullPath);
    } else if (entry.name === "SKILL.md") {
      yield fullPath;
    }
  }
}

const failures = [];
const skillsDir = join(root, "skills");

try {
  let count = 0;
  for (const file of skillFiles(skillsDir)) {
    count++;
    const relPath = relative(root, file);
    const content = readFileSync(file, "utf8");
    const match = content.match(/^---\r?\n([\s\S]*?)\r?\n---/);
    if (!match) {
      failures.push(`${relPath}: missing frontmatter block (--- ... ---)`);
      continue;
    }

    const doc = parseDocument(match[1], { strict: true, uniqueKeys: true });
    if (doc.errors.length > 0) {
      failures.push(`${relPath}: YAML parse error - ${doc.errors[0].message.split("\n")[0]}`);
      continue;
    }

    const data = doc.toJS();
    for (const key of ["name", "description"]) {
      if (typeof data?.[key] !== "string" || data[key].trim() === "") {
        failures.push(`${relPath}: missing required string property \`${key}\``);
      }
    }

    const dirName = basename(dirname(file));
    if (data?.name && data.name !== dirName) {
      failures.push(
        `${relPath}: frontmatter \`name: "${data.name}"\` does not match directory name \`"${dirName}"\``
      );
    }
  }

  if (count === 0) {
    console.log("No skills found under skills/ directory.");
  } else if (failures.length > 0) {
    console.error(`\nFound ${failures.length} SKILL.md error(s):`);
    console.error(failures.map((f) => `  - ${f}`).join("\n"));
    console.error("\nPlease correct these issues before committing.\n");
    process.exit(1);
  } else {
    console.log(`✓ All ${count} SKILL.md frontmatter blocks parsed successfully.`);
  }
} catch (err) {
  if (err.code === "ENOENT") {
    console.log("skills/ directory does not exist yet. Create it when adding your first skill.");
  } else {
    throw err;
  }
}
