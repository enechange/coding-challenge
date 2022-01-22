import styles from "./Label.module.scss"

type Props = {
  htmlFor: string
  required?: boolean
}

const Label: React.FC<Props> = ({ children, htmlFor, required }) => {
  return (
    <label htmlFor={htmlFor} className={styles.label}>
      {required && <span className={styles.required}>必須</span>}
      {children}
    </label>
  )
}

export default Label
