
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
* move admin/index into parent app
	* apps must install /admin route
* replace "render 'application/analytics'" with "render 'application/gtm_body'"
* replace "render 'application/analytics_head'" with "render 'application/gtm_head'"
* replace "render 'application/goog_tag'" with "render 'application/gtm_head'"
