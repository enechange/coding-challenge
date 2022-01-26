import { useEffect, useLayoutEffect, useState } from "react"
import { useFormContext, useWatch } from "react-hook-form"
import Field from "../components/Field"
import Label from "../components/Label"
import Select from "../components/Select"
import {
  kansaiOptions,
  tokyoOptions
} from "../utilities/SelectOptions"
import ErrorMessage from "./ErrorMessage"

const CompanySelect: React.FC = () => {
  const { register, setValue, clearErrors, formState: { errors } } = useFormContext()
  const area = (useWatch({ name: "area" }) ?? "") as string
  const [companies, setCompanies] = useState(tokyoOptions)

  // エリアによって電力会社の選択肢を切り替え
  useLayoutEffect(() => {
    if ("関西電力エリア" === area) {
      setCompanies(kansaiOptions)
    } else {
      setCompanies(tokyoOptions)
    }
  }, [area])

  useEffect(() => {
    setValue("company", companies[0].value)
    clearErrors("company")
  }, [companies])

  return (
    <>
      <Field>
        <Label htmlFor="company" required={true}>電力会社</Label>
        <Select
          name="company"
          options={companies}
          registerReturn={register("company", {
            validate: value => {
              return "その他" !== value || "シミュレーション対象外です。"
            }
          })}
        />
      </Field>
      {errors.company && <ErrorMessage>{errors.company.message}</ErrorMessage>}
    </>
  )
}

export default CompanySelect

