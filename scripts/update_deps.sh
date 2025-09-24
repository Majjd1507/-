#!/usr/bin/env bash
set -euo pipefail

# Helper script to update dependencies and run quick checks locally.
# Run from project root:
#   ./scripts/update_deps.sh

ROOT_DIR="$(pwd)"

echo "1) Ensure you are on the correct branch (e.g., build or main)"
git branch --show-current || true

echo "2) Fetch latest from origin"
git fetch origin --prune || true

echo "3) Upgrade Flutter dependencies (non-breaking where possible)"
flutter pub outdated || true
flutter pub upgrade || true

echo "4) Update backend npm dependencies"
if [ -d backend ]; then
  pushd backend >/dev/null
  npm outdated || true
  npm update || true
  npm install || true
  popd >/dev/null
fi

echo "5) Run flutter analyze and quick build"
flutter clean || true
flutter pub get || true
flutter analyze || true

echo "6) Try a quick release build (AAB). This may take several minutes."
echo "If you do not want to build now, cancel with Ctrl-C."
flutter build appbundle --release || true

echo "If everything is OK, commit your changes:
git add pubspec.yaml pubspec.lock backend/package.json backend/package-lock.json || true
git commit -m 'chore(deps): upgrade Flutter and backend dependencies' || true
git push origin HEAD"
