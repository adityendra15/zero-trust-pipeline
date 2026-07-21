from app import app


def test_home():
    client = app.test_client()
    response = client.get("/")
    assert response.status_code == 200
    assert response.get_json()["application"] == "zero-trust-pipeline"


def test_health_endpoints():
    client = app.test_client()
    assert client.get("/health/live").status_code == 200
    assert client.get("/health/ready").status_code == 200
