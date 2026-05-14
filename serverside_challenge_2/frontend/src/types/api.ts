export type SimulationResult = {
  provider_name: string;
  plan_name: string;
  price: number;
};

export type SimulationSuccess = {
  data: SimulationResult[];
};

export type SimulationErrorItem = {
  status: string;
  title: string;
  detail: string;
  source: { parameter: string };
};

export type SimulationError = {
  errors: SimulationErrorItem[];
};
