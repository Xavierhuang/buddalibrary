# WORKSPACE.md

Copy this file to `WORKSPACE.md` in your project root. LingCode loads it when using the deterministic prompt (project mode with a workspace).

## Language & Stack
- Swift 5.9
- SwiftUI
- Xcode 15+

## Conventions
- Prefer value types
- Avoid force unwraps
- Keep view models small

## Editing Rules
- Ask before refactors touching more than one file
- Keep diffs minimal

## Deployment

- Target: Docker (Local)
- Environment: production
- Branch: main
- Deploy Command: #!/usr/bin/env bash
set -euo pipefail

# ── LingCode Magic Deploy ─────────────────────────────────────────
# Target:  root@146.190.126.48
# Project: buddha (Static Site)
# Generated: $(date)
# ─────────────────────────────────────────────────────────────────

# Install sshpass locally if needed (required for password auth)
if ! command -v sshpass &>/dev/null; then
  echo "[deploy] Installing sshpass locally..."
  if command -v brew &>/dev/null; then brew install hudochenkov/sshpass/sshpass 2>/dev/null || brew install sshpass; fi
  if command -v apt-get &>/dev/null; then sudo apt-get install -y sshpass; fi
fi

echo "[deploy] Step 1/5 — Verifying SSH connection..."
sshpass -p 'Hhwj65377068Hhwj' ssh root@146.190.126.48 'echo "[deploy] SSH connection OK"'

echo "[deploy] Step 2/5 — Syncing project files..."
sshpass -p 'Hhwj65377068Hhwj' ssh root@146.190.126.48 "mkdir -p /var/www/buddha"
sshpass -p 'Hhwj65377068Hhwj' rsync -avz --delete --exclude '.git' --exclude 'node_modules' --exclude '.next' --exclude 'dist' --exclude 'build' --exclude '__pycache__' --exclude '.env' --exclude '*.log' "/Users/weijiahuang/Desktop/Buddha/" "root@146.190.126.48:/var/www/buddha/"

echo "[deploy] Step 3/5 — Installing runtime dependencies on server..."
sshpass -p 'Hhwj65377068Hhwj' ssh root@146.190.126.48 'bash -l -s' << 'REMOTE_SETUP'
set -euo pipefail
cd /var/www/buddha
echo '[deploy] No specific runtime detected — running generic deploy'
REMOTE_SETUP

echo "[deploy] Step 4/5 — Building project on server..."
sshpass -p 'Hhwj65377068Hhwj' ssh root@146.190.126.48 'bash -l -s' << 'REMOTE_BUILD'
set -euo pipefail
cd /var/www/buddha
echo '[deploy] No build step'
REMOTE_BUILD

echo "[deploy] Step 5/5 — Starting application..."
sshpass -p 'Hhwj65377068Hhwj' ssh root@146.190.126.48 'bash -l -s' << 'REMOTE_START'
set -euo pipefail
cd /var/www/buddha
echo '[deploy] No start command configured'
REMOTE_START

echo ""
echo "[deploy] ✓ Deployment complete!"
echo "[deploy] App is running on: http://146.190.126.48"
- Auto-Detected: true
- Last Configured: 2026-03-03T13:28:36Z