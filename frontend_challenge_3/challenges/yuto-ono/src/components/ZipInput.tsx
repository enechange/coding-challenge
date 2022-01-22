import styles from "./ZipInput.module.scss"

type Props = {
  name1: string
  name2: string
}

const ZipInput: React.FC<Props> = ({ name1, name2 }) => {
  return (
    <div className={styles.wrapper}>
      <input
        type="text"
        id={name1}
        name={name1}
        className={styles.input}
      />
      <span className={styles.hyphen}>-</span>
      <input
        type="text"
        id={name2}
        name={name2}
        className={styles.input}
      />
    </div>
  )
}

export default ZipInput
