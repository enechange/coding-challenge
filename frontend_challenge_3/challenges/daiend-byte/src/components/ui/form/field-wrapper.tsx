import { ErrorMessage } from './error';
import { HelpText } from './help-text';
import { RequiredBadge } from './required-badge';

export type FieldWrapperPassThroughProps = {
    label: string;
    required?: boolean;
    error?: string;
    helpText?: string;
};

type FieldWrapperProps = FieldWrapperPassThroughProps & {
    htmlFor: string;
    errorId?: string;
    helpTextId?: string;
    children: React.ReactNode;
};

export function FieldWrapper({
    label,
    htmlFor,
    required = false,
    error,
    errorId,
    helpText,
    helpTextId,
    children,
}: FieldWrapperProps) {
    return (
        <div className="flex flex-col gap-1.5">
            <label
                htmlFor={htmlFor}
                className="flex items-center gap-2 text-base font-bold text-text"
            >
                {required && <RequiredBadge />}
                {label}
            </label>
            <div>
                {children}
                {helpText && <HelpText id={helpTextId}>{helpText}</HelpText>}
            </div>
            {error && <ErrorMessage id={errorId}>{error}</ErrorMessage>}
        </div>
    );
}
