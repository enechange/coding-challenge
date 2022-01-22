import Label from "./Label"
import ZipInput from "./ZipInput"

const ZipComponent: React.FC = () => {
  return (
    <>
      <Label htmlFor="zip1" required={true}>電気を使用する場所の郵便番号</Label>
      <ZipInput name1="zip1" name2="zip2"></ZipInput>
    </>
  )
}

export default ZipComponent
