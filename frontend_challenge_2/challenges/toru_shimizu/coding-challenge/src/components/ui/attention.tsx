import styles from "./attention.module.scss";
type Props = {
  text: string;
};
export const Attention = ({ text }: Props) => {
  return <div className={styles.attention}>{text}</div>;
};
