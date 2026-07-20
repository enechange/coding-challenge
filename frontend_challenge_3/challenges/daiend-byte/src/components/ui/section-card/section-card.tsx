import { type ReactNode } from 'react';

import { cn } from '@/lib/cn';

import { SectionHeading } from './section-heading';

type SectionCardProps = {
    heading: ReactNode;
    className?: string;
    children: ReactNode;
};

export function SectionCard({
    heading,
    className,
    children,
}: SectionCardProps) {
    return (
        <div className={cn('flex flex-col gap-4 bg-surface py-6', className)}>
            <SectionHeading>{heading}</SectionHeading>
            <div className="flex flex-col gap-4 px-4">{children}</div>
        </div>
    );
}
