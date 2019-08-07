#' Get File List
#'
#'
#' This function accesses the luftdaten website (http://archive.luftdaten.info/parquet/) and downloads a
#' list of available parquet files containing project data.
#'
#'
#' @return A list of .parquet files

get_file_list<-function(){
  require(curl, dplyr, rvest, magrittr)

  url<-"http://archive.luftdaten.info/parquet/"

  start_time<-Sys.time()
  tryCatch(
    read_html(url) %>%
      html_node(xpath="/html/body/table") %>%
      html_table() %>%
      select(name="Name",last_modified="Last modified",size="Size") %>%
      filter(name!="Parent Directory", name!="") ,
    error=function(c) data.frame(error=as.character(c))
    ) %>%
  add_column(elapsed_time=Sys.time()-start_time) %>%
  mutate(url=paste0(url,name)) %>%
  group_by(url) %>%
  do(get_file_list(.$url)) %>%
  ungroup() %>%
  mutate(url=paste0(url,name)) %>%
  group_by(url) %>%
  do(get_file_list(.$url)) %>%
  ungroup() %>%
  mutate(url=paste0(url,name)) %>%
  filter(name!="_SUCCESS")

}
