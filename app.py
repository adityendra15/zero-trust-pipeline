"""A tiny web application used by the Zero-Trust pipeline project."""

from flask import Flask

app = Flask(__name__)


@app.get("/")
def home() -> str:
    """Return a simple message for the home page."""
    return "Zero-Trust Pipeline Application is Running\n"


@app.get("/healthz")
def health() -> str:
    """Return a successful response for health checks."""
    return "OK\n"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
