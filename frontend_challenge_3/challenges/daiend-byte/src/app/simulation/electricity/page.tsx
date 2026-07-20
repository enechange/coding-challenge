import type { Metadata, Viewport } from 'next';

import { SimulationPage } from './_components/simulation-page';

export const metadata: Metadata = {
    title: '電気代からかんたんシミュレーション｜電気料金比較',
    description:
        '検針票を用意しなくてもOK。郵便番号と現在のご契約内容を入力するだけで、電気代がいくらおトクになるか今すぐわかります。',
};

export const viewport: Viewport = {
    width: 'device-width',
    initialScale: 1,
};

export default function ElectricitySimulationPage() {
    return <SimulationPage />;
}
