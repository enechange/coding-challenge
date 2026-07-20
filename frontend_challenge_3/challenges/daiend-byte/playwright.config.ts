import { defineConfig, devices } from '@playwright/test';

// E2Eはハッピーパス1本に絞り、実際のRoute Handler（ADR-0006）に対する疎通確認と
// モバイルビューポートでの実操作確認に価値を限定する（ADR-0014）。
export default defineConfig({
    testDir: './e2e',
    fullyParallel: true,
    forbidOnly: !!process.env.CI,
    retries: process.env.CI ? 2 : 0,
    reporter: 'html',
    use: {
        baseURL: 'http://localhost:3000',
        trace: 'on-first-retry',
        ...devices['iPhone 13'],
    },
    webServer: {
        command: 'pnpm build && pnpm start',
        url: 'http://localhost:3000',
        reuseExistingServer: !process.env.CI,
    },
});
