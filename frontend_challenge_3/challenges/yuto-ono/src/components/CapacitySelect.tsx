import { useEffect, useLayoutEffect, useState } from "react"
import { useFormContext, useWatch } from "react-hook-form"
import Field from "../components/Field"
import Label from "../components/Label"
import Select from "../components/Select"
import {
  capacityOptions1,
  capacityOptions2
} from "../utilities/SelectOptions"

const CapacitySelect: React.FC = () => {
  const { register, setValue } = useFormContext()
  const plan = (useWatch({ name: "plan" }) ?? "") as string
  const [capacityOptions, setCapacityOptions] = useState(capacityOptions1)

  // プランによって契約容量の選択肢を切り替え
  useLayoutEffect(() => {
    if ("東京電力従量電灯B" === plan) {
      setCapacityOptions(capacityOptions1)
    } else if (
      "東京電力従量電灯C" === plan ||
      "関西電力従量電灯B" === plan
    ) {
      setCapacityOptions(capacityOptions2)
    } else if ("" !== plan) {
      setCapacityOptions([])
    }
  }, [plan])

  useEffect(() => {
    if (capacityOptions.length) {
      setValue("capacity", capacityOptions[0].value)
    }
  }, [capacityOptions])

  // 関西電力従量電灯Aの場合は、契約容量を聴取しない
  if (0 === capacityOptions.length) {
    return null
  }

  return (
    <Field>
      <Label htmlFor="company" required={true}>契約容量</Label>
      <Select
        name="capacity"
        options={capacityOptions}
        registerReturn={register("capacity")}
      />
    </Field>
  )
}

export default CapacitySelect

