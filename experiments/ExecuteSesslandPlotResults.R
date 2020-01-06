#--------------------------------------------------------------------------#
# Script for producing the plots seen in the paper
# Authors:      Kai Budde, Fiete Haack
# Created:      2019-07-04
# Last changed: 2020-01-06
# Used version of Sessl2R: 0.1.3
#--------------------------------------------------------------------------#

# Preface ##################################################################
remove(list = ls())

# Set the list of experiments to be run ####################################

list_of_directories <- c(
  "M1_General_S01_A",
  "M1_General_S01_B",
  "M2_Microdomains_S02_A",
  "M2_Microdomains_S02_B",
  "M2_Microdomains_S02_C",
  "M2_Microdomains_S03_A",
  "M2_Microdomains_S03_B",
  "M2_Microdomains_S03_C",
  "M3_Wnt_S04_A",
  "M3_Wnt_S04_B",
  "M3_Wnt_S04_C",
  "M3_Wnt_S05_A",
  "M3_Wnt_S05_B",
  "M3_Wnt_S05_C",
  "M4_Dkk_S06_A",
  "M4_Dkk_S06_B"
)

# Determine how to plot the results
with_legend <- TRUE
with_y_label <- TRUE


# Set the current directory ################################################
directory_of_R_script <- rstudioapi::getSourceEditorContext()$path
directory_of_R_script <- gsub(pattern = "ExecuteSesslandPlotResults.R",
                              replacement = "",
                              x = directory_of_R_script)
old_directory <- getwd()
setwd(directory_of_R_script)


# Install and load necessary R package if not already installed ############

