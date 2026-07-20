'use client';

import { useEffect, useState, type ReactNode } from 'react';

type RevealProps = {
    children: ReactNode;
};

// カスケードで下流フィールドが新規出現する際の出現アニメーション（ADR-0011）。
// マウント直後は0fr（高さ0）で描画し、次のレンダーで1frへ遷移させることで
// grid-template-rowsのtransitionを発火させる。自動フォーカス移動は行わない。
export function Reveal({ children }: RevealProps) {
    const [isOpen, setIsOpen] = useState(false);

    useEffect(() => {
        const id = requestAnimationFrame(() => {
            setIsOpen(true);
        });
        return () => {
            cancelAnimationFrame(id);
        };
    }, []);

    return (
        <div
            className="grid transition-[grid-template-rows] duration-300 ease-out"
            style={{ gridTemplateRows: isOpen ? '1fr' : '0fr' }}
        >
            <div className="overflow-hidden">{children}</div>
        </div>
    );
}
