# Swell Media

A Simple and Extensible CMS Engine for Rails.

Provides Base CMS functionality for Users, Permissions (using Pundit), Asset Uploads to S3, Media (pages with root urls), Categories, Contacts, and email Optins....

## To Use:

In your gemfile: `gem 'swell_media', git: 'git://github.com/playswell/swell_media.git'`

Install migrations

Configuration options:

In config/intitializers/swell_media.rb

```ruby
SwellMedia.configure do |config|
	config.registered_media_types += [ 'Media Classes' ]
	config.app_name = 'Your App Name'
	config.app_description = 'Some description'
	config.app_logo = 'path to your logo'
	config.twitter_handle = '@something'
	config.tag_manager_code = ( ENV['GOOGLE_TAG_MANAGER_CODE'] || "" )
	config.google_analytics_code = ( ENV['GOOGLE_ANALYTICS_CODE'] || "" )
	config.google_analytics_site = ( ENV['GOOGLE_ANALYTICS_SITE'] || '' )
	config.google_analytics_debug = false
	config.google_analytics_event_logging = true
	config.default_protocol = 'https' if Rails.env.production?
	config.default_user_status = :active
	config.app_host = ENV['APP_DOMAIN'] || 'localhost:3000'
	config.asset_host = ENV['ASSET_HOST']
	config.reserved_words += [ 'ambassador', 'ambassadors', 'shop', 'shopswell', 'playswell', 'shopping', 'deal', 'deals', 'products', 'top_products', 'staff', 'top_deals', 'top-products', 'top-deals', 'awards', 'users', 'compare', 'comparison', 'comparisions', 'community', 'versus', 'latest', 'serendipity', 'feed' ]

	#config.root_controller_parent_class = RootController

	config.froala_editor_key = 'to use froala'

	config.contact_email_to = ENV['CONTACT_EMAIL_TO'] || 'support@yoursite.com'
	config.contact_email_from = ENV['CONTACT_EMAIL_FROM'] || 'support@yoursite.com'
end
```

Install and configure the following gems:
```ruby
	gem 'carrierwave'
	gem 'newrelic_rpm'
	gem 'sitemap_generator'
```

Setup your CDN:
A) Free CloudFlare CDN - provides you a free means of caching your static web image, script and style assets so as to reduce bandwidth cost of S3
	1) setup s3 bucket named: cdn1.YOURDOMAINNAME.com (cdn1.YOURDOMAINNAME.com.s3.amazonaws.com), and configure ENV variables
		ASSET_HOST=http://cdn1.YOURDOMAINNAME.com
		FOG_DIRECTORY=cdn1.YOURDOMAINNAME.com
	2) Setup a cloudflare CDN services for your bucket
		https://support.cloudflare.com/hc/en-us/articles/200168926-How-do-I-use-CloudFlare-with-Amazon-s-S3-Service-
	3) Get API Key and secret and set the ENV values AMZN_ASOC_KEY & AMZN_ASOC_SECRET
		http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html
B) S3 & CloudFront
C) S3 - this is not recommended as S3 is not a true CDN and can be Bandwidth expensive, especially with any kinda of high volume impression traffic

Set up analytics and set ENV GA_TRACKING_ID
	https://support.google.com/analytics/answer/1008015?hl=en





use contacts#create form to optin the newsletter... If GIBBON_DEFAULT_LIST_ID set, and optin param present, email will be added to Mailchimp list
