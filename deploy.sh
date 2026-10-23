#!/bin/sh
# Publish the menu to Cloudflare Pages.
#   ./deploy.sh            first run asks you to log in
#   ./deploy.sh --dry-run  check the folder without publishing
set -e
cd "$(dirname "$0")"

PROJECT=cafe-tsveti

echo "Cleaning macOS clutter..."
find . -name '.DS_Store' -delete
find . -name '__MACOSX' -type d -prune -exec rm -rf {} + 2>/dev/null || true

echo "Checking for details that are still blank..."
grep -n 'phoneText : ""' index.html >/dev/null 2>&1 && echo "  - phone number is empty" || true
grep -n 'facebook  : ""' index.html >/dev/null 2>&1 && echo "  - facebook url is empty" || true
grep -n 'ka: { street: "", city: "" }' index.html >/dev/null 2>&1 && echo "  - address is empty" || true
for f in assets/cheesecake.jpg assets/coffee.jpg assets/interior.jpg; do
  [ -f "$f" ] || echo "  - missing photograph: $f"
done
echo "  (blank values are hidden on the page, they do not break anything)"

if [ "$1" = "--dry-run" ]; then
  echo "Dry run. Nothing was published."
  exit 0
fi

echo "Publishing to Cloudflare Pages project '$PROJECT'..."
npx --yes wrangler pages deploy . --project-name="$PROJECT" --commit-dirty=true
