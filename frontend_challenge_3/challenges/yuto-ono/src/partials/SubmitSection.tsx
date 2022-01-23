import Submit from "../components/Submit"
import styles from "./SubmitSection.module.scss"

const SubmitSection: React.FC = () => {
  return (
    <div className={styles.section}>
      <Submit>結果を見る</Submit>
    </div>
  )
}

export default SubmitSection
