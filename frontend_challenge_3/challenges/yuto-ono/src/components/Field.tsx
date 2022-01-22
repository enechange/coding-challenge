import styles from "./Field.module.scss"

const Field: React.FC = ({ children }) => {
  return (
    <div className={styles.field}>
      {children}
    </div>
  )
}

export default Field
