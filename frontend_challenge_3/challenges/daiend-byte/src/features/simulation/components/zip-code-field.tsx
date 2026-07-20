'use client';

import { useZipCodeAreaCheck } from '../hooks/use-zip-code-area-check';

import { ZipCodeInput } from './zip-code-input';

export function ZipCodeField() {
    const {
        prefix,
        suffix,
        isChecking,
        errorMessage,
        onPrefixChange,
        onSuffixChange,
        onBlur,
    } = useZipCodeAreaCheck();

    return (
        <ZipCodeInput
            label="電気を使用する場所の郵便番号"
            required
            prefixValue={prefix}
            suffixValue={suffix}
            onPrefixChange={onPrefixChange}
            onSuffixChange={onSuffixChange}
            onBlur={onBlur}
            error={errorMessage}
            isChecking={isChecking}
        />
    );
}
