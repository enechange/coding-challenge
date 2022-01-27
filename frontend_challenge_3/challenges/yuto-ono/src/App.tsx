import { useForm, SubmitHandler, FormProvider } from "react-hook-form"
import Separator from "./components/Separator"
import Header from "./partials/Header"
import ZipSection from "./partials/ZipSection"
import Status1 from "./partials/Status1"
import Status2 from "./partials/Status2"
import EmailSection from "./partials/EmailSection"
import SubmitSection from "./partials/SubmitSection"

type Inputs = {
  zip1: string
  zip2: string
  area: string
  company: string
  plan: string
  capacity: string
  bill: number
  email: string
}

const App: React.FC = () => {
  const methods = useForm<Inputs>({ mode: "onChange" })
  const { handleSubmit } = methods
  const onSubmit: SubmitHandler<Inputs> = data => {
    console.log(data)

    alert([
      "採用ご担当者様",
      "",
      "このページをご覧いただき、ありがとうございます。",
      "このアプリはReactで作られています。",
      "このアプリが良いと思われましたら、",
      "フロントエンドエンジニアとしての採用を",
      "ぜひ前向きにご検討くださいませ！",
      "",
      "小野",
    ].join("\n"))
  }

  return (
    <div className="App">
      <Header />
      <FormProvider {...methods}>
        <form onSubmit={handleSubmit(onSubmit)}>
          <ZipSection />
          <Separator />
          <Status1 />
          <Separator />
          <Status2 />
          <Separator />
          <EmailSection />
          <SubmitSection />
        </form>
      </FormProvider>
    </div>
  )
}

export default App
