#' @title Safe Download File
#'
#' Download a file from a url (using curl), if there is an error, return this as a data.frame.
#'
#' @param url url of file.
#' @param name destination file name.
#' @param destination_folder destination folder name.
#' @return A data.frame containing details of the downloaded file, or error detials.
#' @export

safe_download_file<-function(url,name,destination_folder){
  require(curl)
  tryCatch(
    data.frame(download_code=curl_download(url,paste0(destination_folder,name))),
    error=function(c) data.frame(error=as.character(c))
  )
}
