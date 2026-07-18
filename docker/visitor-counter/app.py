import os

from flask import Flask
from redis import Redis

app = Flask(__name__)

redis_client = Redis(
    host=os.getenv("REDIS_HOST", "redis"),
    port=int(os.getenv("REDIS_PORT", "6379")),
    decode_responses=True,
)


@app.get("/")
def home():
    visits = redis_client.incr("visits")

    return f"""
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Pavel's Container Lab</title>
    </head>
    <body>
        <h1>Pavel's Container Lab</h1>
        <p>This application uses Python, Flask and Redis.</p>
        <p>Page visits: {visits}</p>
    </body>
    </html>
    """


@app.get("/health")
def health():
    try:
        redis_client.ping()
        return {"status": "healthy"}, 200
    except Exception as error:
        return {"status": "unhealthy", "error": str(error)}, 503


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)