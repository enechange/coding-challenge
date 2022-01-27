import { UseFormRegisterReturn } from "react-hook-form"
import styles from "./Select.module.scss"
import { SelectOptions } from "../utilities/SelectOptions"

type Props = {
  name: string
  options: SelectOptions
  desc?: string
  registerReturn: UseFormRegisterReturn
}

const Select: React.FC<Props> = ({ name, options, desc, registerReturn }) => {
  return (
    <div className={styles.wrapper}>
      <select
        id={name}
        className={styles.select}
        {...registerReturn}
      >
        {options.map(option => (
          <option key={option.value} value={option.value}>
            {option.text ?? option.value}
          </option>
        ))}
      </select>
      {desc && <div className={styles.desc}>{desc}</div>}
    </div>
  )
}

export default Select
