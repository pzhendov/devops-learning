#!/usr/bin/env bash

set -euo pipefail

server="${1:-devops-lab}"
project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_file="$project_root/web/index.html"
remote_tmp="/tmp/devops-index.html"

if [[ ! -f "$source_file" ]]; then
    echo "ERROR: source file not found: $source_file" >&2
    exit 1
fi

echo "Deploying $source_file to $server"

scp "$source_file" "$server:$remote_tmp"

ssh "$server" bash -s -- "$remote_tmp" <<'REMOTE_SCRIPT'
set -euo pipefail

remote_tmp="$1"

sudo install -o root -g root -m 0644 \
    "$remote_tmp" /var/www/html/index.html

rm -f "$remote_tmp"

sudo nginx -t
sudo systemctl reload nginx
/home/ubuntu/bin/check-nginx
REMOTE_SCRIPT

echo "Deployment completed successfully"
