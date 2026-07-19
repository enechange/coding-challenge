'use client';

import { useId } from 'react';

import {
    FieldWrapper,
    type FieldWrapperPassThroughProps,
} from '@/components/ui/form';

type ZipCodeInputProps = FieldWrapperPassThroughProps;

// design.pngでは郵便番号のみ「130」「-」「0012」の3セルが1つの枠に収まる
// 構造で、他のInput/Select（64px）とは異なりボーダー込み48pxのコンパクトな
// サイズになっている（実測）。枠線は外側のflex containerが1つだけ持ち、
// 個々のinputは枠線なしで並べる。
export function ZipCodeInput({
    label,
    required,
    error,
    helpText,
}: ZipCodeInputProps) {
    const id = useId();
    const helpTextId = helpText ? `${id}-help-text` : undefined;
    const errorId = error ? `${id}-error` : undefined;
    const describedBy =
        [helpTextId, errorId].filter(Boolean).join(' ') || undefined;

    return (
        <FieldWrapper
            label={label}
            htmlFor={id}
            required={required}
            error={error}
            errorId={errorId}
            helpText={helpText}
            helpTextId={helpTextId}
        >
            <div className="flex overflow-hidden rounded-sm border-4 border-border bg-surface">
                <input
                    id={id}
                    inputMode="numeric"
                    maxLength={3}
                    placeholder="130"
                    aria-invalid={!!error}
                    aria-describedby={describedBy}
                    className="w-0 flex-1 bg-transparent px-3 py-2 text-center text-base text-text focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-accent/50"
                />
                <div className="flex w-8 items-center justify-center bg-border text-base text-text">
                    -
                </div>
                <input
                    inputMode="numeric"
                    maxLength={4}
                    placeholder="0012"
                    aria-invalid={!!error}
                    aria-describedby={describedBy}
                    className="w-0 flex-1 bg-transparent px-3 py-2 text-center text-base text-text focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-accent/50"
                />
            </div>
        </FieldWrapper>
    );
}
