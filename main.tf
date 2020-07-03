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

// Create application in heroku
resource "heroku_app" "default" {
	name = "my-getting-started-node-app"
	region = "us"
}

// Build and release application
resource "heroku_build" "default" {
	app = heroku_app.default.name
	buildpacks = [ "https://github.com/heroku/heroku-buildpack-nodejs" ]
	source = {
		url = "https://github.com/1Mill/node-js-getting-started/archive/v0.0.1.tar.gz"
		version = "0.0.1"
	}
}

// Launch the application as a web process
resource "heroku_formation" "default" {
	app = heroku_app.default.id
	depends_on = [ heroku_build.default ]
	quantity = 1
	size = "free"
	type = "web"
}

output "application_url" {
	value = "https://${heroku_app.default.name}.herokuapp.com"
}
