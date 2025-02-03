<?php

namespace App\Service;

class PlanCalculateService implements PlanCalculateServiceInterface
{
    /**
     * @inheritDoc
     */
    public function calculate(array $plan, int $ampere, int $usePower): float
    {
        $basicCharge = $plan['basic_charge'][$ampere];
        $rate = $this->getRateByUsePower($plan['electric_use_charge'], $usePower);

        return $this->calculatePrice($basicCharge, $usePower, $rate);
    }

    /**
     * 使用量に基づく従量料金を取得する
     *
     * @param array $electricUseCharge 使用量別従量料金
     * @param int $usePower 使用量
     * @return int|float 従量料金
     */
    private function getRateByUsePower(array $electricUseCharge, int $usePower): int|float
    {
        foreach ($electricUseCharge as $charge) {
            $range = $charge['range'];
            $min = $range[0];
            $max = $range[1];

            if ($usePower >= $min && (is_null($max) || $usePower <= $max)) {
                $rate = $charge['rate'];
            }
        }
        return $rate;
    }

    /**
     * 料金を計算する
     *
     * @param int $basicCharge 基本料金
     * @param int $usePower 使用量
     * @param int|float $rate 従量料金
     * @return float 料金
     */
    private function calculatePrice(int $basicCharge, int $usePower, int|float $rate): float
    {
        return floor($basicCharge + $usePower * $rate);
    }
}
