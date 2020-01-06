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

    scan("ke_nonraft" <~ (0.2, 0.3, 0.4))
    scan("ke_raft"    <~ (0.05, 0.075, 0.1))
	
    observe("R" ~ count("M/R"))
    observe("LR" ~ count("M/LR"))
    observe("RaftLR" ~ count("M/Raft/LR"))
    observe("RaftR" ~ count("M/Raft/R"))
    observe("ELR" ~ count("E/LR"))
    //observe("DummyNonRaft" ~ count("DummyNonRaft"))
    //observe("DummyRaft" ~ count("DummyRaft"))

    observeAt(range(0, 1, stoppingTime))

    withRunResult(writeCSV)
  }
}
