import React from "react";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { Button } from "@/components/ui/Button";
import { FaCircleChevronRight } from "react-icons/fa6";

describe("Buttonコンポーネント", () => {
  describe("基本表示", () => {
    it("ボタンテキストが正しく表示される", () => {
      render(<Button>テストボタン</Button>);
      expect(screen.getByText("テストボタン")).toBeInTheDocument();
    });

    it("デフォルトでtypeがbuttonになる", () => {
      render(<Button>テストボタン</Button>);
      const btn = screen.getByRole("button");
      expect(btn).toHaveAttribute("type", "button");
    });

    it("type='submit'を指定するとsubmitになる", () => {
      render(<Button type="submit">送信ボタン</Button>);
      const btn = screen.getByRole("button");
      expect(btn).toHaveAttribute("type", "submit");
    });

    it("デフォルトのスタイルクラスが適用される", () => {
      render(<Button>デフォルトボタン</Button>);
      const btn = screen.getByRole("button");
      expect(btn).toHaveClass("bg-blue-800");
      expect(btn).toHaveClass("text-white");
      expect(btn).toHaveClass("focus:ring-2");
    });
  });

  describe("クリック機能", () => {
    it("クリックイベントが発火する", async () => {
      const user = userEvent.setup();
      const onClick = jest.fn();
      render(<Button onClick={onClick}>クリックテスト</Button>);
      const btn = screen.getByRole("button");
      await user.click(btn);
      expect(onClick).toHaveBeenCalledTimes(1);
    });

    it("disabled指定でクリックイベントが発火しない", async () => {
      const user = userEvent.setup();
      const onClick = jest.fn();
      render(
        <Button disabled onClick={onClick}>
          無効ボタン
        </Button>
      );
      const btn = screen.getByRole("button");
      await user.click(btn);
      expect(onClick).not.toHaveBeenCalled();
    });
  });

  describe("ローディング状態", () => {
    it("loading指定でdisabledかつopacity-50クラスが付与される", () => {
      render(<Button loading>ロード中</Button>);
      const btn = screen.getByRole("button");
      expect(btn).toBeDisabled();
      expect(btn).toHaveClass("disabled:opacity-50");
    });

    it("loading指定でもテキストはそのまま表示される", () => {
      render(<Button loading>ロード中テキスト</Button>);
      expect(screen.getByText("ロード中テキスト")).toBeInTheDocument();
    });

    it("loading指定でクリックイベントが発火しない", async () => {
      const user = userEvent.setup();
      const onClick = jest.fn();
      render(
        <Button loading onClick={onClick}>
          ロード中
        </Button>
      );
      const btn = screen.getByRole("button");
      await user.click(btn);
      expect(onClick).not.toHaveBeenCalled();
    });
  });

  describe("アイコン表示", () => {
    it("iconSuffixがレンダリングされる", () => {
      render(
        <Button iconSuffix={<FaCircleChevronRight data-testid="suffix" />}>
          サフィックス
        </Button>
      );
      expect(screen.getByText("サフィックス")).toBeInTheDocument();
      expect(screen.getByTestId("suffix")).toBeInTheDocument();
    });

    it("iconPrefixがレンダリングされる", () => {
      render(
        <Button iconPrefix={<FaCircleChevronRight data-testid="prefix" />}>
          プレフィックス
        </Button>
      );
      expect(screen.getByText("プレフィックス")).toBeInTheDocument();
      expect(screen.getByTestId("prefix")).toBeInTheDocument();
    });

    it("prefixとsuffix両方がレンダリングされる", () => {
      render(
        <Button
          iconPrefix={<FaCircleChevronRight data-testid="pre" />}
          iconSuffix={<FaCircleChevronRight data-testid="suf" />}
        >
          両方アイコン
        </Button>
      );
      expect(screen.getByText("両方アイコン")).toBeInTheDocument();
      expect(screen.getByTestId("pre")).toBeInTheDocument();
      expect(screen.getByTestId("suf")).toBeInTheDocument();
    });
  });

  describe("カスタムクラス＆アクセシビリティ", () => {
    it("classNameで受け取ったクラスがマージされる", () => {
      render(<Button className="custom">カスタム</Button>);
      const btn = screen.getByRole("button");
      expect(btn).toHaveClass("custom");
    });

    it("aria-labelが正しくセットされる", () => {
      render(
        <Button aria-label="アクセシビリティ" aria-describedby="desc">
          ボタン
        </Button>
      );
      const btn = screen.getByRole("button");
      expect(btn).toHaveAttribute("aria-label", "アクセシビリティ");
      expect(btn).toHaveAttribute("aria-describedby", "desc");
    });
  });

  describe("フォーカス＆キーボード操作", () => {
    it("Tabキーでフォーカスされ、focusリングが発動する", async () => {
      const user = userEvent.setup();
      render(<Button>フォーカス</Button>);
      const btn = screen.getByRole("button");
      await user.tab();
      expect(btn).toHaveFocus();
      expect(btn).toHaveClass("focus:ring-2");
    });

    it("Enterキーでクリックイベントが発火する", async () => {
      const user = userEvent.setup();
      const onClick = jest.fn();
      render(<Button onClick={onClick}>Enterテスト</Button>);
      await user.tab();
      await user.keyboard("{Enter}");
      expect(onClick).toHaveBeenCalledTimes(1);
    });

    it("Spaceキーでクリックイベントが発火する", async () => {
      const user = userEvent.setup();
      const onClick = jest.fn();
      render(<Button onClick={onClick}>Spaceテスト</Button>);
      await user.tab();
      await user.keyboard(" ");
      expect(onClick).toHaveBeenCalledTimes(1);
    });
  });
});
