import React from "react";
import { render, screen } from "@testing-library/react";
import { FormField } from "@/components/ui/FormField";

describe("FormFieldコンポーネント", () => {
  it("ラベルが正しく表示される", () => {
    render(
      <FormField label="テストラベル">
        <input />
      </FormField>
    );

    expect(screen.getByText("テストラベル")).toBeInTheDocument();
  });

  it("requiredがtrueの場合に必須マークが表示される", () => {
    render(
      <FormField label="必須項目" required>
        <input />
      </FormField>
    );

    expect(screen.getByText("必須")).toBeInTheDocument();
  });

  it("エラーが提供された場合にエラーメッセージが表示される", () => {
    const errorMessage = "エラーが発生しました";

    render(
      <FormField label="テストラベル" error={errorMessage}>
        <input />
      </FormField>
    );

    expect(screen.getByText(errorMessage)).toBeInTheDocument();
    expect(screen.getByRole("alert")).toBeInTheDocument();
  });

  it("子要素が正しく表示される", () => {
    render(
      <FormField label="テストラベル">
        <input data-testid="test-input" />
      </FormField>
    );

    expect(screen.getByTestId("test-input")).toBeInTheDocument();
  });

  it("エラーが提供されていない場合はエラーが表示されない", () => {
    render(
      <FormField label="テストラベル">
        <input />
      </FormField>
    );

    expect(screen.queryByRole("alert")).not.toBeInTheDocument();
  });
});
