import { useFormContext } from "react-hook-form"
import ErrorMessage from "../components/ErrorMessage"
import Heading from "../components/Heading"
import Input from "../components/Input"
import Label from "../components/Label"
import Section from "../components/Section"

const EmailSection: React.FC = () => {
  const { register, formState: { errors } } = useFormContext()

  return (
    <Section>
      <Heading>メールアドレスをご入力ください</Heading>
      <Label htmlFor="email" required={true}>メールアドレス</Label>
      <Input
        type="email"
        name="email"
        placeholder="example@example.com"
        registerReturn={register("email", {
          required: "メールアドレスを入力してください。",
          pattern: {
            value: /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/,
            message: "メールアドレスを正しく入力してください。"
          }
        })}
      />
      {errors.email && <ErrorMessage>{errors.email.message}</ErrorMessage>}
    </Section>
  )
}

export default EmailSection
