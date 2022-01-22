import Separator from "./components/Separator"
import Header from "./partials/Header"
import ZipSection from "./partials/ZipSection"
import Status1 from "./partials/Status1"
import Status2 from "./partials/Status2"

function App() {
  return (
    <div className="App">
      <Header />
      <ZipSection />
      <Separator />
      <Status1 />
      <Separator />
      <Status2 />
    </div>
  )
}

export default App
