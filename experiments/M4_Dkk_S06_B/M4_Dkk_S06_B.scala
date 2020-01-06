import sessl._
import sessl.mlrules._

execute {
  new Experiment with Observation with ParallelExecution with CSVOutput {

    model = "../../models/M4_Dkk.mlrj"

    simulator = HybridSimulator()
    parallelThreads = 1

    val stoppingTime = 60
    stopTime = stoppingTime
    replications = 1

    // Set initial species count as well as experiment specific reaction rate
    // coefficients
    set("ke_raft" <~ 0,
        "ke_nonraft" <~ 0.3)
    scan("nDkk" <~ (1000, 500, 250))
    
    observe("Cell_DummyNonRaft" ~ count("Cell/DummyNonRaft"))
    observe("Cell_DummyRaft" ~ count("Cell/DummyRaft"))
    
    observe("endoLrp6uPB" ~ count("Cell/Endosome/Lrp6(uP, B)"))
    observe("endoLrp6AxinP" ~ count("Cell/Endosome/Lrp6Axin(p)"))
    observe("endoLrp6AxinuP" ~ count("Cell/Endosome/Lrp6Axin(u)"))
    observe("endoLrp6Dummy" ~ count("Cell/Endosome/Lrp6Dummy"))
    
    observe("Lrp6uPuB" ~ count("Cell/Membrane/Lrp6(uP, uB)"))
    observe("Lrp6PuB" ~ count("Cell/Membrane/Lrp6(P, uB)"))
    observe("Lrp6uPB" ~ count("Cell/Membrane/Lrp6(uP, B)"))
    observe("Lrp6PB" ~ count("Cell/Membrane/Lrp6(P, B)"))
    observe("Lrp6Axinu" ~ count("Cell/Membrane/Lrp6Axin(u)"))
    observe("Lrp6Axinp" ~ count("Cell/Membrane/Lrp6Axin(p)"))
    //observe("CK1y" ~ count("Cell/Membrane/CK1y"))
    //observe("Lrp6Dummy" ~ count("Cell/Membrane/Lrp6Dummy"))
    
    observe("Raft_Lrp6uPuB" ~ count("Cell/Membrane/LR/Lrp6(uP, uB)"))
    observe("Raft_Lrp6PuB" ~ count("Cell/Membrane/LR/Lrp6(P, uB)"))
    observe("Raft_Lrp6uPB" ~ count("Cell/Membrane/LR/Lrp6(uP, B)"))
    observe("Raft_Lrp6PB" ~ count("Cell/Membrane/LR/Lrp6(P, B)"))
    observe("Raft_Lrp6Axinu" ~ count("Cell/Membrane/LR/Lrp6Axin(u)"))
    observe("Raft_Lrp6Axinp" ~ count("Cell/Membrane/LR/Lrp6Axin(p)"))
    //observe("Raft_CK1y" ~ count("Cell/Membrane/LR/CK1y"))
    //observe("Raft_Lrp6Dummy" ~ count("Cell/Membrane/LR/Lrp6Dummy"))

    //observe("Axinp" ~ count("Cell/Axin(p)"))
    //observe("Axinu" ~ count("Cell/Axin(u)"))
    //observe("AxinDummy" ~ count("Cell/AxinDummy"))
    //observe("Bcat" ~ count("Cell/Bcat"))
    //observe("Nuc_Bcat" ~ count("Cell/Nuc/Bcat"))
    
    observeAt(range(0, 1, stoppingTime))

    withRunResult(writeCSV)
  }
}
