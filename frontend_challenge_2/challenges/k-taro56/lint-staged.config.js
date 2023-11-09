module.exports = {
  '*.{js,jsx,ts,tsx}': [
    () => 'prettier --write .',
    () => 'tsc -p tsconfig.json --noEmit',
    () => 'next lint',
  ],
};
