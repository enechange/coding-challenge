import { describe, it, expect } from "vitest";
import { render, screen } from "@testing-library/react";
import { SimulationResult } from "@/components/simulation-result";

describe("SimulationResult", () => {
  it("loading=true のときスピナーを表示する", () => {
    render(<SimulationResult results={null} loading={true} error={null} />);
    expect(screen.getByRole("status")).toBeInTheDocument();
  });

  it("error があるときエラーメッセージを表示する", () => {
    render(<SimulationResult results={null} loading={false} error="通信エラーです" />);
    expect(screen.getByRole("alert")).toHaveTextContent("通信エラーです");
  });

  it("results が空配列のとき「該当するプランが見つかりませんでした」を表示する", () => {
    render(<SimulationResult results={[]} loading={false} error={null} />);
    expect(screen.getByText(/該当するプランが見つかりませんでした/)).toBeInTheDocument();
  });

  it("results が null のときは何も表示しない", () => {
    const { container } = render(<SimulationResult results={null} loading={false} error={null} />);
    expect(container.firstChild).toBeNull();
  });

  it("results が 3 件あるとき provider_name / plan_name / price が表示される", () => {
    const results = [
      { provider_name: "東京電力", plan_name: "従量電灯B", price: 8010 },
      { provider_name: "東京ガス", plan_name: "ずっとも電気1", price: 7500 },
      { provider_name: "auでんき", plan_name: "auでんきS", price: 7800 },
    ];
    render(<SimulationResult results={results} loading={false} error={null} />);

    expect(screen.getByText("東京電力")).toBeInTheDocument();
    expect(screen.getByText("従量電灯B")).toBeInTheDocument();
    // Intl.NumberFormat の通貨記号は Node/ICU バージョンによって全角 ￥(U+FFE5) / 半角 ¥(U+00A5) のどちらにもなり得るため両方許容する
    expect(screen.getByText(/[¥￥]8,010/)).toBeInTheDocument();
    expect(screen.getByText("東京ガス")).toBeInTheDocument();
    expect(screen.getByText("ずっとも電気1")).toBeInTheDocument();
  });
});
