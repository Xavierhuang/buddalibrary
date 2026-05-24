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
# Target:  root@0.0.0.0
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
sshpass -p 'Hhwj65377068Hhwj' ssh root@0.0.0.0 'echo "[deploy] SSH connection OK"'

echo "[deploy] Step 2/5 — Syncing project files..."
sshpass -p 'Hhwj65377068Hhwj' ssh root@0.0.0.0 "mkdir -p /var/www/buddha"
sshpass -p 'Hhwj65377068Hhwj' rsync -avz --delete --exclude '.git' --exclude 'node_modules' --exclude '.next' --exclude 'dist' --exclude 'build' --exclude '__pycache__' --exclude '.env' --exclude '*.log' "/Users/weijiahuang/Desktop/Buddha/" "root@0.0.0.0:/var/www/buddha/"

echo "[deploy] Step 3/5 — Installing runtime dependencies on server..."
sshpass -p 'Hhwj65377068Hhwj' ssh root@0.0.0.0 'bash -l -s' << 'REMOTE_SETUP'
set -euo pipefail
cd /var/www/buddha
if ! command -v nginx &>/dev/null; then
  echo "[deploy] Installing nginx..."
  sudo apt-get update -qq && sudo apt-get install -y nginx
fi
REMOTE_SETUP

echo "[deploy] Step 4/5 — Building project on server..."
sshpass -p 'Hhwj65377068Hhwj' ssh root@0.0.0.0 'bash -l -s' << 'REMOTE_BUILD'
set -euo pipefail
cd /var/www/buddha
echo '[deploy] Static site — no build step'
REMOTE_BUILD

echo "[deploy] Step 5/5 — Starting application..."
sshpass -p 'Hhwj65377068Hhwj' ssh root@0.0.0.0 'bash -l -s' << 'REMOTE_START'
set -euo pipefail
cd /var/www/buddha
if [ ! -f /etc/nginx/sites-enabled/buddha ]; then
  echo "[deploy] Configuring nginx to serve static files..."
  sudo tee /etc/nginx/sites-available/buddha > /dev/null << 'NGINX'
server {
    listen 80;
    server_name _;
    root /var/www/buddha;
    index index.html;
    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
NGINX
  sudo ln -sf /etc/nginx/sites-available/buddha /etc/nginx/sites-enabled/buddha
  sudo nginx -t 2>&1 && sudo systemctl reload nginx
fi
echo "[deploy] Static site served from /var/www/buddha"
REMOTE_START

echo ""
echo "[deploy] ✓ Deployment complete!"
echo "[deploy] App is running on: http://0.0.0.0"
- Auto-Detected: true
- Last Configured: 2026-03-12T20:03:26Z