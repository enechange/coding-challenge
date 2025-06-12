import React from 'react';
import styles from './FormField.module.scss';
import ErrorMessage from '../ErrorMessage/ErrorMessage';

type Props = {
  label: string;
  name: string;
  required?: boolean;
  error?: string;
  className?: string;
  children?: React.ReactNode;
  endAdornment?: string;
};

const FormField: React.FC<Props> = ({
  label,
  name,
  required,
  error,
  className = '',
  children,
  endAdornment,
}) => {
  const fieldId = `form-field-${name}`;

  const combinedClassName = [
    styles.formField,
    className,
    error ? styles.hasError : '',
  ]
    .filter(Boolean)
    .join(' ');

  return (
    <div className={combinedClassName}>
      <label htmlFor={fieldId} className={styles.label}>
        {required && <span className={styles.required}>必須</span>}
        {label}
      </label>
      <div className={styles.inputWrapper}>
        <div className={styles.inputContainer}>{children}</div>
        {endAdornment && (
          <span className={styles.endAdornment}>{endAdornment}</span>
        )}
      </div>
      {error && <ErrorMessage message={error} />}
    </div>
  );
};

export default FormField;
