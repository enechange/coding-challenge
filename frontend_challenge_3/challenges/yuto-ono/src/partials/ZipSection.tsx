import { useFormContext, useWatch } from "react-hook-form"
import Heading from "../components/Heading"
import Section from "../components/Section"
import Label from "../components/Label"
import ZipInput from "../components/ZipInput"
import ErrorMessage from "../components/ErrorMessage"
import { useEffect } from "react"
import Api from "../utilities/Api"

const api = new Api()

const ZipSection: React.FC = () => {
  const {
    register,
    setValue,
    setError,
    clearErrors,
    formState: { errors }
  } = useFormContext()

  const zipError = errors.zip1 ?? errors.zip2 ?? errors.area

  // 仮想的に郵便番号からサービスエリアを取得するinputを作る
  const zip1 = useWatch({ name: "zip1", defaultValue: "" }) as string
  const zip2 = useWatch({ name: "zip2", defaultValue: "" }) as string

  useEffect(() => {
    register("area")
  }, [register])

  useEffect(() => {
    const zip = zip1 + zip2

    if ("" === zip) {
      clearErrors("area")
      return
    }

    // APIで郵便番号からサービスエリアを取得
    api
      .getAreaByZipCode(zip)
      .then(value => {
        clearErrors("area")
        setValue("area", value)
      })
      .catch(reason => {
        setError("area", {
          type: "manual",
          message: reason,
        })
      })
  }, [zip1, zip2])


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
