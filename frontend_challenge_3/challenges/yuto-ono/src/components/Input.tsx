import styles from "./Input.module.scss"

type Props = {
  name: string
}

const Input: React.FC<Props> = ({ name }) => {
  return (
    <div className={styles.wrapper}>
      <input type="text" id={name} name={name} className={styles.input} />
    </div>
  )
}

export default Input
