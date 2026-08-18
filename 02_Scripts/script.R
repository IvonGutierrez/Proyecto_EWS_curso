library(ewsmethods)
library(dplyr)
library(tidyr)
library(tidyverse)
library(usethis)#to set up Git and GitHub

x<-rnorm(1000)
hist(x)
#to relate R with GitHub

usethis::gis_git()
usethis::create_github_token()#in GitHub creates a Token
gitcreds::gitcreds_set()##click and copy Token
usethis::use_git_config(
  user.name = "IvonGutierrez",
  user.email = "ivon.gutierrez@ecologia.unam.mx"
)
usethis::use_github()#it creates a repository in GitHub, connect with local repository
usethis::use_github(private = TRUE)#specify as private##default is public

sd(x)

##for each change, we must use commit. 
##Check the script, summit the change, then PUSH (select the script)