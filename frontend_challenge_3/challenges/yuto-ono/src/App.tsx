import Separator from "./components/Separator"
import Header from "./partials/Header"
import ZipSection from "./partials/ZipSection"
import Status1 from "./partials/Status1"
import Status2 from "./partials/Status2"
import EmailSection from "./partials/EmailSection"
import SubmitSection from "./partials/SubmitSection"

function App() {
  return (
    <div className="App">
      <Header />
      <form action="">
        <ZipSection />
        <Separator />
        <Status1 />
        <Separator />
        <Status2 />
        <Separator />
        <EmailSection />
        <SubmitSection />
      </form>
    </div>
  )
}

export default App
