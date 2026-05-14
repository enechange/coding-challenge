import { describe, it, expect, vi } from "vitest";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { SimulationForm } from "@/components/simulation-form";
import { VALID_AMPERES } from "@/lib/constants";

describe("SimulationForm", () => {
  it("初期描画で ampere の SelectTrigger が表示される", () => {
    render(<SimulationForm onSubmit={vi.fn()} isLoading={false} />);
    expect(screen.getByLabelText("契約アンペア")).toBeInTheDocument();
  });

  it("VALID_AMPERES は 7 件のアンペア値を持ち、デフォルト選択値 30 が表示される", () => {
    render(<SimulationForm onSubmit={vi.fn()} isLoading={false} />);
    // SelectTrigger はデフォルト値の "30" を表示（"30A" は閉じた状態では見えない）
    expect(screen.getByText("30")).toBeInTheDocument();
    expect(VALID_AMPERES).toHaveLength(7);
  });

  it("kwh 未入力のまま submit するとエラーが表示され onSubmit は呼ばれない", async () => {
    const user = userEvent.setup();
    const onSubmit = vi.fn();
    render(<SimulationForm onSubmit={onSubmit} isLoading={false} />);

    await user.click(screen.getByRole("button", { name: /料金を比較する/ }));

    expect(onSubmit).not.toHaveBeenCalled();
    expect(screen.getByText(/使用量を入力してください/)).toBeInTheDocument();
  });

  it("kwh=10000 を入力して submit するとバリデーションエラーが表示される", async () => {
    const user = userEvent.setup();
    const onSubmit = vi.fn();
    render(<SimulationForm onSubmit={onSubmit} isLoading={false} />);

    await user.type(screen.getByLabelText("使用量 (kWh)"), "10000");
    await user.click(screen.getByRole("button", { name: /料金を比較する/ }));

    expect(onSubmit).not.toHaveBeenCalled();
    expect(screen.getByText(/9999以下を入力してください/)).toBeInTheDocument();
  });

  it("正常入力で onSubmit が { ampere: 30, kwh: 300 } で呼ばれる", async () => {
    const user = userEvent.setup();
    const onSubmit = vi.fn();
    render(<SimulationForm onSubmit={onSubmit} isLoading={false} />);

    await user.type(screen.getByLabelText("使用量 (kWh)"), "300");
    await user.click(screen.getByRole("button", { name: /料金を比較する/ }));

    // RHF の handleSubmit は onSubmit(data, event) で呼ぶので first argument だけ確認
    expect(onSubmit).toHaveBeenCalled();
    const [firstArg] = onSubmit.mock.calls[0] as [{ ampere: number; kwh: number }];
    expect(firstArg).toEqual({ ampere: 30, kwh: 300 });
  });

  it("isLoading=true のとき submit ボタンが無効になる", () => {
    render(<SimulationForm onSubmit={vi.fn()} isLoading={true} />);
    expect(screen.getByRole("button", { name: /計算中/ })).toBeDisabled();
  });
});
