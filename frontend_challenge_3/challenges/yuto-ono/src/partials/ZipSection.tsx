import Heading from "../components/Heading"
import Section from "../components/Section"
import ZipComponent from "../components/ZipComponent"

const ZipSection: React.FC = () => {
  return (
    <Section>
      <Heading>郵便番号をご入力ください</Heading>
      <ZipComponent />
    </Section>
  )
}

export default ZipSection
