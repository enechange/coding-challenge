// design.pngの配色（danger塗り+白文字）を優先する（ADR-0018）。
export function RequiredBadge() {
    return (
        <span className="inline-flex items-center bg-danger pl-2 pr-1 py-0.5 text-2xs font-bold text-white tracking-widest">
            必須
        </span>
    );
}
