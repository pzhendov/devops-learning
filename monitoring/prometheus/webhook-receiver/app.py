#!/usr/bin/env python3

import json
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer


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

        print("Received Alertmanager webhook:", flush=True)
        print(json.dumps(payload, indent=2, sort_keys=True), flush=True)

        self.send_json(200, {"status": "received"})

    def log_message(self, format_string, *args):
        print(
            f'{self.client_address[0]} - {format_string % args}',
            flush=True,
        )


server = ThreadingHTTPServer(("0.0.0.0", 8080), WebhookHandler)

print("Webhook receiver listening on port 8080", flush=True)
server.serve_forever()
