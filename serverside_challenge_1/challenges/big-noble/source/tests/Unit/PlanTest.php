<?php

namespace Tests\Unit;

use App\Service\PlanService;
use Tests\TestCase;

class PlanTest extends TestCase
{
    /**
     * A basic test example.
     *
     * @dataProvider dataProvider
     */
    public function test_basic_test(int $ampere, int $usePower, array $expect): void
    {
        $yamlPath = storage_path('app/private/yaml/plans.yaml');

        $service = app()->make(PlanService::class);
        $service->setYamlPath($yamlPath);
        $result = $service->getPlanPrices($ampere, $usePower);

        $this->assertEquals($expect, $result);
    }

    /**
     * @return array[]
     */
    public static function dataProvider(): array
    {
        return [
            '10a_10kwh' => [
                10,
                10,
                [
                    [
                        'provider_name' => '東京電力エナジーパートナー',
                        'plan_name' => '従量電灯B',
                        'price' => floor(286.00 + 10 * 19.88)
                    ],
                    [
                        'provider_name' => 'Looopでんき',
                        'plan_name' => 'おうちプラン',
                        'price' => floor(0 + 10 * 26.40)
                    ]
                ]
            ],
            '15a_120kwh' => [
                15,
                120,
                [
                    [
                        'provider_name' => '東京電力エナジーパートナー',
                        'plan_name' => '従量電灯B',
                        'price' => floor(429.00 + 120 * 19.88)
                    ],
                    [
                        'provider_name' => 'Looopでんき',
                        'plan_name' => 'おうちプラン',
                        'price' => floor(0 + 120 * 26.40)
                    ]
                ]
            ],
            '20a_121kwh' => [
                20,
                121,
                [
                    [
                        'provider_name' => '東京電力エナジーパートナー',
                        'plan_name' => '従量電灯B',
                        'price' => floor(572.00 + 121 * 26.48)
                    ],
                    [
                        'provider_name' => 'Looopでんき',
                        'plan_name' => 'おうちプラン',
                        'price' => floor(0 + 121 * 26.40)
                    ]
                ]
            ],
            '30a_300kwh' => [
                30,
                300,
                [
                    [
                        'provider_name' => '東京電力エナジーパートナー',
                        'plan_name' => '従量電灯B',
                        'price' => floor(858.00 + 300 * 26.48)
                    ],
                    [
                        'provider_name' => 'Looopでんき',
                        'plan_name' => 'おうちプラン',
                        'price' => floor(0 + 300 * 26.40)
                    ],
                    [
                        'provider_name' => '東京ガス',
                        'plan_name' => 'ずっとも電気1',
                        'price' => floor(858.00 + 300 * 23.88)
                    ],
                    [
                        'provider_name' => 'JXTGでんき',
                        'plan_name' => '従量電灯Bたっぷりプラン',
                        'price' => floor(858.00 + 300 * 26.48)
                    ]
                ]
            ],
            '40a_301kwh' => [
                40,
                301,
                [
                    [
                        'provider_name' => '東京電力エナジーパートナー',
                        'plan_name' => '従量電灯B',
                        'price' => floor(1144.00 + 301 * 30.57)
                    ],
                    [
                        'provider_name' => 'Looopでんき',
                        'plan_name' => 'おうちプラン',
                        'price' => floor(0 + 301 * 26.40)
                    ],
                    [
                        'provider_name' => '東京ガス',
                        'plan_name' => 'ずっとも電気1',
                        'price' => floor(1144.00 + 301 * 23.88)
                    ],
                    [
                        'provider_name' => 'JXTGでんき',
                        'plan_name' => '従量電灯Bたっぷりプラン',
                        'price' => floor(1144.00 + 301 * 25.08)
                    ]
                ]
            ],
            '50a_600kwh' => [
                50,
                600,
                [
                    [
                        'provider_name' => '東京電力エナジーパートナー',
                        'plan_name' => '従量電灯B',
                        'price' => floor(1430.00 + 600 * 30.57)
                    ],
                    [
                        'provider_name' => 'Looopでんき',
                        'plan_name' => 'おうちプラン',
                        'price' => floor(0 + 600 * 26.40)
                    ],
                    [
                        'provider_name' => '東京ガス',
                        'plan_name' => 'ずっとも電気1',
                        'price' => floor(1430.00 + 600 * 26.41)
                    ],
                    [
                        'provider_name' => 'JXTGでんき',
                        'plan_name' => '従量電灯Bたっぷりプラン',
                        'price' => floor(1430.00 + 600 * 25.08)
                    ]
                ]
            ],
            '60a_601kwh' => [
                60,
                601,
                [
                    [
                        'provider_name' => '東京電力エナジーパートナー',
                        'plan_name' => '従量電灯B',
                        'price' => floor(1716.00 + 601 * 30.57)
                    ],
                    [
                        'provider_name' => 'Looopでんき',
                        'plan_name' => 'おうちプラン',
                        'price' => floor(0 + 601 * 26.40)
                    ],
                    [
                        'provider_name' => '東京ガス',
                        'plan_name' => 'ずっとも電気1',
                        'price' => floor(1716.00 + 601 * 26.41)
                    ],
                    [
                        'provider_name' => 'JXTGでんき',
                        'plan_name' => '従量電灯Bたっぷりプラン',
                        'price' => floor(1716.00 + 601 * 26.15)
                    ]
                ]
            ],
        ];
    }
}
