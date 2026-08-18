library(ewsmethods)
library(dplyr)
library(tidyr)
library(tidyverse)
library(usethis)

x<-rnorm(1000)
hist(x)
#to relate R with GitHub

usethis::gis_git()
usethis::create_github_token()
gitcreds::gitcreds_set()
usethis::use_git_config(
  user.name = "IvonGutierrez",
  user.email = "ivon.gutierrez@ecologia.unam.mx"
)
usethis::use_github()
usethis::use_github(private = TRUE)
