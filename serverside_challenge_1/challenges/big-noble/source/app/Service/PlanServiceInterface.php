<?php

namespace App\Service;

interface PlanServiceInterface
{
    /**
     * Yamlファイルのパスを指定
     *
     * @param string $path
     * @return void
     */
    public function setYamlPath(string $path): void;

    /**
     * 指定の条件に合致するプラン一覧を取得
     *
     * @param int $ampere 契約アンペア数
     * @param int $usePower 使用量
     * @return array
     */
    public function getPlanPrices(int $ampere, int $usePower): array;
}
