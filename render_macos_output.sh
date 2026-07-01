#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(git rev-parse --show-toplevel)"
RENDERED_BRANCH="rendered"
TEMP_DIR="$(mktemp -d /tmp/dotfiles-rendered-XXXXXX)"
DUMMY_CONFIG="$(mktemp /tmp/chezmoi-config-XXXXXX.toml)"

cleanup() {
    rm -rf "$TEMP_DIR" "$DUMMY_CONFIG"
    # Return to main if we switched away (e.g. on error)
    local branch
    branch="$(git -C "$REPO_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
    if [ "$branch" = "$RENDERED_BRANCH" ]; then
        git -C "$REPO_DIR" checkout main >/dev/null 2>&1 || true
    fi
}
trap cleanup EXIT

# Only run on main
CURRENT_BRANCH="$(git -C "$REPO_DIR" rev-parse --abbrev-ref HEAD)"
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo ">>> Not on main branch, skipping render."
    exit 0
fi

SOURCE_SHA="$(git -C "$REPO_DIR" rev-parse --short HEAD)"

cat > "$DUMMY_CONFIG" << 'EOF'
[data]
    email = "user@example.com"
    signingKey = "example-signing-key"
EOF

echo ">>> Rendering dotfiles from main@${SOURCE_SHA}..."
chezmoi apply \
    --source "$REPO_DIR" \
    --destination "$TEMP_DIR" \
    --config "$DUMMY_CONFIG" \
    --force

#######
# Remove unnecessary files from rendered
rm -rf "$TEMP_DIR/Library"
rm -rf "$TEMP_DIR/.teamocil"
#######

# Stash uncommitted changes before switching branches
STASHED=false
if ! git -C "$REPO_DIR" diff --quiet || \
   ! git -C "$REPO_DIR" diff --cached --quiet || \
   [ -n "$(git -C "$REPO_DIR" ls-files --others --exclude-standard)" ]; then
    git -C "$REPO_DIR" stash push --include-untracked -m "render-script-stash" >/dev/null
    STASHED=true
fi

git -C "$REPO_DIR" checkout "$RENDERED_BRANCH"
git -C "$REPO_DIR" fetch origin "$RENDERED_BRANCH" && \
    git -C "$REPO_DIR" reset --hard "origin/$RENDERED_BRANCH" || true

# Clear all tracked files, then restore files that live only on this branch
git -C "$REPO_DIR" rm -rf --ignore-unmatch . >/dev/null
git -C "$REPO_DIR" checkout HEAD -- README.md
git -C "$REPO_DIR" checkout HEAD -- _config.yml

rsync -a "$TEMP_DIR/" "$REPO_DIR/"

git -C "$REPO_DIR" add -A
if git -C "$REPO_DIR" diff --staged --quiet; then
    echo ">>> No changes in rendered output, nothing to push."
else
    git -C "$REPO_DIR" commit -m "Rendered from main@${SOURCE_SHA}"
    git -C "$REPO_DIR" push --force origin "$RENDERED_BRANCH"
    echo ">>> Pushed rendered output to ${RENDERED_BRANCH}."
fi

git -C "$REPO_DIR" checkout main

if [ "$STASHED" = true ]; then
    git -C "$REPO_DIR" stash pop >/dev/null
fi

echo ">>> Done."
