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
  const { register, setValue } = useFormContext()
  const company = useWatch({
    name: "company",
    defaultValue: "東京電力"
  }) as string
  const [plans, setPlans] = useState(tokyoPlans)

  // エリアによってプランの選択肢を切り替え
  useLayoutEffect(() => {
    if ("東京電力" === company) {
      setPlans(tokyoPlans)
    } else if ("関西電力" === company) {
      setPlans(kansaiPlans)
    } else {
      setPlans([])
    }
  }, [company])

  useEffect(() => {
    setValue("plan", plans.length ? plans[0].value : "")
  }, [plans])

  if (0 === plans.length) {
    return null
  }

  return (
    <Field>
      <Label htmlFor="company" required={true}>プラン</Label>
      <Select
        name="plan"
        options={plans}
        registerReturn={register("plan")}
      />
    </Field>
  )
}

export default PlanSelect

