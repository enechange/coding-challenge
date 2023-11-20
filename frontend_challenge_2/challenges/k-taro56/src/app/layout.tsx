import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import localFont from 'next/font/local';
import './globals.css';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: '電気料金シミュレーション',
  description:
    '電気代からかんたんシミュレーション。検針票を用意しなくても OK いくらおトクになるのか今すぐわかります！',
};

const MaterialSymbols = localFont({
  variable: '--font-material-symbols',
  src: '../../node_modules/material-symbols/material-symbols-outlined.woff2',
  display: 'block',
});

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang='jp'>
      <body className={`${inter.className} ${MaterialSymbols.variable}`}>
        {children}
      </body>
    </html>
  );
}
