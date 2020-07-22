import sessl._
import sessl.mlrules._

execute {
  new Experiment with Observation with ParallelExecution with CSVOutput {

    model = "../../models/M2_Microdomains.mlrj"

    simulator = HybridSimulator()
    parallelThreads = 1

    val stoppingTime = 60
    stopTime = stoppingTime
    replications = 1

    // Set initial species count as well as experiment specific reaction rate
    // coefficients
    set("ke_raft" <~ 0)

    scan("ke_nonraft" <~ (0.05, 0.075, 0.1))

    observe("R"      ~ count("Membrane/Lrp6(uB)"))
    observe("LR"     ~ count("Membrane/Lrp6(B)"))
    observe("RaftR"  ~ count("Membrane/LR/Lrp6(uB)"))
    observe("RaftLR" ~ count("Membrane/LR/Lrp6(B)"))
    observe("ELR"    ~ count("Endosome/Lrp6(B)"))
    //observe("DummyNonRaft" ~ count("DummyNonRaft"))
    //observe("DummyRaft" ~ count("DummyRaft"))

    observeAt(range(0, 1, stoppingTime))

    withRunResult(writeCSV)
  }
}
