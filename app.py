import os
from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def home():
    return jsonify(
        application="zero-trust-pipeline",
        message="Only security-approved images are deployed",
        version=os.getenv("APP_VERSION", "local"),
    )


@app.get("/health/live")
def liveness():
    return jsonify(status="alive"), 200


@app.get("/health/ready")
def readiness():
    return jsonify(status="ready"), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
