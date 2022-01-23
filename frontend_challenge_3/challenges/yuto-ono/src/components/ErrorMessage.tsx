import styles from "./ErrorMessage.module.scss"

const ErrorMessage: React.FC = ({ children }) => {
  return (
    <div className={styles.error}>{children}</div>
  )
}

export default ErrorMessage
