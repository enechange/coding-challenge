import { zodResolver } from "@hookform/resolvers/zod";
import { useForm, FormProvider, SubmitHandler } from "react-hook-form";
import { PostalCode } from "../features/postal-code";
import { FormContent } from "../ui/form-content";
import { Input } from "../ui/input";
import styles from "./simulation-form.module.scss";
import { UsageCondition } from "./usage-condition";
import { formSchema } from "@/src/schema/form";

type FormValue = {
  postalCode: string;
  company: string;
  plan: string;
  capacity: string;
  price: string;
  email: string;
};

export const SimulationForm = () => {
  const methods = useForm<FormValue>({
    resolver: zodResolver(formSchema),
    mode: "onChange",
  });
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = methods;

  // submit時にログを出力しておく
  const onSubmit: SubmitHandler<FormValue> = (data) => {
    console.log("submit", { data });
  };

  return (
    <FormProvider {...methods}>
      <form className={styles.form} onSubmit={handleSubmit(onSubmit)}>
        <FormContent title="郵便番号を入力してください">
          <PostalCode />
        </FormContent>
        <FormContent title="電気のご使用状況について教えてください">
          <UsageCondition />
        </FormContent>
        <FormContent title="現在の電気の使用状況について教えてください">
          <Input
            type="number"
            label="先月の電気代は？"
            error={errors.price?.message}
            inputmode="numeric"
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
