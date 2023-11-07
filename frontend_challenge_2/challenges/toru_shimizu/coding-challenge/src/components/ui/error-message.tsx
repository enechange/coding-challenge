import styles from "./error-message.module.scss";

interface Props {
  error: string;
}

export const ErrorMessage = ({ error }: Props) => {
  return (
    <div className={styles.errorWrapper}>
      <p className={styles.message}>
        <span className={styles.warn} />
        <span className={styles.error}>{error}</span>
      </p>
    </div>
  );
};
