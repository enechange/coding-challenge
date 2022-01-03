module.exports = {
  preset: "@vue/cli-plugin-unit-jest/presets/typescript",
  testMatch: ["<rootDir>/src/**/*.spec.(ts|tsx)"],
  transform: {
    "^.+\\.ts$": "ts-jest",
  },
};
