
== V2.6.0 (5/2018 TBD)
* Remove bunch of cruft
	* lead-offers
	* console???
	* media admin
	* import/export
	* privacy/terms out of engine
	* removed duplicate devise routing
	* cleanup SwellMedia config options
	* delete layouts from the engine... rely completely on apps to fulfill them
* Migration
	* move admin/index into parent app
		* apps must install /admin route
	* replace "render 'application/analytics'" with "render 'application/gtm_body'"
	* replace "render 'application/analytics_head'" with "render 'application/gtm_head'"
	* replace "render 'application/goog_tag'" with "render 'application/gtm_head'"
	* Remove ":omniauthable" from User devise call AND ":omniauth_callbacks => 'oauth'" from config/routes.rb devise_for call, unless you have installed the omniauth gem
