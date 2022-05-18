
# 1. you need to create 54 parameters_recovery_1.R copies, then we will change
# their names to the correct labels 1:55

# get file names list
oldFileNames <- list.files("batch_scripts")
# take only files with "para" and ".R"
oldFileNames <- oldFileNames[grepl("para",oldFileNames) & 
                               grepl(".R",oldFileNames)]
oldFileNames

# create new names
newFileNames <- as.vector(NA)
for (i in 1:length(oldFileNames)) {
  newFileNames[i] <- paste0("parameters_recovery_",i,".R")
}

# change names
file.rename(paste0("batch_scripts/",oldFileNames),
            paste0("batch_scripts/",newFileNames))



# 2. multiply batch_1.sh by 55
# batch <- read.table("batch_rc/batch_1.sh")


            