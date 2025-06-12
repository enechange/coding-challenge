import React from 'react';
import styles from './Button.module.scss';

type Props = {
  variant?: 'primary';
  hasArrow?: boolean;
  isSubmitting?: boolean;
  children: React.ReactNode;
} & React.ComponentPropsWithoutRef<'button'>;

const Button: React.FC<Props> = ({
  children,
  variant = 'primary',
  hasArrow = false,
  isSubmitting = false,
  className,
  ...rest
}) => {
  const buttonClasses = [
    styles.button,
    styles[variant],
    isSubmitting ? styles.isSubmitting : '',
    className,
  ]
    .filter(Boolean)
    .join(' ');

  return (
    <button className={buttonClasses} {...rest}>
      {isSubmitting ? <span className={styles.loadingSpinner}></span> : null}
      {children}
      {hasArrow && <ArrowIcon />}
    </button>
  );
};
export default Button;

const ArrowIcon: React.FC = () => (
  <div className={styles.arrowContainer}>
    <svg className={styles.icon} viewBox="0 0 24 24">
      <circle cx="12" cy="12" r="12" className={styles.iconCircle} />
    </svg>
    <span className={styles.arrow}></span>
  </div>
);
