import { UseFormRegisterReturn } from "react-hook-form"
import styles from "./Input.module.scss"

type Props = {
  name: string
  type?: string
  placeholder?: string
  registerReturn: UseFormRegisterReturn
}

const Input: React.FC<Props> = ({
  name,
  type = "text",
  placeholder,
  registerReturn,
}) => {
  return (
    <div className={styles.wrapper}>
      <input
        type={type} id={name}
        placeholder={placeholder}
        className={styles.input}
        {...registerReturn}
      />
    </div>
  )
}

export default Input
