import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "電気料金シミュレーション | ENECHANGE",
  description:
    "現在の電気料金からどのくらいお得になるかチェック！郵便番号を入力するだけで簡単にシミュレーションできます。",
  icons: {
    icon: "https://enechange.jp/favicon.ico",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ja">
      <body>{children}</body>
    </html>
  );
}
