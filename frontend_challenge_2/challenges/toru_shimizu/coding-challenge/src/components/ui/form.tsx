import { PostalCode } from "../features/postal-code";
import { FormContent } from "./form-content";
import styles from "./form.module.scss";

export const Form = () => {
  return (
    <form className={styles.form}>
      <FormContent title="郵便番号を入力してください">
        <div className={styles.content}>
          <PostalCode />
        </div>
      </FormContent>
    </form>
  );
};
