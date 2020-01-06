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
      "nR"   <~ 4000,
      "nL"   <~ 2000
    )

    scan("ke" <~ (0.2, 0.3, 0.4))

    observe("LR" ~ count("M/LR"))
    observe("R" ~ count("M/R"))
    observe("ELR" ~ count("E/LR"))

    observeAt(range(0, 1, stoppingTime))

    withRunResult(writeCSV)
  }
}
