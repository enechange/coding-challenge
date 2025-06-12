import styles from './Header.module.scss';

type Props = {
  className?: string;
};

const Header: React.FC<Props> = ({ className }) => {
  return (
    <header className={styles.header}>
      <h1 className={`${styles.title} ${className}`}>
        電気代から
        <br />
        かんたんシミュレーション
      </h1>
      <p className={styles.description}>
        検針票を用意しなくてもOK
        <br />
        いくらおトクになるのか今すぐわかります！
      </p>
    </header>
  );
};

export default Header;
