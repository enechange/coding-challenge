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
    assert res.json() == [
        {
            "provider": "東京電力エナジーパートナー",
            "plan": "従量電灯B",
            "price": "2274円",
        },
        {
            "provider": "Loopでんき",
            "plan": "おうちプラン",
            "price": "2640円",
        },
    ]


def test_electric_simulations_api_invalid_contract():
    contract = 0
    usage = 100
    params = {"contract": contract, "usage": usage}
    res = test_client.get("/simulations", params=params)
    assert res.status_code == 400
    assert res.json() == {"detail": f"Invalid number of contract: {contract}"}


def test_electric_simulations_api_invalid_usage():
    contract = 10
    usage = -1
    params = {"contract": contract, "usage": usage}
    res = test_client.get("/simulations", params=params)
    assert res.status_code == 400
    assert res.json() == {"detail": f"Invalid number of usage: {usage}"}


def test_electric_simulations_api_invalid_contract_value():
    contract = "test"
    usage = 100
    params = {"contract": contract, "usage": usage}
    res = test_client.get("/simulations", params=params)
    assert res.status_code == 422
    assert (
        res.text
        == '{"detail":[{"type":"int_parsing","loc":["query","contract"],"msg":"Input should be a valid integer, unable to parse string as an integer","input":"test","url":"https://errors.pydantic.dev/2.6/v/int_parsing"}]}'
    )


def test_electric_simulations_api_invalid_usage_value():
    contract = 10
    usage = "test"
    params = {"contract": contract, "usage": usage}
    res = test_client.get("/simulations", params=params)
    assert res.status_code == 422
    assert (
        res.text
        == '{"detail":[{"type":"int_parsing","loc":["query","usage"],"msg":"Input should be a valid integer, unable to parse string as an integer","input":"test","url":"https://errors.pydantic.dev/2.6/v/int_parsing"}]}'
    )
