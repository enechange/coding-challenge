export type List = { key: number; value: string }[];

export const DummyList: List = [...Array(20)].map((_, key) => ({
  key,
  value: `data${key}`,
}));
