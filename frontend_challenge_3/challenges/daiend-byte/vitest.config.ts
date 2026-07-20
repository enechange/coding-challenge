import path from 'node:path';

import react from '@vitejs/plugin-react';
import { configDefaults, defineConfig } from 'vitest/config';

export default defineConfig({
    plugins: [react()],
    resolve: {
        alias: {
            '@': path.resolve(__dirname, './src'),
        },
    },
    test: {
        environment: 'jsdom',
        setupFiles: ['./vitest.setup.ts'],
        // e2e/はPlaywright（playwright.config.ts）が実行するため対象外にする
        exclude: [...configDefaults.exclude, 'e2e/**'],
        coverage: {
            provider: 'v8',
            // カバレッジ目標90%以上の対象はdata/schemas/api（ADR-0014）
            include: [
                'src/features/simulation/data/**',
                'src/features/simulation/schemas/**',
                'src/features/simulation/api/**',
            ],
        },
    },
});
