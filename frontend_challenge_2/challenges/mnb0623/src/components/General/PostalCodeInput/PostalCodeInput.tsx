import React, { useRef, type ChangeEvent, type KeyboardEvent } from 'react';
import styles from './PostalCodeInput.module.scss';

type Props = {
  value: string;
  onChange: (value: string) => void;
  disabled?: boolean;
  error?: string;
  placeholder?: string;
};

const PostalCodeInput: React.FC<Props> = ({
  value = '',
  onChange,
  disabled,
  error,
  placeholder = '1234567',
}) => {
  const firstInputRef = useRef<HTMLInputElement>(null);
  const secondInputRef = useRef<HTMLInputElement>(null);
  // 7桁でない場合はデフォルト値にする
  const safePlaceholder =
    placeholder && placeholder.length === 7 ? placeholder : '1234567';
  const firstPlaceholder = safePlaceholder.slice(0, 3);
  const secondPlaceholder = safePlaceholder.slice(3, 7);

  // valueを3桁と4桁に分割して各inputに表示
  const firstPart = value.slice(0, 3);
  const secondPart = value.slice(3, 7);

  const handleFirstChange = (e: ChangeEvent<HTMLInputElement>) => {
    const newValue = e.target.value;
    if (newValue.length <= 3) {
      const combinedValue = (newValue + secondPart).slice(0, 7);
      onChange(combinedValue);

      // 3桁入力されたら次のinputにフォーカス
      if (newValue.length === 3) {
        secondInputRef.current?.focus();
      }
    }
  };

  // 2つ目の入力欄の処理
  const handleSecondChange = (e: ChangeEvent<HTMLInputElement>) => {
    const newValue = e.target.value;
    if (newValue.length <= 4) {
      const combinedValue = (firstPart + newValue).slice(0, 7);
      onChange(combinedValue);
    }
  };

  const handleSecondKeyDown = (e: KeyboardEvent<HTMLInputElement>) => {
    // Backspaceキーが押されたときに、2つ目のinputが空なら1つ目のinputにフォーカスを戻す
    if (e.key === 'Backspace' && secondPart === '') {
      firstInputRef.current?.focus();
    }
  };

  const combinedClassName = [styles.input, error ? styles.hasError : '']
    .filter(Boolean)
    .join(' ');

  return (
    <div className={styles.container}>
      <input
        ref={firstInputRef}
        type="text"
        maxLength={3}
        value={firstPart}
        onChange={handleFirstChange}
        disabled={disabled}
        className={combinedClassName}
        placeholder={firstPlaceholder}
      />
      <span className={styles.hyphen}>-</span>
      <input
        ref={secondInputRef}
        type="text"
        maxLength={4}
        value={secondPart}
        onChange={handleSecondChange}
        onKeyDown={handleSecondKeyDown}
        disabled={disabled}
        className={combinedClassName}
        placeholder={secondPlaceholder}
      />
    </div>
  );
};

export default PostalCodeInput;
