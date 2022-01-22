import Heading from "../components/Heading"
import Section from "../components/Section"
import Field from "../components/Field"
import Label from "../components/Label"
import Select from "../components/Select"

const Status1: React.FC = () => {
  return (
    <Section>
      <Heading>電気のご使用状況について教えてください</Heading>
      <Field>
        <Label htmlFor="company" required={true}>電力会社</Label>
        <Select name="company" />
      </Field>
      <Field>
        <Label htmlFor="company" required={true}>プラン</Label>
        <Select name="company" />
      </Field>
      <Field>
        <Label htmlFor="company" required={true}>契約容量</Label>
        <Select name="company" />
      </Field>
    </Section>
  )
}

export default Status1
