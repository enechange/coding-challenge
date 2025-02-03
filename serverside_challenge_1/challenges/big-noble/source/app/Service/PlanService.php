<?php

namespace App\Service;

use Symfony\Component\Yaml\Yaml;

class PlanService implements PlanServiceInterface
{
    private string $yamlPath = '';

    public function __construct(private readonly PlanCalculateServiceInterface $planCalculateService)
    {}

    /**
     * @inheritDoc
     */
    public function setYamlPath(string $path): void
    {
        $this->yamlPath = $path;
    }

    /**
     * @inheritDoc
     */
    public function getPlanPrices(int $ampere, int $usePower): array
    {
        $masterPlans = $this->getMasterPlans();

        $responsePlans = [];
        foreach ($masterPlans as $plan) {
            // 指定されたアンペアが存在しないプランは返却しない
            if (!array_key_exists($ampere, $plan['basic_charge'])) {
                continue;
            }

            $responsePlans[] = [
                'provider_name' => $plan['provider_name'],
                'plan_name' => $plan['plan_name'],
                'price' => $this->planCalculateService->calculate($plan, $ampere, $usePower),
            ];
        }

        return $responsePlans;
    }

    /**
     * 電力プランのマスタデータを取得
     *
     * @return mixed
     */
    protected function getMasterPlans(): mixed
    {
        $yamlPath = $this->yamlPath;
        if (empty($yamlPath)) {
            $yamlPath = database_path('yaml/plans.yaml');
        }
        return Yaml::parseFile($yamlPath);
    }
}
