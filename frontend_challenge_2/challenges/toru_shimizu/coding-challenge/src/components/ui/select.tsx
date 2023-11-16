import { forwardRef, type ComponentPropsWithoutRef } from "react";
import { Attention } from "./attention";
import { ErrorMessage } from "./error-message";
import { Label } from "./label";
import styles from "./select.module.scss";

type Props = {
  attention?: string;
  name: string;
  options: string[];
  label: string;
  error?: string;
};

type ChildProps = ComponentPropsWithoutRef<"select"> & Props;

export const Select = forwardRef<HTMLSelectElement, ChildProps>(
  ({ attention, label, error, options, ...props }, ref) => {
    const existsOptions = options.length > 0;

    return (
      <div className={styles.selectWrapper}>
        <Label name={props.name}>{label}</Label>
        <div>
          <select
            id={props.name}
            className={`${styles.select} ${
              !existsOptions ? styles.disabled : ""
            }`}
            {...props}
            ref={ref}
          >
            {existsOptions ? (
              <>
                <option value="">{label}を選択してください</option>
                {options.map((option) => (
                  <option key={option}>{option}</option>
                ))}
              </>
            ) : (
              <option value="">選択できる{label}がありません</option>
            )}
          </select>
          {attention && <Attention text={attention} />}
        </div>
        {existsOptions && error && <ErrorMessage error={error} />}
      </div>
    );
  },
);

Select.displayName = "Select";
