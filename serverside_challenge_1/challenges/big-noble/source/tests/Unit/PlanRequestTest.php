<?php

use App\Http\Requests\Api\Plan\IndexRequest;
use Illuminate\Support\Facades\Validator;
use Tests\TestCase;

class PlanRequestTest extends TestCase
{
    /**
     * @param array $keys
     * @param array $values
     * @param bool $expect
     * @param array $expectMessage
     * @return void
     * @dataProvider dataProvider
     */
    public function test_validation(array $keys, array $values, bool $expect, array $expectMessage): void
    {
        // リクエストのキーバリューを結合
        $dataList = array_combine($keys, $values);

        // バリデーションのリクエストクラスをnew
        $request = new IndexRequest();
        $rules = $request->rules();
        $validator = Validator::make($dataList, $rules);
        $validator->setAttributeNames($request->attributes());

        // バリデーション結果
        $result = $validator->passes();

        // バリデーション結果のテスト
        $this->assertEquals($expect, $result);

        if (!$result) {
            // NGの場合のエラーメッセージのテスト
            $this->assertSame($expectMessage, $validator->messages()->messages());
        }
    }

    /**
     * @return array[]
     */
    public static function dataProvider(): array
    {
        return [
            'ok' => [
                ['ampere', 'use_power'],
                [10, 100],
                true,
                []
            ],
            'ng:アンペア数必須NULL' => [
                ['ampere', 'use_power'],
                [null, 100],
                false,
                ['ampere' => ['契約アンペア数は必須です。']]
            ],
            'ng:アンペア数必須キーなし' => [
                ['use_power'],
                [100],
                false,
                ['ampere' => ['契約アンペア数は必須です。']]
            ],
            'ng:使用量必須NULL' => [
                ['ampere', 'use_power'],
                [10, null],
                false,
                ['use_power' => ['使用量は必須です。']]
            ],
            'ng:使用量必須キーなし' => [
                ['ampere'],
                [10],
                false,
                ['use_power' => ['使用量は必須です。']]
            ],
            'ng:存在しないアンペア数' => [
                ['ampere', 'use_power'],
                [99, 100],
                false,
                ['ampere' => ['選択された契約アンペア数は無効です。']]
            ],
            'ng:使用量が整数でない' => [
                ['ampere', 'use_power'],
                [30, 111.1],
                false,
                ['use_power' => ['使用量は整数である必要があります。']]
            ]
        ];
    }
}
