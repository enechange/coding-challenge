import styles from "./Submit.module.scss"

const Submit: React.FC = ({ children }) => {
  return <button type="submit" className={styles.btn}>{children}</button>
}

export default Submit
