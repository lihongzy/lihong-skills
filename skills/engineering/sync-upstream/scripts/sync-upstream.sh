#!/usr/bin/env bash
#
# sync-upstream.sh — Inspect and synchronize upstream repositories tracked in upstreams/

set -euo pipefail

UPDATE=0
TARGET_NAME=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --update|-u)
      UPDATE=1
      shift
      ;;
    --name|-n)
      TARGET_NAME="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/../../../" && pwd)"
UPSTREAMS_DIR="$REPO_ROOT/upstreams"

if [ ! -d "$UPSTREAMS_DIR" ]; then
  echo "No upstreams directory found at $UPSTREAMS_DIR" >&2
  exit 0
fi

echo "=== Upstream Skill Repository Inspector ==="

for target in "$UPSTREAMS_DIR"/*; do
  [ -d "$target" ] || continue
  CONFIG_FILE="$target/UPSTREAM.json"
  [ -f "$CONFIG_FILE" ] || continue

  name="$(basename "$target")"
  if [ -n "$TARGET_NAME" ] && [ "$name" != "$TARGET_NAME" ]; then
    continue
  fi

  repo_url="$(node -e "console.log(JSON.parse(require('fs').readFileSync('$CONFIG_FILE')).repository)")"
  branch="$(node -e "console.log(JSON.parse(require('fs').readFileSync('$CONFIG_FILE')).branch)")"
  current_sha="$(node -e "console.log(JSON.parse(require('fs').readFileSync('$CONFIG_FILE')).tracked_commit)")"

  echo -e "\nChecking [$name] ($repo_url on $branch)..."
  echo "  Current Tracked Commit: $current_sha"

  remote_line="$(git ls-remote "$repo_url" "refs/heads/$branch" 2>/dev/null || true)"
  if [ -z "$remote_line" ]; then
    echo "  [warning] Unable to reach remote or find branch $branch" >&2
    continue
  fi

  latest_sha="$(echo "$remote_line" | awk '{print $1}')"
  echo "  Latest Remote Commit  : $latest_sha"

  if [ "$current_sha" = "$latest_sha" ]; then
    echo "  ✓ Up to date! No changes detected upstream."
  else
    echo "  ! NEW UPDATES AVAILABLE upstream!"
    if [ "$UPDATE" -eq 1 ]; then
      tmp_clone="$(mktemp -d)"
      git clone --depth 50 --branch "$branch" "$repo_url" "$tmp_clone"
      
      echo "  Recent Upstream Commits:"
      git -C "$tmp_clone" log "$current_sha..$latest_sha" --oneline || true

      find "$target" -mindepth 1 -not -name "UPSTREAM.json" -delete
      cp -r "$tmp_clone"/* "$target"/
      rm -rf "$tmp_clone" "$target/.git"

      node -e "
        const fs = require('fs');
        const c = JSON.parse(fs.readFileSync('$CONFIG_FILE'));
        c.tracked_commit = '$latest_sha';
        c.last_synced_at = new Date().toISOString();
        fs.writeFileSync('$CONFIG_FILE', JSON.stringify(c, null, 2));
      "
      echo "  ✓ Snapshot updated to $latest_sha"
    else
      echo "  Run with --update to pull latest commits and refresh snapshot."
    fi
  fi
done
