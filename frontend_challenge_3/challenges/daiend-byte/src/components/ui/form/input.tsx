'use client';

import { useId, type InputHTMLAttributes } from 'react';
import type { UseFormRegisterReturn } from 'react-hook-form';

import { cn } from '@/lib/cn';

import {
    FieldWrapper,
    type FieldWrapperPassThroughProps,
} from './field-wrapper';

type InputProps = FieldWrapperPassThroughProps &
    Omit<InputHTMLAttributes<HTMLInputElement>, 'id'> & {
        registration?: Partial<UseFormRegisterReturn>;
    };

export function Input({
    label,
    required,
    error,
    helpText,
    className,
    registration,
    ...props
}: InputProps) {
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
            <input
                id={id}
                required={required}
                aria-invalid={!!error}
                aria-describedby={describedBy}
                className={cn(
                    'w-full border-4 border-border bg-surface px-3 py-4 text-base text-text focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-accent/50',
                    helpText ? 'rounded-t-sm' : 'rounded-sm',
                    className,
                )}
                {...registration}
                {...props}
            />
        </FieldWrapper>
    );
}
