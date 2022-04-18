export type Area = {
  id: number;
  name: string;
  corporations: Corporation[];
};

type Corporation = {
  id: number;
  name: string;
  plans: Plan[];
};

type Plan = {
  id: number;
  name: string;
  description: string;
  min_cost: string;
  capacity: string[];
};
