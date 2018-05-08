# Swell Media

A Simple and Extensible CMS Engine for Rails.

Provides Base CMS functionality for Users, Permissions (using Pundit), Asset Uploads to S3, Media (pages with root urls), Categories, Contacts, and email Optins....

## To Use:

In your gemfile: `gem 'swell_media', git: 'git://github.com/playswell/swell_media.git'`

Install migrations

Configuration options:

In config/intitializers/swell_media.rb


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
