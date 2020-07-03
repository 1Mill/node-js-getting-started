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

resource "heroku_slug" "default" {
	app = heroku_app.default.id
	buildpack_provided_description = "Node/Express"
	file_url = "https://github.com/1Mill/node-js-getting-started/archive/v0.0.1.tar.gz"

	process_types = {
		web = "npm run start"
	}
}
