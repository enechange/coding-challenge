import type { ChangeEvent } from 'react';
import styles from './SelectBox.module.scss';

export type SelectOption = {
  value: string;
  label: string;
  disabled?: boolean;
};

type Props = {
  value: string;
  options: SelectOption[];
  onChange: (value: string) => void;
  placeholder?: string;
  disabled?: boolean;
  error?: string;
  className?: string;
  name?: string;
  id?: string;
};

const SelectBox: React.FC<Props> = ({
  value,
  options,
  onChange,
  placeholder = '選択してください',
  disabled = false,
  error,
  className = '',
  name,
  id,
}: Props) => {
  const handleChange = (e: ChangeEvent<HTMLSelectElement>) => {
    onChange(e.target.value);
  };

  return (
    <div className={styles.wrapper}>
      <select
        value={value}
        onChange={handleChange}
        disabled={disabled}
        className={`${styles.select} ${error ? styles.error : ''} ${className}`}
        name={name}
        id={id}
      >
        {placeholder && (
          <option value="" disabled>
            {placeholder}
          </option>
        )}
        {options.map((option) => (
          <option
            key={option.value}
            value={option.value}
            disabled={option.disabled}
          >
            {option.label}
          </option>
        ))}
      </select>
    </div>
  );
};

export default SelectBox;
