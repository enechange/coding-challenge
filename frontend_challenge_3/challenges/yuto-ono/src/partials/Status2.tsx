import BillInput from "../components/BillInput"
import Heading from "../components/Heading"
import Label from "../components/Label"
import Section from "../components/Section"

const Status2: React.FC = () => {
  return (
    <Section>
      <Heading>現在の電気の使用状況について教えてください</Heading>
      <Label htmlFor="bill" required={true}>先月の電気代は？</Label>
      <BillInput />
    </Section>
  )
}

export default Status2
