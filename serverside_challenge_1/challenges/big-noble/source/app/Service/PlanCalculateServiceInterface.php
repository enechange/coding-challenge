<?php

namespace App\Service;

interface PlanCalculateServiceInterface
{
    /**
     * 料金計算
     *
     * @param array $plan 電力プラン情報
     * @param int $ampere 契約アンペア数
     * @param int $usePower 使用量
     * @return float
     */
    public function calculate(array $plan, int $ampere, int $usePower): float;
}
