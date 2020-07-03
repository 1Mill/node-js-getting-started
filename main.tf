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

terraform {
	required_version = "~> 0.12.26"

	backend "s3" {
		// profile = ENVIRONMENT AWS_PROFILE
		// region = ENVIRONMENT AWS_DEFAULT_REGION

		// access_key = ENVIRONMENT AWS_ACCESS_KEY_ID
		// secret_key = ENVIRONMENT AWS_SECRET_ACCESS_KEY

		bucket = "experiment-terraform-state"
		dynamodb_table = "experiment-terraform-state-locks"
		encrypt = true
		key = "global/s3/terraform.tfstate"
	}
}

// https://devcenter.heroku.com/articles/using-terraform-with-heroku#deploying-code-to-an-app
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
