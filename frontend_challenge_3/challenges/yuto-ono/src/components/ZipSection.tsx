import Heading from "./Heading"
import Section from "./Section"
import ZipComponent from "./ZipComponent"

const ZipSection: React.FC = () => {
  return (
    <Section>
      <Heading>郵便番号をご入力ください</Heading>
      <ZipComponent />
    </Section>
  )
}

export default ZipSection
