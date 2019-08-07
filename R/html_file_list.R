#' @title HTML file list
#'
#' Get a HTML file table from luftdaten and turn it into a tibble
#'
#' @param url A luftdaten site url.
#' @return A tibble containing a list of files and metadata.
#' @examples
#' html_file_list("http://archive.luftdaten.info/parquet/")
#' @export

html_file_list<-function(url){
  require(rvest)
  require(magrittr)
  require(tibble)

  start_time<-Sys.time()
  tryCatch(
    read_html(url) %>%
      html_node(xpath="/html/body/table") %>%
      html_table() %>%
      select(name="Name",last_modified="Last modified",size="Size") %>%
      filter(name!="Parent Directory", name!="") ,

    error=function(c) data.frame(error=as.character(c))
  ) %>%
  add_column(elapsed_time=Sys.time()-start_time)
}
