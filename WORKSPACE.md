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
# Target:  root@45.55.39.39
# Project: buddha (Python)
# Generated: $(date)
# ─────────────────────────────────────────────────────────────────

# Install sshpass locally if needed (required for password auth)
if ! command -v sshpass &>/dev/null; then
  echo "[deploy] Installing sshpass locally..."
  if command -v brew &>/dev/null; then brew install hudochenkov/sshpass/sshpass 2>/dev/null || brew install sshpass; fi
  if command -v apt-get &>/dev/null; then sudo apt-get install -y sshpass; fi
fi

echo "[deploy] Step 1/5 — Verifying SSH connection..."
sshpass -p 'Hhwj65377068Hhwj' ssh root@45.55.39.39 'echo "[deploy] SSH connection OK"'

echo "[deploy] Step 2/5 — Syncing project files..."
sshpass -p 'Hhwj65377068Hhwj' ssh root@45.55.39.39 "mkdir -p /var/www/buddha"
sshpass -p 'Hhwj65377068Hhwj' rsync -avz --delete --exclude '.git' --exclude 'node_modules' --exclude '.next' --exclude 'dist' --exclude 'build' --exclude '__pycache__' --exclude '.env' --exclude '*.log' "/Users/weijiahuang/Desktop/Buddha/" "root@45.55.39.39:/var/www/buddha/"

echo "[deploy] Step 3/5 — Installing runtime dependencies on server..."
sshpass -p 'Hhwj65377068Hhwj' ssh root@45.55.39.39 'bash -l -s' << 'REMOTE_SETUP'
set -euo pipefail
cd /var/www/buddha
# Install Python3 / pip if missing
if ! command -v python3 &>/dev/null; then
  echo "[deploy] Installing Python3..."
  sudo apt-get update -qq && sudo apt-get install -y python3 python3-pip python3-venv
fi
if ! command -v nginx &>/dev/null; then
  sudo apt-get update -qq && sudo apt-get install -y nginx
fi
REMOTE_SETUP

echo "[deploy] Step 4/5 — Building project on server..."
sshpass -p 'Hhwj65377068Hhwj' ssh root@45.55.39.39 'bash -l -s' << 'REMOTE_BUILD'
set -euo pipefail
cd /var/www/buddha
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt --quiet
REMOTE_BUILD

echo "[deploy] Step 5/5 — Starting application..."
sshpass -p 'Hhwj65377068Hhwj' ssh root@45.55.39.39 'bash -l -s' << 'REMOTE_START'
set -euo pipefail
cd /var/www/buddha
source .venv/bin/activate
# Use gunicorn if available, else uvicorn, else flask dev server
if pip show gunicorn &>/dev/null; then
  pkill -f gunicorn 2>/dev/null; nohup gunicorn -w 4 -b 0.0.0.0:5000 app:app &>/tmp/buddha.log &
elif pip show uvicorn &>/dev/null; then
  pkill -f uvicorn 2>/dev/null; nohup uvicorn main:app --host 0.0.0.0 --port 5000 &>/tmp/buddha.log &
else
  pkill -f "python3 app" 2>/dev/null; nohup python3 app.py &>/tmp/buddha.log &
fi
REMOTE_START

echo ""
echo "[deploy] ✓ Deployment complete!"
echo "[deploy] App is running on: http://45.55.39.39"
- Auto-Detected: true
- Last Configured: 2026-03-08T23:40:30Z