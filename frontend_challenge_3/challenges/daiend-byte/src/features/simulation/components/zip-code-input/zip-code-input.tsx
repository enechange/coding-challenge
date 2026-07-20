'use client';

import { useId, useRef } from 'react';
import { FaSpinner } from 'react-icons/fa';

import {
    FieldWrapper,
    type FieldWrapperPassThroughProps,
} from '@/components/ui/form';

type ZipCodeInputProps = FieldWrapperPassThroughProps & {
    prefixValue: string;
    suffixValue: string;
    onPrefixChange: (value: string) => void;
    onSuffixChange: (value: string) => void;
    onBlur?: () => void;
    isChecking?: boolean;
};

function onlyDigits(value: string, maxLength: number): string {
    return value.replace(/\D/g, '').slice(0, maxLength);
}

// design.pngでは郵便番号のみ「130」「-」「0012」の3セルが1つの枠に収まる
// 構造で、他のInput/Select（64px）とは異なりボーダー込み48pxのコンパクトな
// サイズになっている（実測）。枠線は外側のflex containerが1つだけ持ち、
// 個々のinputは枠線なしで並べる。
export function ZipCodeInput({
    label,
    required,
    error,
    helpText,
    prefixValue,
    suffixValue,
    onPrefixChange,
    onSuffixChange,
    onBlur,
    isChecking = false,
}: ZipCodeInputProps) {
    const id = useId();
    const helpTextId = helpText ? `${id}-help-text` : undefined;
    const errorId = error ? `${id}-error` : undefined;
    const describedBy =
        [helpTextId, errorId].filter(Boolean).join(' ') || undefined;
    const containerRef = useRef<HTMLDivElement>(null);

    // prefix⇔suffix間のフォーカス移動を「フィールド全体からの離脱」と誤検知
    // しないよう、blurは外側のdivでまとめて受け、フォーカスが本当にコンテナ外
    // へ出た場合のみonBlurを呼ぶ。relatedTargetはモバイルでnullになることが
    // あるため使わず、次フレームでのactiveElementで判定する。
    function handleContainerBlur() {
        requestAnimationFrame(() => {
            if (
                containerRef.current &&
                !containerRef.current.contains(document.activeElement)
            ) {
                onBlur?.();
            }
        });
    }

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
            <div className="relative">
                {/* eslint-disable-next-line jsx-a11y/no-static-element-interactions --
                    このdiv自体は対話要素にならない。ネイティブでフォーカス可能な子要素
                    （下の2つのinput）だけが操作対象で、blurはその間のフォーカス移動を
                    束ねて観測しているだけなので、キーボード操作の代替は不要。 */}
                <div
                    ref={containerRef}
                    onBlur={handleContainerBlur}
                    className="flex overflow-hidden rounded-sm border-4 border-border bg-surface"
                >
                    <input
                        id={id}
                        required={required}
                        inputMode="numeric"
                        maxLength={3}
                        placeholder="130"
                        value={prefixValue}
                        onChange={(event) => {
                            onPrefixChange(onlyDigits(event.target.value, 3));
                        }}
                        aria-invalid={!!error}
                        aria-describedby={describedBy}
                        className="w-0 flex-1 bg-transparent px-3 py-2 text-center text-base text-text focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-accent/50"
                    />
                    <div className="flex w-8 items-center justify-center bg-border text-base text-text">
                        -
                    </div>
                    <input
                        id={`${id}-suffix`}
                        required={required}
                        inputMode="numeric"
                        maxLength={4}
                        placeholder="0012"
                        value={suffixValue}
                        onChange={(event) => {
                            onSuffixChange(onlyDigits(event.target.value, 4));
                        }}
                        aria-label={`${label}（下4桁）`}
                        aria-invalid={!!error}
                        aria-describedby={describedBy}
                        className="w-0 flex-1 bg-transparent px-3 py-2 text-center text-base text-text focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-accent/50"
                    />
                </div>
                {isChecking && (
                    <FaSpinner
                        aria-hidden="true"
                        className="pointer-events-none absolute top-1/2 right-3 size-4 -translate-y-1/2 animate-spin text-accent"
                    />
                )}
            </div>
            {isChecking && (
                <span role="status" className="sr-only">
                    サービスエリアを判定しています。
                </span>
            )}
        </FieldWrapper>
    );
}
