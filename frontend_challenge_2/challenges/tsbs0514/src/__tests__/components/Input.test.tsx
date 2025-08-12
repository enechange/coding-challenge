import React from "react";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { Input } from "@/components/ui/Input";

describe("Inputコンポーネント", () => {
  it("入力フィールドが正しく表示される", () => {
    render(<Input placeholder="テストプレースホルダー" />);

    const input = screen.getByPlaceholderText("テストプレースホルダー");
    expect(input).toBeInTheDocument();
  });

  it("ユーザー入力が正しく処理される", async () => {
    const user = userEvent.setup();
    render(<Input data-testid="test-input" />);

    const input = screen.getByTestId("test-input");
    await user.type(input, "テスト入力");

    expect(input).toHaveValue("テスト入力");
  });

  it("エラープロパティがtrueの場合にエラースタイルが適用される", () => {
    render(<Input data-testid="test-input" error />);

    const input = screen.getByTestId("test-input");
    expect(input).toHaveClass("border-red-500");
  });

  it("異なる入力タイプを受け入れる", () => {
    render(<Input type="email" data-testid="email-input" />);

    const input = screen.getByTestId("email-input");
    expect(input).toHaveAttribute("type", "email");
  });

  it("無効状態が正しく処理される", () => {
    render(<Input disabled data-testid="disabled-input" />);

    const input = screen.getByTestId("disabled-input");
    expect(input).toBeDisabled();
    expect(input).toHaveClass("disabled:cursor-not-allowed");
  });
});
