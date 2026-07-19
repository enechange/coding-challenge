import { type ButtonHTMLAttributes } from 'react';
import { FaChevronRight } from 'react-icons/fa';

import { cn } from '@/lib/cn';

// type="submit"の既定値は持たない。呼び出し側が用途に応じて指定する（ADR-0009）。
type ButtonProps = ButtonHTMLAttributes<HTMLButtonElement>;

// design.png通り、右端に白丸+シェブロンのアイコンを固定で表示する。
// テキストはアイコンの有無に関わらずボタン中央に来るよう、アイコンをabsolute配置にする。
export function Button({
    className,
    disabled,
    children,
    ...props
}: ButtonProps) {
    return (
        <button
            disabled={disabled}
            className={cn(
                'relative inline-flex w-full items-center justify-center rounded-sm px-4 py-4.5 text-lg transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-accent/50',
                disabled
                    ? 'cursor-not-allowed bg-disabled text-text'
                    : 'bg-primary text-white hover:bg-primary-hover hover:cursor-pointer active:bg-primary-active',
                className,
            )}
            {...props}
        >
            {children}
            <span
                aria-hidden="true"
                className="absolute right-4 flex size-5 items-center justify-center rounded-full bg-white"
            >
                <FaChevronRight
                    className={cn(
                        'pl-0.5 size-3.5',
                        disabled ? 'text-text' : 'text-primary',
                    )}
                />
            </span>
        </button>
    );
}
