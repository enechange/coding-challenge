from fastapi.testclient import TestClient
from electricity_rate_simulator.app import app as ele_app

test_client = TestClient(ele_app)


def test_root_api():
    res = test_client.get("/")
    assert res.status_code == 200
    assert res.json() == {"app": "electricity-rate-simulator"}


def test_electric_simulations_api():
    params = {"contract": 10, "usage": 100}
    res = test_client.get("/simulations", params=params)
    assert res.status_code == 200
    assert res.json() == [{
            "provider": "東京電力エナジーパートナー",
            "plan": "従量電灯B",
            "price": "2274円",
        },
        {
            "provider": "Loopでんき",
            "plan": "おうちプラン",
            "price": "2640円",
        }]


def test_electric_simulations_api_invailed_contract():
    contract = 0
    usage = 100
    params = {"contract": contract, "usage": usage}
    res = test_client.get("/simulations", params=params)
    assert res.status_code == 400
    assert res.json() == {'detail': f'Invailed value of contract: {contract}'}
    

def test_electric_simulations_api_invailed_usage():
    contract = 10
    usage = -1
    params = {"contract": contract, "usage": usage}
    res = test_client.get("/simulations", params=params)
    assert res.status_code == 400
    assert res.json() == {"detail": f"Invailed value of usage: {usage}"}

