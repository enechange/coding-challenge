from fastapi.testclient import TestClient
from electricity_rate_simulator.app import app as ele_app


test_client = TestClient(ele_app)


def test_root_api():
    res = test_client.get("/")
    assert res.status_code == 200
    assert res.json() == {"app": "electricity-rate-simulator"}


def test_electric_simurations_api():
    params = {"contract": 10, "amount": 100}
    res = test_client.get("/simurations", params=params)
    assert res.status_code == 200
    assert res.json() == [
        {
            "provider": "東京電力エナジーパートナー",
            "plan": "従量電灯B",
            "price": "3295.24",
        },
        {"provider": "Loopでんき", "plan": "おうちプラン", "price": "2640.0"},
    ]
