import styles from './Header.module.scss'

const Header: React.FC = () => {
  return (
    <header className={styles.section}>
      <h1 className={styles.title}>
        電気代から<br />
        かんたんシミュレーション
      </h1>
      <p className={styles.lead}>
        検針票を用意しなくてもOK<br />
        いくらおトクになるのか今すぐわかります！
      </p>
    </header>
  )
}

export default Header
