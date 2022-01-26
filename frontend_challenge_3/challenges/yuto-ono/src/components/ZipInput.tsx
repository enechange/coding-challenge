import { useFormContext } from "react-hook-form"
import styles from "./ZipInput.module.scss"

type Props = {
  name1: string
  name2: string
}

const MESSAGE_REQUIRED = "郵便番号を入力してください。"
const MESSAGE_INVALID  = "郵便番号を正しく入力してください。"

const ZipInput: React.FC<Props> = ({ name1, name2 }) => {
  const { register } = useFormContext()

  return (
    <div className={styles.wrapper}>
      <input
        type="text"
        id={name1}
        className={styles.input}
        {...register(name1, {
          required: MESSAGE_REQUIRED,
          pattern: {
            value: /^\d{3}$/,
            message: MESSAGE_INVALID,
          },
        })}
      />
      <span>-</span>
      <input
        type="text"
        id={name2}
        className={styles.input}
        {...register(name2, {
          required: MESSAGE_REQUIRED,
          pattern: {
            value: /^\d{4}$/,
            message: MESSAGE_INVALID,
          },
        })}
      />
    </div>
  )
}

export default ZipInput
