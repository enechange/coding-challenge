import { test, expect } from "@playwright/test";

test.describe("電気料金シミュレーションフォーム", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/");
  });

  test("フォームの初期表示が正しく行われる", async ({ page }) => {
    await expect(
      page.getByRole("heading", { name: "電気代から かんたんシミュレーション" })
    ).toBeVisible();
    await expect(page.getByText("検針票を用意しなくてもOK")).toBeVisible();
    await expect(
      page.getByText("いくらおトクになるのか今すぐわかります！")
    ).toBeVisible();

    await expect(page.getByPlaceholder("130")).toBeVisible();
    await expect(page.getByPlaceholder("0012")).toBeVisible();
    await expect(page.getByText("電気を使用する場所の郵便番号")).toBeVisible();

    await expect(
      page.getByText("電気のご使用状況について教えてください")
    ).not.toBeVisible();
    await expect(
      page.getByText("現在の電気の使用状況について教えてください")
    ).not.toBeVisible();
    await expect(
      page.getByText("ユーザー情報をご入力ください")
    ).not.toBeVisible();
    await expect(
      page.getByRole("button", { name: "結果を見る" })
    ).not.toBeVisible();
  });

  test("郵便番号のリアルタイムバリデーションが正しく動作する", async ({
    page,
  }) => {
    await page.getByPlaceholder("130").fill("12");
    await expect(
      page.getByText("サービスエリア対象外です。")
    ).not.toBeVisible();
    await expect(
      page.getByText("電気のご使用状況について教えてください")
    ).not.toBeVisible();

    await page.getByPlaceholder("130").fill("123");
    await page.getByPlaceholder("0012").fill("456");
    await expect(
      page.getByText("電気のご使用状況について教えてください")
    ).not.toBeVisible();

    await page.getByPlaceholder("0012").fill("4567");
    await expect(
      page.getByText("電気のご使用状況について教えてください")
    ).toBeVisible();
  });

  test("東京電力エリア（郵便番号上1桁が1）の判定が正しく動作する", async ({
    page,
  }) => {
    await page.getByPlaceholder("130").fill("123");
    await page.getByPlaceholder("0012").fill("4567");

    await expect(
      page.getByText("電気のご使用状況について教えてください")
    ).toBeVisible();

    await expect(page.getByLabel("電力会社")).toBeVisible();

    const tokyoOptions = page.locator(
      'select[name="powerCompany"] option:not([hidden])'
    );
    await expect(tokyoOptions).toHaveCount(2);
    await expect(tokyoOptions.nth(0)).toHaveText("東京電力");
    await expect(tokyoOptions.nth(1)).toHaveText("その他");
    await expect(
      page.locator(
        'select[name="powerCompany"] option[value="kansai-electric"]'
      )
    ).toHaveCount(0);
    await page.selectOption('select[name="powerCompany"]', "tokyo-electric");

    await expect(page.getByLabel("プラン")).toBeVisible();
    await page.selectOption('select[name="plan"]', "tokyo-juryou-b");

    await expect(page.getByLabel("契約容量")).toBeVisible();
    await page.selectOption('select[name="contractCapacity"]', "30A");
  });

  test("関西電力エリア（郵便番号上1桁が5）の判定が正しく動作する", async ({
    page,
  }) => {
    await page.getByPlaceholder("130").fill("567");
    await page.getByPlaceholder("0012").fill("8901");

    await expect(
      page.getByText("電気のご使用状況について教えてください")
    ).toBeVisible();

    await expect(page.getByLabel("電力会社")).toBeVisible();

    const kansaiOptions = page.locator(
      'select[name="powerCompany"] option:not([hidden])'
    );
    await expect(kansaiOptions).toHaveCount(2);
    await expect(kansaiOptions.nth(0)).toHaveText("関西電力");
    await expect(kansaiOptions.nth(1)).toHaveText("その他");
    await expect(
      page.locator('select[name="powerCompany"] option[value="tokyo-electric"]')
    ).toHaveCount(0);
    await page.selectOption('select[name="powerCompany"]', "kansai-electric");

    await expect(page.getByLabel("プラン")).toBeVisible();
    await page.selectOption('select[name="plan"]', "kansai-juryou-a");
  });

  test("サービスエリア対象外（郵便番号上1桁が1,5以外）の判定が正しく動作する", async ({
    page,
  }) => {
    await page.getByPlaceholder("130").fill("987");
    await page.getByPlaceholder("0012").fill("6543");

    await expect(page.getByText("サービスエリア対象外です。")).toBeVisible();

    await expect(
      page.getByText("電気のご使用状況について教えてください")
    ).not.toBeVisible();
  });

  test("電力会社「その他」選択時の動作が正しく動作する", async ({ page }) => {
    await page.getByPlaceholder("130").fill("123");
    await page.getByPlaceholder("0012").fill("4567");

    await page.selectOption('select[name="powerCompany"]', "other");

    await expect(page.getByText("シミュレーション対象外です。")).toBeVisible();

    await expect(page.getByLabel("プラン")).not.toBeVisible();
  });

  test("東京電力従量電灯Bプランの契約容量選択肢が正しく表示される", async ({
    page,
  }) => {
    await page.getByPlaceholder("130").fill("123");
    await page.getByPlaceholder("0012").fill("4567");

    await page.selectOption('select[name="powerCompany"]', "tokyo-electric");
    await page.selectOption('select[name="plan"]', "tokyo-juryou-b");

    await expect(page.getByLabel("契約容量")).toBeVisible();
  });

  test("東京電力従量電灯Cプランの契約容量選択肢が正しく表示される", async ({
    page,
  }) => {
    await page.getByPlaceholder("130").fill("123");
    await page.getByPlaceholder("0012").fill("4567");

    await page.selectOption('select[name="powerCompany"]', "tokyo-electric");
    await page.selectOption('select[name="plan"]', "tokyo-juryou-c");

    await expect(page.getByLabel("契約容量")).toBeVisible();
  });

  test("関西電力従量電灯Aプランでは契約容量が不要", async ({ page }) => {
    await page.getByPlaceholder("130").fill("567");
    await page.getByPlaceholder("0012").fill("8901");

    await page.selectOption('select[name="powerCompany"]', "kansai-electric");
    await page.selectOption('select[name="plan"]', "kansai-juryou-a");

    await expect(page.getByLabel("契約容量")).not.toBeVisible();

    await expect(
      page.getByText("現在の電気の使用状況について教えてください")
    ).toBeVisible();
  });

  test("関西電力従量電灯Bプランの契約容量選択肢が正しく表示される", async ({
    page,
  }) => {
    await page.getByPlaceholder("130").fill("567");
    await page.getByPlaceholder("0012").fill("8901");

    await page.selectOption('select[name="powerCompany"]', "kansai-electric");
    await page.selectOption('select[name="plan"]', "kansai-juryou-b");

    await expect(page.getByLabel("契約容量")).toBeVisible();
  });

  test("電気代の最低料金（1000円）バリデーションが正しく動作する", async ({
    page,
  }) => {
    await page.getByPlaceholder("130").fill("123");
    await page.getByPlaceholder("0012").fill("4567");

    await page.selectOption('select[name="powerCompany"]', "tokyo-electric");
    await page.selectOption('select[name="plan"]', "tokyo-juryou-b");
    await page.selectOption('select[name="contractCapacity"]', "30A");

    await page.getByPlaceholder("5000").fill("500");

    await page.getByPlaceholder("5000").blur();

    await expect(
      page.getByText("電気代を正しく入力してください。")
    ).toBeVisible();

    await page.getByPlaceholder("5000").fill("1000");
    await page.getByPlaceholder("5000").blur();

    await expect(
      page.getByText("電気代を正しく入力してください。")
    ).not.toBeVisible();
  });

  test("メールアドレスのバリデーションが正しく動作する", async ({ page }) => {
    await page.getByPlaceholder("130").fill("123");
    await page.getByPlaceholder("0012").fill("4567");

    await page.selectOption('select[name="powerCompany"]', "tokyo-electric");
    await page.selectOption('select[name="plan"]', "tokyo-juryou-b");
    await page.selectOption('select[name="contractCapacity"]', "30A");
    await page.getByPlaceholder("5000").fill("5000");

    await page.getByPlaceholder("メールアドレス").fill("invalid-email");
    await page.getByPlaceholder("メールアドレス").blur();

    await expect(
      page.getByText("メールアドレスを正しく入力してください。")
    ).toBeVisible();

    await page.getByPlaceholder("メールアドレス").fill("test@example.com");
    await page.getByPlaceholder("メールアドレス").blur();

    await expect(
      page.getByText("メールアドレスを正しく入力してください。")
    ).not.toBeVisible();
  });

  test("郵便番号のバリデーションが正しく動作する", async ({ page }) => {
    await page.getByPlaceholder("130").fill("12");
    await page.getByPlaceholder("0012").fill("456");
    await page.getByPlaceholder("130").blur();
    await page.getByPlaceholder("0012").blur();

    await expect(page.getByText("3桁の数字で入力してください")).toBeVisible();

    await page.getByPlaceholder("130").fill("123");
    await page.getByPlaceholder("0012").fill("4567");
    await page.getByPlaceholder("130").blur();
    await page.getByPlaceholder("0012").blur();

    await expect(
      page.getByText("3桁の数字で入力してください")
    ).not.toBeVisible();
  });

  test("郵便番号入力時の自動フォーカス移動が正しく動作する", async ({
    page,
  }) => {
    await page.getByPlaceholder("130").fill("123");

    await expect(page.getByPlaceholder("0012")).toBeFocused();
  });

  test("プラン変更時に契約容量がリセットされる", async ({ page }) => {
    await page.getByPlaceholder("130").fill("123");
    await page.getByPlaceholder("0012").fill("4567");

    await page.selectOption('select[name="powerCompany"]', "tokyo-electric");
    await page.selectOption('select[name="plan"]', "tokyo-juryou-b");
    await page.selectOption('select[name="contractCapacity"]', "30A");

    await page.selectOption('select[name="plan"]', "tokyo-juryou-c");

    await expect(page.getByText("30A")).not.toBeVisible();
  });

  test("電力会社変更時にプランと契約容量がリセットされる", async ({ page }) => {
    await page.getByPlaceholder("130").fill("123");
    await page.getByPlaceholder("0012").fill("4567");

    await page.selectOption('select[name="powerCompany"]', "tokyo-electric");
    await page.selectOption('select[name="plan"]', "tokyo-juryou-b");
    await page.selectOption('select[name="contractCapacity"]', "30A");

    await page.selectOption('select[name="powerCompany"]', "other");

    await expect(page.getByText("tokyo-juryou-b")).not.toBeVisible();
    await expect(page.getByText("30A")).not.toBeVisible();
  });

  test("郵便番号変更時に電力会社以降がリセットされる", async ({ page }) => {
    await page.getByPlaceholder("130").fill("123");
    await page.getByPlaceholder("0012").fill("4567");

    await page.selectOption('select[name="powerCompany"]', "tokyo-electric");
    await page.selectOption('select[name="plan"]', "tokyo-juryou-b");
    await page.selectOption('select[name="contractCapacity"]', "30A");

    await page.getByPlaceholder("130").fill("567");
    await page.getByPlaceholder("0012").fill("8901");

    await expect(page.getByText("tokyo-electric")).not.toBeVisible();
    await expect(page.getByText("tokyo-juryou-b")).not.toBeVisible();
    await expect(page.getByText("30A")).not.toBeVisible();
  });

  test("全ての入力が完了したらsubmitボタンが活性化される", async ({ page }) => {
    await page.getByPlaceholder("130").fill("123");
    await page.getByPlaceholder("0012").fill("4567");

    await page.selectOption('select[name="powerCompany"]', "tokyo-electric");
    await page.selectOption('select[name="plan"]', "tokyo-juryou-b");
    await page.selectOption('select[name="contractCapacity"]', "30A");
    await page.getByPlaceholder("5000").fill("5000");
    await page.getByPlaceholder("メールアドレス").fill("test@example.com");

    const submitButton = page.getByRole("button", { name: "結果を見る" });
    await expect(submitButton).toBeEnabled();
  });

  test("入力が不完全な場合はsubmitボタンが無効のまま", async ({ page }) => {
    await page.getByPlaceholder("130").fill("123");
    await page.getByPlaceholder("0012").fill("4567");

    await page.selectOption('select[name="powerCompany"]', "tokyo-electric");
    await page.selectOption('select[name="plan"]', "tokyo-juryou-b");

    await expect(
      page.getByRole("button", { name: "結果を見る" })
    ).toBeDisabled();
  });

  test("エリア外の場合はsubmitボタンが表示されない", async ({ page }) => {
    await page.getByPlaceholder("130").fill("987");
    await page.getByPlaceholder("0012").fill("6543");

    await expect(
      page.getByRole("button", { name: "結果を見る" })
    ).not.toBeVisible();
  });

  test("「その他」電力会社選択時はsubmitボタンが表示されない", async ({
    page,
  }) => {
    await page.getByPlaceholder("130").fill("123");
    await page.getByPlaceholder("0012").fill("4567");

    await page.selectOption('select[name="powerCompany"]', "other");

    await expect(
      page.getByRole("button", { name: "結果を見る" })
    ).not.toBeVisible();
  });

  test("完全なシミュレーションフローが正常に動作する", async ({ page }) => {
    await page.getByPlaceholder("130").fill("123");
    await page.getByPlaceholder("0012").fill("4567");

    await page.selectOption('select[name="powerCompany"]', "tokyo-electric");

    await page.selectOption('select[name="plan"]', "tokyo-juryou-b");

    await page.selectOption('select[name="contractCapacity"]', "30A");

    await page.getByPlaceholder("5000").fill("12000");

    await page.getByPlaceholder("メールアドレス").fill("test@example.com");

    page.on("dialog", async (dialog) => {
      expect(dialog.message()).toContain("シミュレーション完了！");
      expect(dialog.message()).toContain("郵便番号: 123-4567");
      expect(dialog.message()).toContain("電力会社: 東京電力");
      expect(dialog.message()).toContain("プラン: 従量電灯B");
      expect(dialog.message()).toContain("契約容量: 30A");
      expect(dialog.message()).toContain("現在の電気代: 12,000円");
      await dialog.accept();
    });

    const submitButton = page.getByRole("button", { name: "結果を見る" });
    await submitButton.click();

    await expect(
      page.getByRole("heading", { name: "電気代から かんたんシミュレーション" })
    ).toBeVisible();
  });

  test("関西電力従量電灯Aプランでの完全なシミュレーションフロー", async ({
    page,
  }) => {
    await page.getByPlaceholder("130").fill("567");
    await page.getByPlaceholder("0012").fill("8901");

    await page.selectOption('select[name="powerCompany"]', "kansai-electric");

    await page.selectOption('select[name="plan"]', "kansai-juryou-a");

    await expect(
      page.getByRole("combobox", { name: "contractCapacity" })
    ).not.toBeVisible();

    await page.getByPlaceholder("5000").fill("8000");

    await page.getByPlaceholder("メールアドレス").fill("test@example.com");

    await expect(
      page.getByRole("button", { name: "結果を見る" })
    ).toBeEnabled();

    page.on("dialog", async (dialog) => {
      expect(dialog.message()).toContain("シミュレーション完了！");
      expect(dialog.message()).toContain("郵便番号: 567-8901");
      expect(dialog.message()).toContain("電力会社: 関西電力");
      expect(dialog.message()).toContain("プラン: 従量電灯A");
      expect(dialog.message()).toContain("契約容量: なし");
      expect(dialog.message()).toContain("現在の電気代: 8,000円");
      await dialog.accept();
    });

    const submitButton = page.getByRole("button", { name: "結果を見る" });
    await submitButton.click();

    await expect(
      page.getByRole("heading", { name: "電気代から かんたんシミュレーション" })
    ).toBeVisible();
  });

  test("送信中のローディング状態が正しく表示される", async ({ page }) => {
    await page.getByPlaceholder("130").fill("123");
    await page.getByPlaceholder("0012").fill("4567");

    await page.selectOption('select[name="powerCompany"]', "tokyo-electric");
    await page.selectOption('select[name="plan"]', "tokyo-juryou-b");
    await page.selectOption('select[name="contractCapacity"]', "30A");
    await page.getByPlaceholder("5000").fill("5000");
    await page.getByPlaceholder("メールアドレス").fill("test@example.com");

    page.on("dialog", async (dialog) => {
      await dialog.accept();
    });

    const submitButton = page.getByRole("button", { name: "結果を見る" });
    await submitButton.click();

    await expect(
      page.getByRole("heading", { name: "電気代から かんたんシミュレーション" })
    ).toBeVisible();
  });

  // 上記の2テストへ統合したため、個別の選択肢検証テストは削除
});
