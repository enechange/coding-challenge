import styles from "./form-content.module.scss";
import { Title } from "./title";

type Props = {
  title: string;
  children: React.ReactNode;
};

export const FormContent = ({ title, children }: Props) => {
  return (
    <div className={styles.formContent}>
      <Title>{title}</Title>
      <div className={styles.inputWrapper}>{children}</div>
    </div>
  );
};
