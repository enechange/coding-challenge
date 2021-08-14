import React from "react";
import { useState, useEffect } from 'react';
import styled from 'styled-components';
import { Colors } from '../assets/Colors';
import { validateEmailAddress } from "../utils";
import { POSTAL_CODES_BY_AREA, COMPANIES_BY_AREA } from '../constants';

import Headline from "../components/Headline";
import Caption from "../components/Caption";
import Button from "../components/base/Button";

import InputPostalCode from "../templates/InputPostalCode";
import SelectElectricPowerCompany from "../templates/SelectElectricPowerCompany";
import SelectPlan from "../templates/SelectPlan";
import SelectCapacity from "../templates/SelectCapacity";
import InputElectricBill from "../templates/InputElectricBill";
import InputEmailAddress from "../templates/InputEmailAddress";

const Wrapper = styled.div`
  background: ${Colors.lightGray};
`;

const Content = styled.div`
  padding: 20px 0 40px;
  background: ${Colors.white};
  margin-bottom: 50px;
`;

const ButtonWrapper = styled.div`
  width: 92%;
  margin: 0 auto 50px;
`;

//ロジック、値、状態は全てこのコンポーネントで一括管理し、子に渡す
const Simulation = () => {
  //郵便番号
  const [postalAreaCode, setPostalAreaCode] = useState('');
  const [localAreaCode, setLocalAreaCode] = useState('');
  const [isOutOfArea, setIsOutOfArea] = useState(false);
  const [isPostalCodeValid, setIsPostalCodeValid] = useState(false);
  //電力会社
  const [electricPowerCompaniesList, setElectricPowerCompaniesList] = useState([]);
  const [isUnsimulatable, setIsUnsimulatable] = useState(false);
  const [selectedCompany, setSelectedCompany] = useState("default");
  //プラン
  const [planList, setPlanList] = useState([]);
  const [selectedPlan, setSelectedPlan] = useState("default");
  const [selectedPlanDescription, setSelectedPlanDescription] = useState("");
  //契約容量
  const [capacityList, setCapacityList] = useState([]);
  const [selectedCapacity, setSelectedCapacity] = useState("default");
  //電気代金
  const [electricBill, setElectricBill] = useState("");
  const [isInvalidElectricBill, setIsInvalidElectricBill] = useState(false);
  //メールアドレス
  const [emailAddress, setEmailAddress] = useState("");
  const [isInvalidEmailAddress, setIsInvalidEmailAddress] = useState(false);

  useEffect(() =>{
    if (postalAreaCode === "") {
      setIsOutOfArea(false);
      resetAllData();
    }
  },[postalAreaCode]);

  useEffect(() =>{
    if (!isOutOfArea && postalAreaCode.length === 3 && localAreaCode.length === 4) {
      setIsPostalCodeValid(true);
    } else {
      setIsPostalCodeValid(false);
    }
  },[isOutOfArea, postalAreaCode, localAreaCode]);

  useEffect(() =>{
    if (emailAddress === "") {
      setIsInvalidEmailAddress(false);
    }
  },[emailAddress]);

  //郵便番号
  const handleInputPostalAreaCode = e => {
    if (isNaN(e.target.value)) return;
    setPostalAreaCode(e.target.value);
    const userInputArea = postalAreaCode[0] || e.target.value;

    const validAreas = Object.keys(POSTAL_CODES_BY_AREA);
    const isValidArea = validAreas.includes(userInputArea);

    if (isValidArea) {
      setIsOutOfArea(false);
      if (postalAreaCode[0] === undefined) {
        initializeElectricPowerCompaniesList(userInputArea);
      }
    } else {
      setIsOutOfArea(true);
    }
  };

  const handleInputLocalAreaCode = e => {
    setLocalAreaCode(e.target.value);
  };

  //電力会社
  const initializeElectricPowerCompaniesList = userInputArea => {
    const area = POSTAL_CODES_BY_AREA[userInputArea];
    const result = COMPANIES_BY_AREA[area];
    setSelectedCompany("default");
    setElectricPowerCompaniesList(result);
  };

  const onSelectElectricPowerCompany = e => {
    setSelectedCompany(e.target.value);
    if (e.target.value === "other") {
      setIsUnsimulatable(true);
    } else {
      setIsUnsimulatable(false);
      initializePlanList(e.target.value);
    }
  };

  //プラン
  const initializePlanList = company => {
    if (company === "default" || company === "other") return;
    let arr = [];
    electricPowerCompaniesList.map(company => {
      company.plans?.map(plan => {
        arr.push(plan);
      })
    })
    setPlanList(arr);
  };

  const onSelectPlan= e => {
    setSelectedPlan(e.target.value);
    planList.map(plan => {
      if (plan.id === e.target.value) {
        setSelectedPlanDescription(plan.description);
        initializeCapacityList(plan.id, plan.capacity)
      }
    })
  };

  //契約容量
  const initializeCapacityList = (type, capacity) => {
    if (type === 'kepco-plan-1') {
      setSelectedCapacity("default");
    } else {
      setCapacityList(capacity);
    }
  };

  const onSelectCapacity= e => {
    setSelectedCapacity(e.target.value);
  };

  //電気代
  const handleInputElectricBill = e => {
    setElectricBill(e.target.value);
    validateElectricBill(e.target.value);
  };

  const validateElectricBill = bill => {
    setIsInvalidElectricBill(Number(bill) < 1000);
  };

  //メールアドレス
  const handleInputEmailAddress = e => {
    setEmailAddress(e.target.value);
    const result = validateEmailAddress(emailAddress);
    setIsInvalidEmailAddress(!result);
  };

  //結果を見る
  const handleClickSeeResult = () => {
    alert("complete");
  };
  
  //設定を全てリセットする
  const resetAllData = () => {
    //電力会社
    setElectricPowerCompaniesList([]);
    setIsUnsimulatable(false);
    //プラン
    setPlanList([]);
    setSelectedPlan("default");
    setSelectedPlanDescription("");
    //契約容量
    setCapacityList([]);
    setSelectedCapacity("default");
  };

  const isSelectedCompanyValid = selectedCompany !== "default" && selectedCompany !== "other";
  const isSelectedPlanValid = selectedPlan !== "default" && selectedPlan !== "kepco-plan-1";
  const isSelectedCapacityValid = selectedPlan === "kepco-plan-1" || selectedCapacity !== "default";
  const isInputElectricBillValid = Number(electricBill) >= 1000;
  const isAllSet = isSelectedCompanyValid && isSelectedCapacityValid && isInputElectricBillValid && validateEmailAddress(emailAddress);

  return (
    <Wrapper>
      <Headline />
      <Content>
        <Caption innerText="郵便番号をご入力ください" />
        <InputPostalCode
          inputPostalAreaCode={handleInputPostalAreaCode}
          inputLocalAreaCode={handleInputLocalAreaCode}
          isOutOfArea={isOutOfArea}
        />
      </Content>
      <Content>
        <Caption innerText="電気のご使用状況について教えてください" />
        <SelectElectricPowerCompany
          onSelect={onSelectElectricPowerCompany}
          companiesList={electricPowerCompaniesList}
          isUnsimulatable={isUnsimulatable}
          isActive={isPostalCodeValid}
          selectedCompany={selectedCompany}
        />
        <SelectPlan
          onSelect={onSelectPlan}
          planList={planList}
          isActive={isPostalCodeValid && isSelectedCompanyValid}
          selectedPlan={selectedPlan}
          selectedPlanDescription={selectedPlanDescription}
        />
        <SelectCapacity
          onSelect={onSelectCapacity}
          capacityList={capacityList}
          isActive={isPostalCodeValid && isSelectedPlanValid}
          selectedCapacity={selectedCapacity}
        />
      </Content>
      <Content>
        <Caption innerText="現在の電気の使用状況について教えてください" />
        <InputElectricBill
          inputElectricBill={handleInputElectricBill}
          isInvalidElectricBill={isInvalidElectricBill}
          isActive={isSelectedCapacityValid}
        />
      </Content>
      <Content>
        <Caption innerText="メールアドレスをご入力ください" />
        <InputEmailAddress
          inputElectricBill={handleInputEmailAddress}
          isInvalidEmailAddress={isInvalidEmailAddress}
          isActive={isInputElectricBillValid}
        />
      </Content>
      <ButtonWrapper>
        <Button
          innertext="結果を見る"
          onClick={handleClickSeeResult}
          isActive={isPostalCodeValid && isAllSet}
        />
      </ButtonWrapper>
    </Wrapper>
  );
};

export default Simulation;
