import { useFormContext } from "react-hook-form"
import styles from "./BillInput.module.scss"
import Input from "./Input"

const BillInput: React.FC = () => {
  const { register } = useFormContext()

  return (
    <div className={styles.wrapper}>
      <div className={styles.bill}>
        <Input
          name="bill"
          registerReturn={register("bill", {
            required: "電気代を入力してください。",
            valueAsNumber: true,
            min: {
              value: 1000,
              message: "電気代を正しく入力してください。",
            },
            pattern: {
              value: /^\d+$/,
              message: "電気代を正しく入力してください。",
            },
          })}
        />
      </div>
      <span className={styles.yen}>円</span>
    </div>
  )
}

export default BillInput
