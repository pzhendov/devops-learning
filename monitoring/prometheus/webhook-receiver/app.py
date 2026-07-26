#!/usr/bin/env python3

import json
import os
from datetime import datetime, timezone
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from threading import Lock


HISTORY_FILE = Path(
    os.environ.get("ALERT_HISTORY_FILE", "/data/alerts.jsonl")
)
HISTORY_LOCK = Lock()

HISTORY_FILE.parent.mkdir(parents=True, exist_ok=True)


def save_notification(payload):
    record = {
        "received_at": datetime.now(timezone.utc).isoformat(),
        "status": payload.get("status", "unknown"),
        "payload": payload,
    }

    with HISTORY_LOCK:
        with HISTORY_FILE.open("a", encoding="utf-8") as history:
            history.write(json.dumps(record, sort_keys=True))
            history.write("\n")

    return record


def load_recent_notifications(limit=50):
    if not HISTORY_FILE.exists():
        return []

    with HISTORY_LOCK:
        lines = HISTORY_FILE.read_text(encoding="utf-8").splitlines()

    return [
        json.loads(line)
        for line in lines[-limit:]
        if line.strip()
    ]


class WebhookHandler(BaseHTTPRequestHandler):
    def send_json(self, status_code, payload):
        body = json.dumps(payload).encode("utf-8")

        self.send_response(status_code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        if self.path == "/health":
            self.send_json(200, {"status": "healthy"})
        elif self.path == "/alerts":
            notifications = load_recent_notifications()
            self.send_json(
                200,
                {
                    "count": len(notifications),
                    "notifications": notifications,
                },
            )
        else:
            self.send_json(404, {"error": "not found"})

    def do_POST(self):
        if self.path != "/alerts":
            self.send_json(404, {"error": "not found"})
            return

        content_length = int(self.headers.get("Content-Length", "0"))
        raw_body = self.rfile.read(content_length)

        try:
            payload = json.loads(raw_body)
        except json.JSONDecodeError:
            self.send_json(400, {"error": "invalid JSON"})
            return

        record = save_notification(payload)

        print("Received Alertmanager webhook:", flush=True)
        print(json.dumps(payload, indent=2, sort_keys=True), flush=True)

        self.send_json(
            200,
            {
                "status": "received",
                "received_at": record["received_at"],
            },
        )

    def log_message(self, format_string, *args):
        print(
            f'{self.client_address[0]} - {format_string % args}',
            flush=True,
        )


server = ThreadingHTTPServer(("0.0.0.0", 8080), WebhookHandler)

print("Webhook receiver listening on port 8080", flush=True)
print(f"Alert history file: {HISTORY_FILE}", flush=True)
server.serve_forever()
