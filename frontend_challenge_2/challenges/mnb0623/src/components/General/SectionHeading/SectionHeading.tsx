import styles from './SectionHeading.module.scss';

type Props = {
  className?: string;
  text: string;
};

const SectionHeading: React.FC<Props> = ({ className, text }) => {
  const combinedClassName = [styles.heading, className]
    .filter(Boolean)
    .join(' ');

  return <h2 className={combinedClassName}>{text}</h2>;
};
export default SectionHeading;
