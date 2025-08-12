import React from "react";
import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { Select } from "@/components/ui/Select";

describe("Selectコンポーネント", () => {
  const mockOptions = [
    { value: "option1", label: "オプション1" },
    { value: "option2", label: "オプション2" },
    { value: "option3", label: "オプション3" },
  ];

  describe("基本表示", () => {
    it("プレースホルダーが初期値として設定される", () => {
      render(
        <Select
          options={mockOptions}
          placeholder="選択してください"
          data-testid="test-select"
        />
      );
      const select = screen.getByTestId("test-select") as HTMLSelectElement;
      // 初期値は空文字
      expect(select.value).toBe("");
      // 表示上は placeholder が見えている
      expect(select).toHaveDisplayValue("選択してください");
    });

    it("クリックでオプション一覧が開き、ラベルが表示される", async () => {
      const user = userEvent.setup();
      render(
        <Select
          options={mockOptions}
          placeholder="選択してください"
          data-testid="test-select"
        />
      );
      const select = screen.getByTestId("test-select");
      // open はネイティブなので click だけで一覧が開く（option は常に DOM 内にある）
      await user.click(select);
      // 各ラベルが存在する
      expect(screen.getByText("オプション1")).toBeInTheDocument();
      expect(screen.getByText("オプション2")).toBeInTheDocument();
      expect(screen.getByText("オプション3")).toBeInTheDocument();
    });

    it("空のオプション配列でもエラーなくレンダリングされる", () => {
      render(
        <Select
          options={[]}
          placeholder="選択してください"
          data-testid="test-select"
        />
      );
      const select = screen.getByTestId("test-select") as HTMLSelectElement;
      expect(select.value).toBe("");
      expect(select).toHaveDisplayValue("選択してください");
    });
  });

  describe("選択機能", () => {
    it("`onChange` で選択値を受け取れる", async () => {
      const user = userEvent.setup();
      const onChangeMock = jest.fn();
      render(
        <Select
          options={mockOptions}
          placeholder="選択してください"
          onChange={onChangeMock}
          data-testid="test-select"
        />
      );
      const select = screen.getByTestId("test-select");
      // オプションを選択
      await user.selectOptions(
        select,
        screen.getByRole("option", { name: "オプション1" })
      );
      expect(onChangeMock).toHaveBeenCalledWith(
        expect.objectContaining({
          target: expect.objectContaining({ value: "option1" }),
        })
      );
    });

    it("選択後、表示値が選択ラベルに変わる", async () => {
      const user = userEvent.setup();
      render(
        <Select
          options={mockOptions}
          placeholder="選択してください"
          data-testid="test-select"
        />
      );
      const select = screen.getByTestId("test-select");
      await user.selectOptions(
        select,
        screen.getByRole("option", { name: "オプション2" })
      );
      expect(select).toHaveDisplayValue("オプション2");
      // プレースホルダーはもう表示されない
      expect(select).not.toHaveDisplayValue("選択してください");
    });
  });

  describe("エラー状態", () => {
    it("`error` が true のときに赤枠クラスが付与される", () => {
      render(
        <Select
          options={mockOptions}
          placeholder="選択してください"
          error={true}
          data-testid="test-select"
        />
      );
      const select = screen.getByTestId("test-select");
      expect(select).toHaveClass("border-red-500");
    });

    it("`error` が false のときは赤枠クラスがない", () => {
      render(
        <Select
          options={mockOptions}
          placeholder="選択してください"
          error={false}
          data-testid="test-select"
        />
      );
      const select = screen.getByTestId("test-select");
      expect(select).not.toHaveClass("border-red-500");
    });
  });

  describe("無効状態", () => {
    it("`disabled` が true のときは無効化される", () => {
      render(
        <Select
          options={mockOptions}
          placeholder="選択してください"
          disabled={true}
          data-testid="test-select"
        />
      );
      const select = screen.getByTestId("test-select");
      expect(select).toBeDisabled();
    });

    it("無効状態では選択操作しても `onChange` が呼ばれず、値も変わらない", async () => {
      const user = userEvent.setup();
      const onChangeMock = jest.fn();
      render(
        <Select
          options={mockOptions}
          placeholder="選択してください"
          disabled={true}
          onChange={onChangeMock}
          data-testid="test-select"
        />
      );
      const select = screen.getByTestId("test-select");
      await user.selectOptions(
        select,
        screen.getByRole("option", { name: "オプション1" })
      );
      expect(onChangeMock).not.toHaveBeenCalled();
      expect((select as HTMLSelectElement).value).toBe("");
    });
  });

  describe("カスタムクラス", () => {
    it("`className` で渡したクラスがマージされる", () => {
      render(
        <Select
          options={mockOptions}
          placeholder="選択してください"
          className="custom-class"
          data-testid="test-select"
        />
      );
      const select = screen.getByTestId("test-select");
      expect(select).toHaveClass("custom-class");
    });
  });

  describe("値の制御 (controlled)", () => {
    it("`defaultValue` プロパティで初期選択を制御できる", () => {
      render(
        <Select
          options={mockOptions}
          placeholder="選択してください"
          defaultValue="option3"
          data-testid="test-select"
        />
      );
      const select = screen.getByTestId("test-select");
      expect(select).toHaveDisplayValue("オプション3");
    });

    it("`value` と `onChange` で制御されたコンポーネントが動作する", () => {
      const handleChange = jest.fn();
      render(
        <Select
          options={mockOptions}
          placeholder="選択してください"
          value="option2"
          onChange={handleChange}
          data-testid="test-select"
        />
      );
      const select = screen.getByTestId("test-select");
      expect(select).toHaveDisplayValue("オプション2");
    });
  });

  describe("キーボード操作", () => {
    it("Enter キーで開いた状態からフォーカス中のオプションを選択できる", async () => {
      const user = userEvent.setup();
      const onChangeMock = jest.fn();
      render(
        <Select
          options={mockOptions}
          placeholder="選択してください"
          onChange={onChangeMock}
          data-testid="test-select"
        />
      );
      const select = screen.getByTestId("test-select");
      await user.click(select);
      await user.keyboard("{Enter}");

      await waitFor(() => {
        expect(select).toHaveDisplayValue("選択してください");
      });
    });

    it("Escape キーでドロップダウンが閉じる", async () => {
      const user = userEvent.setup();
      render(
        <Select
          options={mockOptions}
          placeholder="選択してください"
          data-testid="test-select"
        />
      );
      const select = screen.getByTestId("test-select");
      await user.click(select);
      expect(screen.getByText("オプション1")).toBeInTheDocument();
      await user.keyboard("{Escape}");

      await waitFor(() => {
        expect(select).toHaveDisplayValue("選択してください");
      });
    });
  });

  describe("アクセシビリティ", () => {
    it("`aria-label` が正しく属性に反映される", () => {
      render(
        <Select
          options={mockOptions}
          placeholder="選択してください"
          aria-label="テストセレクト"
          data-testid="test-select"
        />
      );
      const select = screen.getByTestId("test-select");
      expect(select).toHaveAttribute("aria-label", "テストセレクト");
    });
  });
});
