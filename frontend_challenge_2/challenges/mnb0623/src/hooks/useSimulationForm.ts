import { useMemo, useState } from 'react';
import { type PlanKey, type CompanyKey } from '../constants/powerDataConfig';
import { VALIDATION_MESSAGES } from '../constants/validationMessage';
import { isNumeric, isEmailPattern } from '../utils/validationRules';

type SimulationFormData = {
  postalCode: string;
  area: CompanyKey; // 'tokyo' | 'kansai' | 'other'
  powerCompany: CompanyKey | '';
  servicePlan: PlanKey<CompanyKey> | '';
  contractCapacity: string;
  lastMonthAmount: string;
  mailAddress: string;
};

type FormField =
  | 'postalCode'
  | 'powerCompany'
  | 'servicePlan'
  | 'contractCapacity'
  | 'lastMonthAmount'
  | 'mailAddress';

type FormErrors = {
  postalCode?: string;
  powerCompany?: string;
  servicePlan?: string;
  contractCapacity?: string;
  lastMonthAmount?: string;
  mailAddress?: string;
};

const validatePostalCode = (value: string): string | null => {
  if (!value) {
    return null;
  }
  if (!isNumeric(value)) {
    return VALIDATION_MESSAGES.POSTAL_CODE.NUMBERS_ONLY;
  }
  const firstDigit = value.charAt(0);
  if (firstDigit !== '1' && firstDigit !== '5') {
    return VALIDATION_MESSAGES.POSTAL_CODE.OUT_OF_SERVICE_AREA;
  }

  return null;
};

// 郵便番号からエリアを判定する関数
const determineAreaFromPostalCode = (value: string): CompanyKey => {
  if (value.length === 7) {
    const firstDigit = value.charAt(0);
    if (firstDigit === '1') return 'tokyo';
    if (firstDigit === '5') return 'kansai';
  }
  return 'other';
};
// 電力会社の選択肢を検証する関数
const validatePowerCompany = (value: string): string | null => {
  if (value === 'other') {
    return VALIDATION_MESSAGES.POWER_COMPANY.NOT_SUPPORTED;
  }
  return null;
};

const validateAmount = (value: string): string | null => {
  if (!value) {
    return null;
  }
  if (!isNumeric(value)) {
    return VALIDATION_MESSAGES.AMOUNT.NUMBERS_ONLY;
  }
  const amount = parseInt(value, 10);
  if (isNaN(amount) || amount < 1000) {
    return VALIDATION_MESSAGES.AMOUNT.MINIMUM_AMOUNT;
  }
  return null;
};

const validateMailAddress = (value: string): string | null => {
  if (!isEmailPattern(value)) {
    return VALIDATION_MESSAGES.MAIL_ADDRESS.INVALID_FORMAT;
  }
  return null;
};

export const useSimulationForm = () => {
  const [formData, setFormData] = useState<SimulationFormData>({
    postalCode: '',
    powerCompany: '',
    area: 'other',
    servicePlan: '',
    contractCapacity: '',
    lastMonthAmount: '',
    mailAddress: '',
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [errors, setErrors] = useState<FormErrors>({});

  const handleChange = (field: FormField, value: string) => {
    setFormData((prev) => ({
      ...prev,
      [field]: value,
    }));

    let error: string | null = null;

    switch (field) {
      case 'postalCode': {
        const postalCodeError = validatePostalCode(value);
        error = postalCodeError ?? null;

        const newArea = determineAreaFromPostalCode(value);
        setFormData((prev) => ({
          ...prev,
          area: newArea,
          powerCompany: '',
          servicePlan: '',
          contractCapacity: '',
        }));
        break;
      }
      case 'powerCompany': {
        error = validatePowerCompany(value);
        // 電力会社が選択された場合、サービスプランと契約容量をリセット
        setFormData((prev) => ({
          ...prev,
          servicePlan: '',
          contractCapacity: '',
        }));
        break;
      }
      case 'servicePlan': {
        // サービスプランが選択された場合、契約容量をリセット
        setFormData((prev) => ({
          ...prev,
          contractCapacity: '',
        }));
        break;
      }
      case 'contractCapacity': {
        error = null;
        break;
      }
      case 'lastMonthAmount': {
        error = validateAmount(value);
        break;
      }
      case 'mailAddress': {
        error = validateMailAddress(value);
        break;
      }
    }

    setErrors((prev) => ({
      ...prev,
      [field]: error ?? undefined,
    }));
  };

  const isFormValid = useMemo(() => {
    if (
      !formData.postalCode ||
      !formData.powerCompany ||
      !formData.servicePlan ||
      !formData.lastMonthAmount ||
      !formData.mailAddress
    ) {
      return false;
    }

    // 関西電力従量電灯Aの場合は、契約容量を聴取しない = その他の条件では契約容量が必須
    const isCapacityNotRequired =
      formData.powerCompany === 'kansai' &&
      formData.servicePlan === 'meteredPlanA';
    if (!formData.contractCapacity && !isCapacityNotRequired) {
      return false;
    }

    if (Object.values(errors).some((error) => !!error)) {
      return false;
    }

    // 全てのチェックをクリアした場合のみtrueを返す
    return true;
  }, [formData, errors]);

  const handleSubmit = async () => {
    try {
      // 送信処理 擬似的に1秒待機
      setIsSubmitting(true);
      await new Promise((resolve) => setTimeout(resolve, 1000));
      console.log('送信データ:', formData);
    } catch (error) {
      console.error('送信エラー:', error);
      throw error;
    } finally {
      setIsSubmitting(false);
      alert('送信完了:');
    }
  };

  return {
    formData,
    errors,
    handleChange,
    isFormValid,
    handleSubmit,
    isSubmitting,
  };
};
