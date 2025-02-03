'use client';

import { useEffect, useReducer, useState } from 'react';

import {
  InitialState,
  SimulationFormReducer,
} from '@/reducers/simulation-form';
import SimulationForm from '../components/simulation-form';

const SimulationFormContainer = () => {
  const [state, dispatch] = useReducer(SimulationFormReducer, InitialState);

  const [postCodeErrorMessage, setPostCodeErrorMessage] = useState('');
  const [electricCompanyErrorMessage, setElectricCompanyErrorMessage] =
    useState('');
  const [planErrorMessage, setPlanErrorMessage] = useState('');
  const [contractCapacityErrorMessage, setContractCapacityErrorMessage] =
    useState('');
  const [electricBillErrorMessage, setElectricBillErrorMessage] = useState('');
  const [mailAddressErrorMessage, setMailAddressErrorMessage] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
  };

  const onPostCodeChange = (value: string) => {
    dispatch({ type: 'SET_POST_CODE', payload: value });
  };

  const onElectricCompanyChange = (value: string) => {
    dispatch({ type: 'SET_SELECTED_ELECTRIC_COMPANY', payload: value });
  };

  const onPlanChange = (value: string) => {
    dispatch({ type: 'SET_SELECTED_PLAN', payload: value });
  };

  const onContractCapacitySelectionChange = (value: string) => {
    dispatch({ type: 'SET_SELECTED_CONTRACT_CAPACITY', payload: value });
  };

  const onContractCapacityValueChange = (value: number | undefined) => {
    dispatch({ type: 'SET_CONTRACT_CAPACITY', payload: value });
  };

  const onElectricBillChange = (value: number | undefined) => {
    dispatch({ type: 'SET_ELECTRIC_BILL', payload: value });
  };

  const onMailAddressChange = (value: string) => {
    dispatch({ type: 'SET_MAIL_ADDRESS', payload: value });
  };

  useEffect(() => {
    setPostCodeErrorMessage(state.postCodeErrorMessage);
  }, [state.postCodeErrorMessage]);

  useEffect(() => {
    setElectricCompanyErrorMessage(state.electricCompanyErrorMessage);
  }, [state.electricCompanyErrorMessage]);

  useEffect(() => {
    setPlanErrorMessage(state.planErrorMessage);
  }, [state.planErrorMessage]);

  useEffect(() => {
    setContractCapacityErrorMessage(state.contractCapacityErrorMessage);
  }, [state.contractCapacityErrorMessage]);

  useEffect(() => {
    setElectricBillErrorMessage(state.electricBillErrorMessage);
  }, [state.electricBillErrorMessage]);

  useEffect(() => {
    setMailAddressErrorMessage(state.mailAddressErrorMessage);
  }, [state.mailAddressErrorMessage]);

  return (
    <SimulationForm
      postCode={state.postCode}
      postCodeErrorMessage={postCodeErrorMessage}
      electricCompanySelections={state.electricCompanySelections}
      selectedElectricCompany={state.selectedElectricCompany}
      electricCompanyErrorMessage={electricCompanyErrorMessage}
      planSelections={state.planSelections}
      selectedPlan={state.selectedPlan}
      planErrorMessage={planErrorMessage}
      contractCapacitySelections={state.contractCapacitySelections}
      selectedContractCapacity={state.selectedContractCapacity}
      contractCapacityErrorMessage={contractCapacityErrorMessage}
      contractCapacity={state.contractCapacity}
      electricBill={state.electricBill}
      electricBillErrorMessage={electricBillErrorMessage}
      mailAddress={state.mailAddress}
      mailAddressErrorMessage={mailAddressErrorMessage}
      postCodeCompleted={state.postCodeCompleted}
      electricCompanyCompleted={state.electricCompanyCompleted}
      planCompleted={state.planCompleted}
      contractCapacityCompleted={state.contractCapacityCompleted}
      electricBillCompleted={state.electricBillCompleted}
      mailAddressCompleted={state.mailAddressCompleted}
      handleSubmit={handleSubmit}
      onPostCodeChange={onPostCodeChange}
      onElectricCompanyChange={onElectricCompanyChange}
      onPlanChange={onPlanChange}
      onContractCapacitySelectionChange={onContractCapacitySelectionChange}
      onContractCapacityValueChange={onContractCapacityValueChange}
      onElectricBillChange={onElectricBillChange}
      onMailAddressChange={onMailAddressChange}
      setPostCodeErrorMessage={setPostCodeErrorMessage}
      setElectricCompanyErrorMessage={setElectricCompanyErrorMessage}
      setPlanErrorMessage={setPlanErrorMessage}
      setContractCapacityErrorMessage={setContractCapacityErrorMessage}
      setElectricBillErrorMessage={setElectricBillErrorMessage}
      setMailAddressErrorMessage={setMailAddressErrorMessage}
    />
  );
};

export default SimulationFormContainer;
