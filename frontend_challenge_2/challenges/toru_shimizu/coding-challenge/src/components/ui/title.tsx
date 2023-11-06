import styles from "./title.module.css";

type Props = {
  children: React.ReactNode;
};

export const Title = ({ children }: Props) => {
  return (
    <div className={styles.title}>
      <h2>{children}</h2>
    </div>
  );
};
