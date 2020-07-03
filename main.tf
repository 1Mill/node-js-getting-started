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
resource "heroku_app_release" "default" {
	app = heroku_app.default.id
	slug_id = heroku_slug.default.id
}
resource "heroku_slug" "default" {
	app = heroku_app.default.id
	buildpack_provided_description = "Node/Express"
	file_url = "https://github.com/1Mill/node-js-getting-started/releases/download/v0.0.1/v0.0.1.tgz"

	process_types = {
		web = "npm run start"
	}
}
resource "heroku_formation" "default" {
	app = heroku_app.default.id
	depends_on = [ heroku_app_release.default ]
	quantity = 1
	size = "free"
	type = "web"
}