list.of.packages <- c("devtools", "ggplot2", "dplyr")
new.packages <- list.of.packages[
  !(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
invisible(lapply(list.of.packages, require, character.only = TRUE))


# Install the R package for using Sessl output data ########################
devtools::install_github("SFB-ELAINE/Sessl2R", ref = "v0.1.3")
require(Sessl2R)


# Load reference data ######################################################
df_LRP6 <- read.csv(file = "../data/RawDataSurfaceLRP6.csv",
                    stringsAsFactors = FALSE)
names(df_LRP6)[2] <- "FractionSurfaceLRP6"
df_LRP6$'Data Source' <- "Experiment"

df_DKK <- read.csv(file = "../data/DKK_Endocytosis.csv",
                   stringsAsFactors = FALSE)
names(df_DKK)[2] <- "FractionSurfaceLRP6"
df_DKK$'Data Source' <- "Experiment"


# Run Sessl scripts and plot experiment results ############################

for(i in 1:length(list_of_directories)){
  print(paste0("Change working directory to ", getwd(), "/",
               list_of_directories[i]))
  setwd(list_of_directories[i])
  
  # Find scala script an find scan variable
  scala_file <- grep(pattern = "*.scala", list.files(), value = TRUE)
  scan_command <- grep("scan", readLines(scala_file), value = TRUE)
  
  # Only use scan line that was not commented out
  scan_command <- grep("^\\s?//", scan_command,
                       invert = TRUE, value = TRUE)
  
  if(length(grep("^\\s?//", scan_command, invert = TRUE, value = TRUE)) > 1){
    print("We have more than one scan command.")
    
    # Combining the parameters into one
    scan_command <- gsub(pattern = ".*\\(\"",replacement = "", scan_command)
    scan_command <- gsub(pattern = "\".*",replacement = "", scan_command)
    
    parameter_names <- scan_command
  }else if(length(scan_command) == 1){
    parameter_names <- strsplit(scan_command, split = "\"")[[1]][2]
  }else{
    parameter_names <- NA
    print("No parameters existent.")
  }
  
  # Run Sessl script
  if(.Platform$OS.type == "unix") {
    system(command = "./run.sh", wait = TRUE)
  } else {
    system(command = "./run.bat", wait = TRUE)
  }
  
  # Find most recent results directory
  
  # I do have to repeat the following line because otherwise it would not
  # work properly (length(0) otherwise for i=2). I do not know why this
  # happens.
  subdirectories <- list.dirs(recursive = FALSE)
  subdirectories <- list.dirs(recursive = FALSE)
  experiment_result_dirs <- grep(pattern = "results",
                                 x = subdirectories,
                                 value = TRUE)
  
  recent_result <- experiment_result_dirs[length(experiment_result_dirs)]
  
  # Load data from experiments
  # Save a dataframe with the experiment result
  print(paste0("Folder with most recent SESSL results: ", recent_result))
  
  setwd(recent_result)
  # TODO: This will not be necessary for the new version of Sessl2R.
  getData(input_dir = getwd())
  
  # Load the data frame and copy loaded df to default name
  df_files <- list.files()
  df_files <- df_files[grepl(pattern = "rda", x = df_files)]
  
  # Go through every data frame saved in the directory and store the results
  # in df_complete
  for(j in 1:length(df_files)){
    
    load(df_files[j])
    loaded_dataframe <- gsub("\\.rda", "", df_files[j])
    
    df <- get(loaded_dataframe)
    
    # Manipulate the data frame depending on the type of experiment done
    if(grepl(pattern = "General", x = list_of_directories[i]) ){
      # Names of the columns of general model for calculating the LRP6
      # surface fraction
      df$FractionSurfaceLRP6 <- (df$R + df$LR) / df$R[1]
    }else if(grepl(pattern = "Microdomains", x = list_of_directories[i],
                   ignore.case = TRUE)){
      # Names of the columns of microdomains model for calculating the LRP6
      # surface fraction
      df$FractionSurfaceLRP6 <-
        (df$R + df$LR + df$RaftLR + df$RaftR) / df$R[1]
    }else if(grepl(pattern = "Wnt", x = list_of_directories[i],
                   ignore.case = TRUE)){
      # Names of the columns of Wnt model for calculating the LRP6
      # surface fraction
      df$FractionSurfaceLRP6 <-
        (df$Lrp6PB + df$Lrp6PuB + df$Lrp6uPB + df$Lrp6uPuB +
           df$Raft_Lrp6PB + df$Raft_Lrp6PuB + df$Raft_Lrp6uPB +
           df$Raft_Lrp6uPuB + df$Lrp6Axinp + df$Lrp6Axinu +
           df$Raft_Lrp6Axinp + df$Raft_Lrp6Axinu) / df$Lrp6uPuB[1]
    }else if(grepl(pattern = "Dkk", x = list_of_directories[i],
                   ignore.case = TRUE)){
      # Names of the columns of DKK model for calculating the LRP6
      # surface fraction
      df$FractionSurfaceLRP6 <-
        (df$Lrp6PB + df$Lrp6PuB + df$Lrp6uPB + df$Lrp6uPuB +
           df$Raft_Lrp6PB + df$Raft_Lrp6PuB + df$Raft_Lrp6uPB +
           df$Raft_Lrp6uPuB + df$Lrp6Axinp + df$Lrp6Axinu +
           df$Raft_Lrp6Axinp + df$Raft_Lrp6Axinu) /
        (df$Lrp6uPuB[1] + df$Raft_Lrp6uPuB[1])
    }else{
      print("Not the right names of the directories.")
      return(0)
    }
    
    
    # Test if we have missed some receptors anywhere
    # if(grepl(pattern = "General", x = list_of_directories[i])){
    #   df$test <- df$R[1] - df$ELR
    #   if(!all.equal((df$FractionSurfaceLRP6 * df$R[1]), df$test)){
    #     print("ERROR: We have missed receptors somewhere.")
    #     return()
    #   }
    # }else if (grepl(pattern = "Microdomains", x = list_of_directories[i])){
    #   df$test <- df$R[1] - df$ELR
    #   if(!all.equal((df$FractionSurfaceLRP6 * df$R[1]), df$test)){
    #     print("ERROR: We have missed receptors somewhere.")
    #     return()
    #   }
    # }else if(grepl(pattern = "Wnt", x = list_of_directories[i])){
    #   df$test <- df$Lrp6uPuB[1] - (df$Cell_DummyRaft + df$Cell_DummyNonRaft)
    #   if(!all.equal((df$FractionSurfaceLRP6 * df$Lrp6uPuB[1]), df$test)){
    #     print("ERROR: We have missed receptors somewhere.")
    #     return()
    #   }
    # }else if(grepl(pattern = "Dkk", x = list_of_directories[i])){
    #   df$test <- df$Lrp6uPuB[1] + df$Raft_Lrp6uPuB[1]  -
    #     (df$Cell_DummyRaft + df$Cell_DummyNonRaft)
    #   if(!all.equal((df$FractionSurfaceLRP6 *
    #                  (df$Lrp6uPuB[1] + df$Raft_Lrp6uPuB[1])), df$test)){
    #     print("ERROR: We have missed receptors somewhere.")
    #     return()
    #   }
    # }else{
    #   print("Not the right names of the directories.")
    #   return(0)
    # }
    
    if(j > 1){
      df_complete <- rbind(df_complete, df)
    }else{
      df_complete <- df
    }
    
  }
  
  # Copy data into data data frame depending on experiment
  if(grepl(pattern = "Dkk", x = list_of_directories[i], ignore.case = TRUE)){
    df_data <- df_DKK
  }else{
    df_data <- df_LRP6
  }
  
  
  # Adding measurement data to data frame
  df_complete$'Data Source' <- "Simulation"
  df_complete <- suppressMessages(full_join(x = df_complete, y = df_data))
  df_complete$'Data Source' <- as.factor(df_complete$'Data Source')
  
  #NEW->
  #df_complete$confRun <- paste(df_complete$config, df_complete$run, sep = '_')
  #df_complete$confRun[grep("NA", df_complete$confRun)] <- NA
  #df_complete
  #<-NEW
  
  # Make parameter (combinations) as factor
  if(length(parameter_names) > 1){
    copy_parameter_names <- parameter_names
    parameter_names <- paste0(parameter_names, collapse = ",\n")
    df_complete[[parameter_names]] <-
      apply(df_complete[ , copy_parameter_names ] , 1 , paste ,
            collapse = ", " )
    
    # Delete all NA parameter names
    df_complete[[parameter_names]][
      grep(pattern = "NA", x = df_complete[[parameter_names]],
           ignore.case = TRUE)] <- NA
  }
  
  df_complete[[parameter_names]] <- as.factor(df_complete[[parameter_names]])
  # Find out, which combination of scan parameters gives the lowest and highest
  # curve in the result at t=1/2 t_end
  t_half <- as.integer(max(df_complete$time)-min(df_complete$time))/2
  if(!(t_half %in% df_complete$time)){
    print("t_1/2 not in t")
  }
  
  result_min <- 1
  result_max <- 0
  
  for(k in 1:length(levels(df_complete[[parameter_names]])) ){
    
    result <- df_complete$FractionSurfaceLRP6[
      df_complete$time == t_half &
        df_complete[[parameter_names]] == levels(
          df_complete[[parameter_names]])[k] &
        !is.na(df_complete[[parameter_names]])]
    if(is.na(result)){
      print("Something went wrong wit the calculation of the result.")
    }
    
    if(result < result_min){
      result_min <- result
      parameter_line_min <- levels(df_complete[[parameter_names]])[k]
    }
    if(result > result_max){
      result_max <- result
      parameter_line_max <- levels(df_complete[[parameter_names]])[k]
    }
    
  }
  
  
  
  # Create plot
  # Data from Sessl Experiment
  p <- ggplot(df_complete,
              aes(x=time, y=FractionSurfaceLRP6, color = `Data Source`)) +
    geom_point(data = df_data) +
    geom_point(shape = "x") +
    geom_errorbar(data = df_complete,
                  aes(ymin = (FractionSurfaceLRP6-min),
                      ymax = (FractionSurfaceLRP6+max)),
                  width = 2, na.rm = TRUE) +
    geom_line(data = df_complete,
              aes(x=time, y=FractionSurfaceLRP6, linetype=get(parameter_names))) +
    # Remove NAs from the data frame (because the data does not contain
    # values for ke_nonraft) and rename the legend title
    scale_linetype_discrete(name=parameter_names, na.translate=FALSE) +
    guides(color = guide_legend(order=1)) +
    geom_ribbon(data = df_complete[
      which( df_complete[[parameter_names]] == parameter_line_min ),],
      aes(ymin = df_complete$FractionSurfaceLRP6[
        which( df_complete[[parameter_names]] == parameter_line_min ) ],
          ymax = df_complete$FractionSurfaceLRP6[
            which( df_complete[[parameter_names]] == parameter_line_max ) ]),
      fill="grey", alpha=.25, colour=NA) +
    theme_bw() +
    scale_x_continuous(expand = c(0,0)) +
    scale_y_continuous(expand = c(0,0)) +
    expand_limits(x = c(0,60)) +
    expand_limits(y = c(0,1.0)) +
    xlab("Time [min]" ) +
    scale_colour_brewer(palette = "Set1")
  
  # Add y_label and legend if requested
  if(with_y_label){
    p <- p + ylab("Fraction of Surface LRP6 ")
  }else{
    p <- p + theme(axis.title.y = element_blank())
  }
  if(with_legend){
    p <- p + theme(legend.title = element_text(size=rel(0.7)),
                   legend.text=element_text(size=rel(0.6)),
                   legend.key.size = unit(0.8, 'lines'),
                   legend.margin = margin(t = 0, unit='cm'))
  }else{
    p <- p + theme(legend.position="none")
  }
  
  p <- p + theme(axis.text  = element_text(size=14),
                 axis.title = element_text(size=14),
                 plot.margin=unit(c(0.5,0.2,0.2,0.2),"cm"))
  
  print(p)
  
  # Save plot
  setwd(directory_of_R_script)
  output_path <- "Plots"
  dir.create(path = output_path, showWarnings = FALSE)
  
  output_name <- paste(list_of_directories[i], ".pdf", sep="")
  
  ggsave(filename = paste(output_path, "/", output_name, sep=""),
         plot = p, width = 11.4, height = 6.4, units = "cm")
  
}

# Set working directory to defeault ########################################
setwd(old_directory)
