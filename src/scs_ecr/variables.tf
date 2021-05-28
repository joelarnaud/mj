variable "ecr_repo_name" {
  description = "Ecr repository name. Ex : scs/ca/ssq/ac/tiragebd"
}
 
variable "image_scan" {
  default = "true"
  description = "Enable scan of images on push to the repository"
}
 
variable "days_before_deletion" {
  default = "7"
  description = "Number of days before untagged images are deleted"
}
