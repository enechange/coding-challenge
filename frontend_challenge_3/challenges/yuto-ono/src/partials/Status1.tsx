import CompanySelect from "../components/CompanySelect"
import Heading from "../components/Heading"
import Section from "../components/Section"

const Status1: React.FC = () => {
  return (
    <Section>
      <Heading>電気のご使用状況について教えてください</Heading>
      <CompanySelect />
    </Section>
  )
}

export default Status1
