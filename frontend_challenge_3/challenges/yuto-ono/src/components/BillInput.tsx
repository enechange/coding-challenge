import styles from "./BillInput.module.scss"
import Input from "./Input"

const BillInput: React.FC = () => {
  return (
    <div className={styles.wrapper}>
      <div className={styles.bill}>
        <Input name="bill" />
      </div>
      <span className={styles.yen}>円</span>
    </div>
  )
}

export default BillInput
