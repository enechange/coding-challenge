type HelpTextProps = {
    id?: string;
    children: React.ReactNode;
};

// design.pngではHelpTextは常に直前のSelect/Inputに隙間なく連結する表示。上端の
// 角丸を無くし継ぎ目に白の点線ボーダーを描画することで、「入力欄と説明文が1つの
// 帯として繋がって見える」見た目を再現する。
export function HelpText({ id, children }: HelpTextProps) {
    return (
        <p
            id={id}
            className="rounded-b-sm border-t-1 border-dotted border-white bg-border px-3 py-1.5 text-xs text-text"
        >
            {children}
        </p>
    );
}
