variable "config_file" {
  description = "The path of configuration YAML file."
  type        = string
  default     = "./config.yaml"
}

variable "availability_zone" {
  default = ["ap-northeast-2a","ap-northeast-2c"]
}