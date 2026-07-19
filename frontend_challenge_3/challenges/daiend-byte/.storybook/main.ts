import type { StorybookConfig } from '@storybook/nextjs';

// @storybook/nextjs（webpack版の公式Next.js統合）を採用。
// next/image・next/font・パスエイリアス(@/)・Tailwind CSSを追加設定なしで解決できる（ADR-0010）。
const config: StorybookConfig = {
    stories: ['../src/**/*.stories.@(ts|tsx)'],
    addons: ['@storybook/addon-a11y'],
    framework: '@storybook/nextjs',
    staticDirs: ['../public'],
};

export default config;
