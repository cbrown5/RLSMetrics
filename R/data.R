#' Full RLS transect dataset
#'
#' Observations of species across global sites 
#' @format data.frame:
#' \describe{
#'   \item{SurveyID}{Survey ID code}
#'   \item{SpeciesID}{Species ID code}
#'   \item{SizeClass}{Size class in cm}
#'   \item{Method}{Which transect method in 0-3}
#'   \item{Abundance}{Count of observed individuals}
#'   \item{BioMass}{Weight in grams if calculated}
#' }
#'
#' @format data.frame
"rls"

#' Site level data 
#'
#' @format data.frame:
#' \describe{
#'   \item{SiteCode}{Site ID code}
#'   \item{SiteLat}{Latitude}
#'   \item{SiteLong}{Longitude}
#'   \item{and so on}{many other variables...}
#' }
#'
#' @format data.frame
"sdat"

#' Species level data 
#'
#' Traits etc
#' @format data.frame:
#' \describe{
#'   \item{SpeciesID}{Species ID code}
#'   \item{TAXONOMIC_NAME}{Latin binomial}
#'   \item{and so on}{many other variables...}
#' }
#'
#' @format data.frame
"fdat"

#' Cryptic fish families
#'
#' It is useful to filter them out sometimes. 
#' @format data.frame:
#' \describe{
#'   \item{Family}{Cryptic fish families}
#' }
#'
#' @format data.frame
"cryptdat"

#' Invertebrate classes 
#'
#' @format character
#' It is useful to filter them out sometimes. 
#'
#' @format character
"invertclasses"

#' Survey level data
#'
#' @format data.frame:
#' \describe{
#'   \item{SiteCode}{Site ID code}
#'   \item{Survey ID}{Survey ID code}
#'   \item{Depth}{Depth in metres}
#'   \item{Survey date}{dd/mm/yyyy}
#'   \item{Visibility}{Observation visibility in metres}
#'   \item{Diver}{Diver's initials}
#' }
#'
#' @format data.frame
"survdat"