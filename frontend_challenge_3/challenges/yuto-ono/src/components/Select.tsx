import styles from "./Select.module.scss"

type Props = {
  name: string
}

const Select: React.FC<Props> = ({ name }) => {
  return (
    <div className={styles.wrapper}>
      <select name={name} id={name} className={styles.select}>
        <option value="">東京電力エナジーパートナー</option>
      </select>
    </div>
  )
}

export default Select
