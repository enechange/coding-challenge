import styles from "./Section.module.scss"

const Section: React.FC = ({ children }) => {
  return (
    <section className={styles.section}>
      {children}
    </section>
  )
}

export default Section
