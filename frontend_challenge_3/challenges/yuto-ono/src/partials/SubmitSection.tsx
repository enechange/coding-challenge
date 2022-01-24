import { useFormContext } from "react-hook-form"
import Submit from "../components/Submit"
import styles from "./SubmitSection.module.scss"

const SubmitSection: React.FC = () => {
  const { formState: { isValid } } = useFormContext()

  return (
    <div className={styles.section}>
      <Submit disabled={!isValid}>結果を見る</Submit>
    </div>
  )
}

export default SubmitSection
