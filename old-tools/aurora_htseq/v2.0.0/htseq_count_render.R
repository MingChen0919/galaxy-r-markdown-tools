##============ Sink warnings and errors to a file ==============
## use the sink() function to wrap all code within it.
##==============================================================
zz = file(paste0(Sys.getenv('REPORT_FILES_PATH'), '/.r_rendering.log.txt'))
sink(zz)
sink(zz, type = 'message')

#-------------------preparation -----------------
options(stringsAsFactors = FALSE)
# import libraries
library(getopt)
library(rmarkdown)
library(htmltools)
library(magrittr)
library(knitr)
# load helper functions
source(paste0(Sys.getenv('TOOL_INSTALL_DIR'), '/helper.R'))
# import getopt specification matrix from a csv file
opt = getopt(getopt_specification_matrix('getopt_specification.csv', 
                                         tool_dir=Sys.getenv('TOOL_INSTALL_DIR')))
# define a unix variable versions for all input values. this is useful when we 
# want to use input values by other programming language in r markdown
do.call(Sys.setenv, opt[-1])
#------------------------------------------------


#-----------------render Rmd files --------------
# NOTICE: 
#       we should copy all rmarkdown files from tool install directory to REPORT_FILES_PATH directory.
#       and render rmarkdown files in the REPORT_FILES_PATH directory.
file.copy(from = paste0(Sys.getenv('TOOL_INSTALL_DIR'), '/vakata-jstree-3.3.5'),
          to = Sys.getenv('REPORT_FILES_PATH'), recursive = TRUE)
system(command = 'cp -r ${TOOL_INSTALL_DIR}/*.Rmd ${REPORT_FILES_PATH}')
# render Rmd files in order
render(input = paste0(Sys.getenv('REPORT_FILES_PATH'), '/htseq_count.Rmd'))
# add more lines below if there are more Rmd files to be rendered

#------------------------------------------


#--------- expose outputs to galaxy history ----
system(command = 'sh ${TOOL_INSTALL_DIR}/expose-outputs.sh')
#==============the end==============


##--------end of code rendering .Rmd templates----------------
sink()
##=========== End of sinking output=============================