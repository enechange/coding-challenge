import { Capacity } from "../features/capacity";
import { Plan } from "../features/plan";
import { PostalCode } from "../features/postal-code";
import { FormContent } from "./form-content";
import styles from "./form.module.scss";
import { Select } from "./select";

export const Form = () => {
  return (
    <form className={styles.form}>
      <FormContent title="郵便番号を入力してください">
        <div className={styles.content}>
          <PostalCode />
        </div>
      </FormContent>
      <FormContent title="電気のご使用状況について教えてください">
        <div className={styles.usageCondition}>
          <div className={styles.content}>
            <Select
              name="company"
              options={[]}
              label="電力会社"
              attention="※郵便番号入力後に選択できます"
            />
          </div>
          <div className={styles.content}>
            <Plan />
          </div>
          <div className={styles.content}>
            <Capacity />
          </div>
        </div>
      </FormContent>
    </form>
  );
};
