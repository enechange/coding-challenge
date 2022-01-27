import { useFormContext, useWatch } from "react-hook-form"
import Submit from "../components/Submit"
import styles from "./SubmitSection.module.scss"

const SubmitSection: React.FC = () => {
  const { formState: { isValid } } = useFormContext()
  const area = useWatch({ name: "area", defaultValue: "" }) as string

  return (
    <div className={styles.section}>
      <Submit disabled={ !isValid || "" === area }>結果を見る</Submit>
    </div>
  )
}

export default SubmitSection
