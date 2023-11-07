import { forwardRef, type ComponentPropsWithoutRef } from "react";
import { ErrorMessage } from "./error-message";
import styles from "./input.module.scss";
import { Label } from "./label";

type Props = {
  attention?: string;
  type?: string;
  label: string;
  error?: string;
  children?: React.ReactNode;
};

type ChildProps = ComponentPropsWithoutRef<"input"> & Props;

export const Input = forwardRef<HTMLInputElement, ChildProps>(
  ({ attention, type = "text", label, error, children, ...props }, ref) => {
    return (
      <div className={styles.inputWrapper}>
        <Label name={props.name}>{label}</Label>
        <div className={styles.input}>
          <input id={props.name} type={type} {...props} ref={ref} />
          {children}
        </div>
        {error === undefined && typeof attention === "string" && (
          <p className={styles.attention}>{attention}</p>
        )}
        {error !== undefined && typeof error === "string" && (
          <ErrorMessage error={error} />
        )}
      </div>
    );
  },
);

Input.displayName = "Input";
