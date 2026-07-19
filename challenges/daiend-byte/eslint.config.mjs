import { defineConfig, globalIgnores } from 'eslint/config';
import nextVitals from 'eslint-config-next/core-web-vitals';
import nextTs from 'eslint-config-next/typescript';
import checkFile from 'eslint-plugin-check-file';
import importPlugin from 'eslint-plugin-import';
import jsxA11y from 'eslint-plugin-jsx-a11y';
import tseslint from 'typescript-eslint';

const sharedLayers = [
    'components',
    'config',
    'hooks',
    'lib',
    'testing',
    'types',
    'utils',
];

const eslintConfig = defineConfig([
    ...nextVitals,
    ...nextTs,
    {
        // 型情報を使うルールは tsconfig に紐づくプロジェクトが必要なため .ts/.tsx に限定する。
        // ルート直下の .mjs 設定ファイル（このファイルや postcss.config.mjs）まで
        // TSプロジェクトに含める必要がなくなる。
        files: ['**/*.ts', '**/*.tsx'],
        extends: [...tseslint.configs.strictTypeChecked],
        languageOptions: {
            parserOptions: {
                projectService: true,
                tsconfigRootDir: import.meta.dirname,
            },
        },
    },
    {
        // eslint-config-next が既に "jsx-a11y" プラグインを登録済みのため、
        // 同じキーで再登録すると "Cannot redefine plugin" エラーになる。
        // そのためルールセットだけをここで追加する。
        rules: jsxA11y.flatConfigs.strict.rules,
    },
    {
        plugins: {
            import: importPlugin,
        },
        rules: {
            'import/no-cycle': 'error',
            'import/order': [
                'error',
                {
                    groups: [
                        'builtin',
                        'external',
                        'internal',
                        'parent',
                        'sibling',
                        'index',
                    ],
                    'newlines-between': 'always',
                    alphabetize: { order: 'asc', caseInsensitive: true },
                },
            ],
            'import/no-restricted-paths': [
                'error',
                {
                    zones: [
                        {
                            target: './src/features/simulation',
                            from: './src/features',
                            except: ['./simulation'],
                            message:
                                'features may not import from other features.',
                        },
                        {
                            target: sharedLayers.map(
                                (layer) => `./src/${layer}`,
                            ),
                            from: './src/features',
                            message:
                                'shared layers may not import from features.',
                        },
                        {
                            target: sharedLayers.map(
                                (layer) => `./src/${layer}`,
                            ),
                            from: './src/app',
                            message: 'shared layers may not import from app.',
                        },
                        {
                            target: './src/features',
                            from: './src/app',
                            message: 'features may not import from app.',
                        },
                    ],
                },
            ],
        },
    },
    {
        plugins: {
            'check-file': checkFile,
        },
        rules: {
            'check-file/filename-naming-convention': [
                'error',
                { '**/*.{ts,tsx}': 'KEBAB_CASE' },
                { ignoreMiddleExtensions: true },
            ],
            'check-file/folder-naming-convention': [
                'error',
                { 'src/**/': 'KEBAB_CASE' },
            ],
        },
    },
    {
        // src/app は Next.js のファイルシステムルーティング規約
        // （[param], (group), _components 等）に従うため kebab-case 強制の対象外とする。
        files: ['src/app/**'],
        rules: {
            'check-file/filename-naming-convention': 'off',
            'check-file/folder-naming-convention': 'off',
        },
    },
    // Override default ignores of eslint-config-next.
    globalIgnores([
        // Default ignores of eslint-config-next:
        '.next/**',
        'out/**',
        'build/**',
        'next-env.d.ts',
    ]),
]);

export default eslintConfig;
