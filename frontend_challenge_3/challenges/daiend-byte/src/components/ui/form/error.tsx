import { FaExclamationTriangle } from 'react-icons/fa';

type ErrorMessageProps = {
    id?: string;
    children: React.ReactNode;
};

// role="alert"によりDOM追加時にスクリーンリーダーへ自動通知される（ADR-0018）。
// design.pngの配色（danger塗り+白文字）を優先する。白文字自体のコントラスト比は
// WCAG AA基準に届かないが、ADR-0018で許容する判断としている。
export function ErrorMessage({ id, children }: ErrorMessageProps) {
    return (
        <p
            id={id}
            role="alert"
            className="flex items-center gap-1.5 rounded bg-danger px-3 py-2 text-xs text-white"
        >
            <FaExclamationTriangle
                aria-hidden="true"
                className="size-4 shrink-0"
            />
            {children}
        </p>
    );
}
