import styles from "./Submit.module.scss"

type Props = {
  disabled?: boolean
}

const Submit: React.FC<Props> = ({ children, disabled = false }) => {
  return (
    <button type="submit" className={styles.btn} disabled={disabled}>
      {children}
    </button>
  )
}

export default Submit
