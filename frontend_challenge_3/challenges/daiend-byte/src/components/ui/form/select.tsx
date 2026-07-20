'use client';

import { useId, type SelectHTMLAttributes } from 'react';
import type { UseFormRegisterReturn } from 'react-hook-form';
import { FaChevronDown } from 'react-icons/fa';

import { cn } from '@/lib/cn';

import {
    FieldWrapper,
    type FieldWrapperPassThroughProps,
} from './field-wrapper';

type SelectOption = {
    label: string;
    value: string;
};

type SelectProps = FieldWrapperPassThroughProps &
    Omit<SelectHTMLAttributes<HTMLSelectElement>, 'id'> & {
        options: SelectOption[];
        placeholder?: string;
        registration?: Partial<UseFormRegisterReturn>;
    };

export function Select({
    label,
    required,
    error,
    helpText,
    className,
    options,
    placeholder = '選択してください',
    registration,
    value,
    ...props
}: SelectProps) {
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
            <div className="relative">
                <FaChevronDown
                    aria-hidden="true"
                    className="pointer-events-none absolute top-1/2 left-3 size-6 -translate-y-1/2 text-accent"
                />
                <select
                    id={id}
                    required={required}
                    aria-invalid={!!error}
                    aria-describedby={describedBy}
                    // カスケードセレクト（RHFのuseController）はvalueで制御するため、
                    // defaultValueと同時指定にならないようどちらか一方のみ渡す
                    {...(value === undefined
                        ? { defaultValue: '' }
                        : { value })}
                    className={cn(
                        'w-full appearance-none border-4 border-border bg-surface py-3.5 pr-3 pl-10 text-lg text-text focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-accent/50',
                        helpText ? 'rounded-t-sm' : 'rounded-sm',
                        className,
                    )}
                    {...registration}
                    {...props}
                >
                    <option value="" disabled>
                        {placeholder}
                    </option>
                    {options.map((option) => (
                        <option key={option.value} value={option.value}>
                            {option.label}
                        </option>
                    ))}
                </select>
            </div>
        </FieldWrapper>
    );
}
