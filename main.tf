variable "HEROKU_APIKEY" {
	type = string
}
variable "HEROKU_EMAIL" {
	type = string
}

provider "heroku" {
	api_key = var.HEROKU_APIKEY
	email = var.HEROKU_EMAIL
	version = "~> 2.5"
}

resource "heroku_app" "default" {
	name = "my-getting-started-node-app"
	region = "us"
}
