'use client';

import { useRef, useState } from 'react';
import { useFormContext } from 'react-hook-form';

import { checkServiceArea } from '../api/check-service-area';
import { ZIP_CODE_LENGTH } from '../data/constants';
import type { SimulationFormInput } from '../schemas/simulation-form-schema';

// ZipCodeInput（分割入力欄）の状態管理・エリア判定APIの非同期呼び出し・
// 競合状態のガードをまとめたフック。react-hook-form の FormProvider 配下
// でのみ動作する（内部で useFormContext を参照するため）
export function useZipCodeAreaCheck() {
    const {
        setValue,
        formState: { errors, touchedFields },
    } = useFormContext<SimulationFormInput>();

    const [prefix, setPrefix] = useState('');
    const [suffix, setSuffix] = useState('');
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
        setValue('zipCode', zipCode, { shouldValidate: true });
        setHasCheckError(false);
        if (zipCode.length !== ZIP_CODE_LENGTH) {
            // 一度エリア判定済みの状態から7桁未満に編集された場合、古いareaIdの
            // ままだと電力会社欄以降が活性化したままになってしまうため失効させる
            lastCheckedZipCode.current = null;
            setValue('areaId', null, { shouldValidate: true });
            return;
        }
        // 7桁揃った時点で、フィールドを離れるのを待たずエリア判定を開始する
        void checkArea(zipCode);
    }

    function handlePrefixChange(value: string) {
        setPrefix(value);
        updateZipCode(value, suffix);
    }

    function handleSuffixChange(value: string) {
        setSuffix(value);
        updateZipCode(prefix, value);
    }

    function handleBlur() {
        setValue('zipCode', `${prefix}${suffix}`, { shouldTouch: true });
    }

    const isComplete = `${prefix}${suffix}`.length === ZIP_CODE_LENGTH;
    const errorMessage =
        !touchedFields.zipCode && !isComplete
            ? undefined
            : hasCheckError
              ? '通信エラーが発生しました。時間をおいて再度お試しください。'
              : isChecking
                ? undefined
                : (errors.zipCode?.message ?? errors.areaId?.message);

    return {
        prefix,
        suffix,
        isChecking,
        errorMessage,
        onPrefixChange: handlePrefixChange,
        onSuffixChange: handleSuffixChange,
        onBlur: handleBlur,
    };
}
