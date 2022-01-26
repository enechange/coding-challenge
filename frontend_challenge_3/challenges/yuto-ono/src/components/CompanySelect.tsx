import { useFormContext, useWatch } from "react-hook-form"
import Field from "../components/Field"
import Label from "../components/Label"
import Select from "../components/Select"
import {
  kansaiOptions,
  SelectOptions,
  tokyoOptions
} from "../utilities/SelectOptions"

const CompanySelect: React.FC = () => {
  const { setValue } = useFormContext()
  const area = (useWatch({ name: "area" }) ?? "") as string

  // エリアによって電力会社の選択肢を切り替え
  const companies: SelectOptions = (() => {
    if ("関西電力エリア" === area) {
      return kansaiOptions
    }
    return tokyoOptions
  })()

  setValue("company", companies[0].value)

  return (
    <Field>
      <Label htmlFor="company" required={true}>電力会社</Label>
      <Select name="company" options={companies} />
    </Field>
  )
}

export default CompanySelect

