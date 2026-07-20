'use client';

import { useRef, useState } from 'react';
import { useFormContext } from 'react-hook-form';

import { checkServiceArea } from '../api/check-service-area';
import type { SimulationFormInput } from '../schemas/simulation-form-schema';

import { ZipCodeInput } from './zip-code-input';

const ZIP_CODE_LENGTH = 7;

export function ZipCodeField() {
    const {
        setValue,
        formState: { errors },
    } = useFormContext<SimulationFormInput>();

    const [prefix, setPrefix] = useState('');
    const [suffix, setSuffix] = useState('');
    const [hasBlurred, setHasBlurred] = useState(false);
    const [isChecking, setIsChecking] = useState(false);
    const [hasCheckError, setHasCheckError] = useState(false);
    const lastCheckedZipCode = useRef<string | null>(null);

    async function checkArea(zipCode: string) {
        if (
            zipCode.length !== ZIP_CODE_LENGTH ||
            zipCode === lastCheckedZipCode.current
        ) {
            return;
        }

        lastCheckedZipCode.current = zipCode;
        setIsChecking(true);
        try {
            const areaId = await checkServiceArea(zipCode);
            // 待機中により新しい郵便番号のチェックが開始されていたら、
            // 遅れて返ってきたこのレスポンスは古いので反映しない
            if (lastCheckedZipCode.current !== zipCode) {
                return;
            }
            setValue('areaId', areaId, { shouldValidate: true });
            setHasCheckError(false);
        } catch {
            if (lastCheckedZipCode.current !== zipCode) {
                return;
            }
            setHasCheckError(true);
        } finally {
            if (lastCheckedZipCode.current === zipCode) {
                setIsChecking(false);
            }
        }
    }

    function updateZipCode(nextPrefix: string, nextSuffix: string) {
        const zipCode = `${nextPrefix}${nextSuffix}`;
        const isComplete = zipCode.length === ZIP_CODE_LENGTH;
        setValue('zipCode', zipCode, {
            shouldValidate: hasBlurred || isComplete,
        });
        setHasCheckError(false);
        // 7桁揃った時点で、フィールドを離れるのを待たずエリア判定を開始する
        void checkArea(zipCode);
    }

    function handleBlur() {
        setHasBlurred(true);
        void checkArea(`${prefix}${suffix}`);
    }

    const isComplete = `${prefix}${suffix}`.length === ZIP_CODE_LENGTH;
    const errorMessage =
        !hasBlurred && !isComplete
            ? undefined
            : hasCheckError
              ? '通信エラーが発生しました。時間をおいて再度お試しください。'
              : isChecking
                ? undefined
                : (errors.zipCode?.message ?? errors.areaId?.message);

    return (
        <ZipCodeInput
            label="電気を使用する場所の郵便番号"
            required
            prefixValue={prefix}
            suffixValue={suffix}
            onPrefixChange={(value) => {
                setPrefix(value);
                updateZipCode(value, suffix);
            }}
            onSuffixChange={(value) => {
                setSuffix(value);
                updateZipCode(prefix, value);
            }}
            onBlur={handleBlur}
            error={errorMessage}
            isChecking={isChecking}
        />
    );
}
