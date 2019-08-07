#' @title File list
#'
#' Get a tibble listing all of the .parquet files on luftdaten
#'
#' @return A tibble containing a list of files and metadata.
#' @examples
#' file_list()
#' @export

file_list<-function(){
  require(curl)
  require(dplyr)

  url<-"http://archive.luftdaten.info/parquet/"

  html_file_list(url) %>%
    mutate(url=paste0(url,name)) %>%
    group_by(url) %>%
    do(html_file_list(.$url)) %>%
    ungroup() %>%
    mutate(url=paste0(url,name)) %>%
    group_by(url) %>%
    do(html_file_list(.$url)) %>%
    ungroup() %>%
    mutate(url=paste0(url,name)) %>%
    filter(name!="_SUCCESS")

}
