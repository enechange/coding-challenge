import { useFormContext } from "react-hook-form"
import Heading from "../components/Heading"
import Section from "../components/Section"
import Label from "../components/Label"
import ZipInput from "../components/ZipInput"
import ErrorMessage from "../components/ErrorMessage"

const ZipSection: React.FC = () => {
  const { formState: { errors } } = useFormContext()
  const zipError = errors.zip1 || errors.zip2

  return (
    <Section>
      <Heading>郵便番号をご入力ください</Heading>
      <Label htmlFor="zip1" required={true}>電気を使用する場所の郵便番号</Label>
      <ZipInput name1="zip1" name2="zip2"></ZipInput>
      {zipError && <ErrorMessage>{zipError.message}</ErrorMessage>}
    </Section>
  )
}

export default ZipSection
