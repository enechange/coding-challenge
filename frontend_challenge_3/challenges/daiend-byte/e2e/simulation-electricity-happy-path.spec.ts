import { expect, test } from '@playwright/test';

// ハッピーパス1本のみ。MSWではなく実際のRoute Handler（ADR-0006）に対する
// 疎通確認と、モバイルビューポート（playwright.config.tsでiPhone 13指定）での
// 実操作確認に価値を限定する（ADR-0014）。
test('郵便番号入力から最後まで正しく入力するとsubmitボタンが活性化する', async ({
    page,
}) => {
    await page.goto('/simulation/electricity');

    await page.getByPlaceholder('130').fill('130');
    await page.getByLabel('電気を使用する場所の郵便番号（下4桁）').fill('0012');

    await page
        .getByRole('combobox', { name: /電力会社/ })
        .selectOption({ label: '東京電力' });
    await page
        .getByRole('combobox', { name: /プラン/ })
        .selectOption({ label: '従量電灯B' });
    await page
        .getByRole('combobox', { name: /契約容量/ })
        .selectOption({ label: '10A' });

    await page.getByLabel(/先月の電気代は？/).fill('5000');
    await page.getByLabel('メールアドレス').fill('test@example.com');
    // mode: 'onChange'（ADR-0005）のためblur前でもisValidは確定するが、
    // フォーカスが外れた後も活性状態が保たれることを合わせて確認する
    await page.getByLabel('メールアドレス').press('Tab');

    await expect(
        page.getByRole('button', { name: '結果を見る' }),
    ).toBeEnabled();
});
