from electricity_rate_simulator.core.electric_simurate import (
    calc_usage_rate_by_tepco,
    calc_electric_simurations,
)
import pytest


class TestCalcPriceByTepco:

    def test_calc_price(self):

        test_amount = 0
        with pytest.raises(ValueError) as e:
            calc_usage_rate_by_tepco(test_amount)

        assert str(e.value) == f"AmountValueError: {test_amount}"

    def test_calc_price_in_minimum_rate(self):
        test_amount = 120
        assert calc_usage_rate_by_tepco(test_amount) == 120 * 30.00

    def test_calc_price_within_limit(self):
        test_amount = 280
        over = test_amount - 120
        assert calc_usage_rate_by_tepco(test_amount) == 120 * 30.00 + over * 36.60

    def test_calc_price_by_over_limit(self):
        test_amount = 400
        over = test_amount - 300
        assert (
            calc_usage_rate_by_tepco(test_amount)
            == 120 * 30.00 + 180 * 36.60 + over * 40.69
        )

    def test_carc_rate(self):
        simurations = calc_electric_simurations()
        assert type(simurations) == list
        assert len(simurations) == 2
