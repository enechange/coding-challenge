import styles from "./Input.module.scss"

type Props = {
  name: string
  type?: string
  placeholder?: string
}

const Input: React.FC<Props> = ({ name, type = "text", placeholder }) => {
  return (
    <div className={styles.wrapper}>
      <input
        type={type} id={name} name={name}
        placeholder={placeholder}
        className={styles.input}
      />
    </div>
  )
}

export default Input
