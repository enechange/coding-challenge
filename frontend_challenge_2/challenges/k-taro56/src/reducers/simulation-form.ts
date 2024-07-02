import type { State, Action } from '../types/simulation-form-reducers';

const TOKYO_ELECTRIC_POWER = '東京電力';
const KANSAI_ELECTRIC_POWER = '関西電力';
const OTHER_ELECTRIC_POWER = 'その他';

type Area = typeof TOKYO_AREA | typeof KANSAI_AREA;

const TOKYO_AREA = '1';
const KANSAI_AREA = '5';

const AREA_TO_ELECTRIC_COMPANIES = {
  [TOKYO_AREA]: [TOKYO_ELECTRIC_POWER, OTHER_ELECTRIC_POWER] as const,
  [KANSAI_AREA]: [KANSAI_ELECTRIC_POWER, OTHER_ELECTRIC_POWER] as const,
} as const;

const PLAN_A = '従量電灯 A';
const PLAN_B = '従量電灯 B';
const PLAN_C = '従量電灯 C';

const TOKYO_ELECTRIC_POWER_PLANS = [PLAN_B, PLAN_C] as const;
const KANSAI_ELECTRIC_POWER_PLANS = [PLAN_A, PLAN_B] as const;

const TOKYO_ELECTRIC_POWER_B_CONTRACT_CAPACITY = [
  '10A',
  '15A',
  '20A',
  '30A',
  '40A',
  '50A',
  '60A',
] as const;

export const InitialState = {
  area: '',
  postCode: '',
  postCodeErrorMessage: '',
  electricCompanySelections: [],
  selectedElectricCompany: '',
  electricCompanyErrorMessage: '',
  planSelections: [],
  selectedPlan: '',
  planErrorMessage: '',
  contractCapacitySelections: [],
  selectedContractCapacity: '',
  contractCapacityErrorMessage: '',
  contractCapacity: undefined,
  electricBill: undefined,
  electricBillErrorMessage: '',
  mailAddress: '',
  mailAddressErrorMessage: '',
  postCodeCompleted: false,
  electricCompanyCompleted: false,
  planCompleted: false,
  contractCapacityCompleted: false,
  electricBillCompleted: false,
  mailAddressCompleted: false,
};

const setArea = (state: State, area: Area | undefined) => {
  state.selectedElectricCompany = InitialState.selectedElectricCompany;

  if (!area) {
    state.area = InitialState.area;
    state.electricCompanySelections = InitialState.electricCompanySelections;
    return state;
  }

  state.area = area;
  state.electricCompanySelections = AREA_TO_ELECTRIC_COMPANIES[area];

  return state;
};

const setPostCode = (postCode: string) => {
  const area = postCode[0];

  if (area === TOKYO_AREA) {
    return setArea(
      {
        ...InitialState,
        postCode,
        postCodeErrorMessage: '',
        postCodeCompleted: true,
      },
      TOKYO_AREA,
    );
  } else if (area === KANSAI_AREA) {
    return setArea(
      {
        ...InitialState,
        postCode,
        postCodeErrorMessage: '',
        postCodeCompleted: true,
      },
      KANSAI_AREA,
    );
  } else {
    return setArea(
      {
        ...InitialState,
        postCode,
        postCodeErrorMessage: 'サービスエリア対象外です',
      },
      undefined,
    );
  }
};

const setSelectedElectricCompany = (state: State, electricCompany: string) => {
  const newState = setPostCode(state.postCode);

  if (electricCompany === TOKYO_ELECTRIC_POWER) {
    newState.planSelections = TOKYO_ELECTRIC_POWER_PLANS;
    newState.electricCompanyCompleted = true;
    return newState;
  } else if (electricCompany === KANSAI_ELECTRIC_POWER) {
    newState.planSelections = KANSAI_ELECTRIC_POWER_PLANS;
    newState.electricCompanyCompleted = true;
    return newState;
  } else if (electricCompany === OTHER_ELECTRIC_POWER) {
    newState.electricCompanyErrorMessage = 'シミュレーション対象外です';
    return newState;
  } else {
    return newState;
  }
};

const setSelectedPlan = (state: State, plan: string) => {
  const newState = setSelectedElectricCompany(
    state,
    state.selectedElectricCompany,
  );

  if (plan === PLAN_A) {
    if (newState.selectedElectricCompany === KANSAI_ELECTRIC_POWER) {
      newState.contractCapacityCompleted = true;
    }
    newState.planCompleted = true;
    return newState;
  } else if (plan === PLAN_B) {
    if (newState.selectedElectricCompany === TOKYO_ELECTRIC_POWER) {
      newState.contractCapacitySelections =
        TOKYO_ELECTRIC_POWER_B_CONTRACT_CAPACITY;
    }
    newState.planCompleted = true;
    return newState;
  } else if (plan === PLAN_C) {
    newState.planCompleted = true;
    return newState;
  } else {
    return newState;
  }
};

const setSelectedContractCapacity = (
  state: State,
  contractCapacity: string,
) => {
  const newState = setSelectedPlan(state, state.selectedPlan);

  newState.selectedContractCapacity = contractCapacity;

  return newState;
};

const setContractCapacity = (state: State, contractCapacity: number) => {
  const newState = setSelectedPlan(state, state.selectedPlan);

  newState.contractCapacity = contractCapacity;

  return newState;
};

const setElectricBill = (state: State, electricBill: number) => {
  const newState = setSelectedPlan(state, state.selectedPlan);

  newState.electricBill = electricBill;

  return newState;
};

const setMailAddress = (state: State, mailAddress: string) => {
  const newState = setSelectedPlan(state, state.selectedPlan);

  newState.mailAddress = mailAddress;

  return newState;
};

export const SimulationFormReducer = (state: State, action: Action) => {
  switch (action.type) {
    case 'SET_AREA':
      return setArea(state, action.payload);

    case 'SET_POST_CODE':
      return setPostCode(action.payload);

    case 'SET_SELECTED_ELECTRIC_COMPANY':
      return setSelectedElectricCompany(state, action.payload);

    case 'SET_SELECTED_PLAN':
      return setSelectedPlan(state, action.payload);

    case 'SET_SELECTED_CONTRACT_CAPACITY':
      return setSelectedContractCapacity(state, action.payload);

    case 'SET_CONTRACT_CAPACITY':
      return setContractCapacity(state, action.payload);

    case 'SET_ELECTRIC_BILL':
      return setElectricBill(state, action.payload);

    case 'SET_MAIL_ADDRESS':
      return setMailAddress(state, action.payload);

    default:
      return state;
  }
};
