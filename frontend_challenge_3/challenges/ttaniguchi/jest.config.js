module.exports = {
  roots: ['<rootDir>/src/js'],
  collectCoverage: false,
  collectCoverageFrom: ['src/js/**/*.{ts,tsx}'],
  testMatch: [
    '**/__tests__/**/*.+(ts|tsx|js)',
    '**/?(*.)+(spec|test).+(ts|tsx|js)',
  ],
  transform: {
    '^.+\\.(ts|tsx)$': 'ts-jest',
  },
};
