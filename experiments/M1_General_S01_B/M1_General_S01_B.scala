import sessl._
import sessl.mlrules._

execute {
  new Experiment with Observation with ParallelExecution with CSVOutput {

    model = "../../models/M1_General.mlrj"

    simulator = HybridSimulator()
    parallelThreads = 1

    val stoppingTime = 60
    stopTime = stoppingTime
    replications = 1

    // Set initial species count as well as experiment specific reaction rate
    // coefficients
    set(
      "nLrp6"  <~ 4000,
      "nWnt"   <~ 2000
    )

    scan("ke" <~ (0.05, 0.075, 0.1))

    observe("R"   ~ count("Membrane/Lrp6(uB)"))
    observe("LR"  ~ count("Membrane/Lrp6(B)"))
    observe("ELR" ~ count("Endosome/Lrp6(B)"))

    observeAt(range(0, 1, stoppingTime))

    withRunResult(writeCSV)
  }
}
