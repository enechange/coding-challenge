import { Button } from '@/components/ui/button';
import { Select } from '@/components/ui/form';
import { SectionCard } from '@/components/ui/section-card';
import { ZipCodeInput } from '@/features/simulation/components/zip-code-input';

// カスケードフォーム本体（郵便番号・電力会社・プラン・契約容量等の状態管理・
// バリデーション）は別PRで追加する（ADR-0017 PR分割計画）。
// 本PRはUIプリミティブの動作確認を兼ねた仮配置。
export function SimulationPage() {
    return (
        <main className="flex flex-1 flex-col bg-background">
            <header className="flex flex-col items-center gap-3 px-4 py-10 text-center">
                <h1 className="text-xl font-bold text-text">
                    電気代から
                    <br />
                    かんたんシミュレーション
                </h1>
                <p className="text-base text-text">
                    検針票を用意しなくてもOK
                    <br />
                    いくらおトクになるのか今すぐわかります！
                </p>
            </header>
            <div className="flex flex-col gap-4 pb-10">
                <SectionCard heading="郵便番号をご入力ください">
                    <ZipCodeInput
                        label="電気を使用する場所の郵便番号"
                        required
                        error="エラーメッセージを表示するコンポーネント"
                    />
                </SectionCard>
                <SectionCard heading="電気のご使用状況について教えてください">
                    <Select
                        label="電力会社"
                        required
                        options={[
                            {
                                label: '東京電力エナジーパートナー',
                                value: 'tepco',
                            },
                        ]}
                    />
                    <Select
                        label="プラン"
                        required
                        helpText="選択肢の説明文を表示するコンポーネント"
                        options={[{ label: '従量電灯C', value: 'c' }]}
                    />
                </SectionCard>
                <div className="px-5">
                    <Button type="submit">結果を見る</Button>
                </div>
            </div>
        </main>
    );
}
