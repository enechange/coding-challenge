import styles from "./label.module.scss";

type Props = {
  name?: string;
  children: React.ReactNode;
};

export const Label = ({ name, children }: Props) => {
  return (
    <label className={styles.label} htmlFor={name}>
      <span className={styles.required}>必須</span>
      {children}
    </label>
  );
};
