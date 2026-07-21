from app import app


def test_home_endpoint():
    client = app.test_client()
    response = client.get("/")
    assert response.status_code == 200
    body = response.get_json()
    assert body["message"] == "Zero-Trust pipeline application is running"
    assert "version" in body
    assert "pod" in body


def test_liveness_endpoint():
    client = app.test_client()
    response = client.get("/health/live")
    assert response.status_code == 200
    assert response.get_json() == {"status": "alive"}


def test_readiness_endpoint():
    client = app.test_client()
    response = client.get("/health/ready")
    assert response.status_code == 200
    assert response.get_json() == {"status": "ready"}
