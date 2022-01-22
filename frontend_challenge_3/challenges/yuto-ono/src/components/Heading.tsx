import styles from "./Heading.module.scss"

const Heading: React.FC = ({ children }) => {
  return <h2 className={styles.heading}>{children}</h2>
}

export default Heading
