import { useEffect, useLayoutEffect, useState } from "react"
import { useFormContext, useWatch } from "react-hook-form"
import Field from "../components/Field"
import Label from "../components/Label"
import Select from "../components/Select"
import {
  kansaiPlans,
  tokyoPlans
} from "../utilities/SelectOptions"

const PlanSelect: React.FC = () => {
  const { register, setValue, clearErrors } = useFormContext()
  const area = (useWatch({ name: "area" }) ?? "") as string
  const [plans, setPlans] = useState(tokyoPlans)

  // エリアによってプランの選択肢を切り替え
  useLayoutEffect(() => {
    if ("関西電力エリア" === area) {
      setPlans(kansaiPlans)
    } else {
      setPlans(tokyoPlans)
    }
  }, [area])

  useEffect(() => {
    setValue("plan", plans[0].value)
  }, [plans])

  return (
    <Field>
      <Label htmlFor="company" required={true}>プラン</Label>
      <Select
        name="company"
        options={plans}
        registerReturn={register("plan")}
      />
    </Field>
  )
}

export default PlanSelect

