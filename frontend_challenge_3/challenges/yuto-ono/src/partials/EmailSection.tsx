import Heading from "../components/Heading"
import Input from "../components/Input"
import Label from "../components/Label"
import Section from "../components/Section"

const EmailSection: React.FC = () => {
  return (
    <Section>
      <Heading>メールアドレスをご入力ください</Heading>
      <Label htmlFor="email" required={true}>メールアドレス</Label>
      <Input type="email" name="email" placeholder="example@example.com" />
    </Section>
  )
}

export default EmailSection
