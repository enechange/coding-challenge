import { useFormContext } from "react-hook-form"
import BillInput from "../components/BillInput"
import ErrorMessage from "../components/ErrorMessage"
import Heading from "../components/Heading"
import Label from "../components/Label"
import Section from "../components/Section"

const Status2: React.FC = () => {
  const { formState: { errors } } = useFormContext()

  return (
    <Section>
      <Heading>現在の電気の使用状況について教えてください</Heading>
      <Label htmlFor="bill" required={true}>先月の電気代は？</Label>
      <BillInput />
      {errors.bill && <ErrorMessage>{errors.bill.message}</ErrorMessage>}
    </Section>
  )
}

export default Status2
