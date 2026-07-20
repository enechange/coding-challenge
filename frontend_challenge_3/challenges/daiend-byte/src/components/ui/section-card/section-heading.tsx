import { type ReactNode } from 'react';

import { cn } from '@/lib/cn';

type SectionHeadingProps = {
    className?: string;
    children: ReactNode;
};

// アクセントボーダーはカードの左端(パディング無しの位置)から描画し、
// テキスト開始位置はborder-l-4(4px)+pl-3(12px)=16pxでSectionCard本文側の
// px-4と揃える。
export function SectionHeading({ className, children }: SectionHeadingProps) {
    return (
        <h2
            className={cn(
                'border-l-4 border-accent py-2 pr-4 pl-3 text-lg font-bold text-text',
                className,
            )}
        >
            {children}
        </h2>
    );
}
