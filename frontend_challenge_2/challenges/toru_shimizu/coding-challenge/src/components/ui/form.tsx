import { zodResolver } from "@hookform/resolvers/zod";
import { useAtomValue } from "jotai";
import { useForm, FormProvider, SubmitHandler } from "react-hook-form";
import { Capacity } from "../features/capacity";
import { Plan } from "../features/plan";
import { PostalCode } from "../features/postal-code";
import { FormContent } from "./form-content";
import styles from "./form.module.scss";
import { Input } from "./input";
import { Select } from "./select";
import { formSchema } from "@/src/schema/form";
import { companiesAtom } from "@/src/states/options";
type FormValue = {
  postalCode: string;
  company: string;
  plan: string;
  capacity: string;
  price: string;
  email: string;
};

export const Form = () => {
  const methods = useForm<FormValue>({
    resolver: zodResolver(formSchema),
    mode: "onChange",
  });
  const {
    register,
    handleSubmit,
    formState: { errors },
    watch,
  } = methods;

  const companies = useAtomValue(companiesAtom);
  const company = watch("company");
  const plan = watch("plan");

  const enabledCapacity = !(plan === "従量電灯A" && company === "関西電力");

  // TODO: 送信処理
  const onSubmit: SubmitHandler<FormValue> = (data) => {
    console.log(data);
  };

  return (
    <FormProvider {...methods}>
      <form className={styles.form} onSubmit={handleSubmit(onSubmit)}>
        <FormContent title="郵便番号を入力してください">
          <div className={styles.content}>
            <PostalCode />
          </div>
        </FormContent>
        <FormContent title="電気のご使用状況について教えてください">
          <div className={styles.usageCondition}>
            <div className={styles.content}>
              <Select
                attention="※郵便番号入力後に選択できます"
                error={errors.company?.message}
                label="電力会社"
                options={companies}
                {...register("company")}
              />
            </div>
            <div className={styles.content}>
              <Plan companyName="company" />
            </div>
            {enabledCapacity && (
              <div className={styles.content}>
                <Capacity company={company} plan={plan} />
              </div>
            )}
          </div>
        </FormContent>
        <FormContent title="現在の電気の使用状況について教えてください">
          <Input
            label="先月の電気代は？"
            error={errors.price?.message}
            {...register("price")}
          >
            <p>円</p>
          </Input>
        </FormContent>
        <FormContent title="メールアドレスを入力してください">
          <Input
            label="メールアドレス"
            error={errors.email?.message}
            {...register("email")}
          />
        </FormContent>
        <div className={styles.buttonWrapper}>
          <button type="submit">
            結果を見る
            <span className={styles.caret}></span>
          </button>
        </div>
      </form>
    </FormProvider>
  );
};
