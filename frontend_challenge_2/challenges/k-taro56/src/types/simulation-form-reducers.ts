export interface State {
  area: string;
  postCode: string;
  postCodeErrorMessage: string;
  electricCompanySelections: readonly string[];
  selectedElectricCompany: string;
  electricCompanyErrorMessage: string;
  planSelections: readonly string[];
  selectedPlan: string;
  planErrorMessage: string;
  contractCapacitySelections: readonly string[];
  selectedContractCapacity: string;
  contractCapacityErrorMessage: string;
  contractCapacity: number | undefined;
  electricBill: number | undefined;
  electricBillErrorMessage: string;
  mailAddress: string;
  mailAddressErrorMessage: string;
  postCodeCompleted: boolean;
  electricCompanyCompleted: boolean;
  planCompleted: boolean;
  contractCapacityCompleted: boolean;
  electricBillCompleted: boolean;
  mailAddressCompleted: boolean;
}

export interface Action {
  type:
    | 'SET_AREA'
    | 'SET_POST_CODE'
    | 'SET_SELECTED_ELECTRIC_COMPANY'
    | 'SET_SELECTED_PLAN'
    | 'SET_CONTRACT_CAPACITY_SELECTIONS'
    | 'SET_SELECTED_CONTRACT_CAPACITY'
    | 'SET_CONTRACT_CAPACITY'
    | 'SET_ELECTRIC_BILL'
    | 'SET_MAIL_ADDRESS';
  payload: any;
}
