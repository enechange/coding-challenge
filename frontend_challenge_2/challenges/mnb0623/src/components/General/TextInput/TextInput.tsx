import type { ChangeEvent } from 'react';
import styles from './TextInput.module.scss';

type Props = {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  disabled?: boolean;
  error?: string;
  className?: string;
  name?: string;
  id?: string;
  type?: 'text' | 'email' | 'number';
};

const TextInput: React.FC<Props> = ({
  value,
  onChange,
  placeholder = '入力してください',
  disabled = false,
  error,
  className = '',
  name,
  id,
  type = 'text',
}) => {
  const handleChange = (e: ChangeEvent<HTMLInputElement>) => {
    onChange(e.target.value);
  };

  return (
    <input
      type={type}
      value={value}
      onChange={handleChange}
      disabled={disabled}
      placeholder={placeholder}
      className={`${styles.input} ${error ? styles.error : ''} ${className}`}
      name={name}
      id={id}
    />
  );
};

export default TextInput;
