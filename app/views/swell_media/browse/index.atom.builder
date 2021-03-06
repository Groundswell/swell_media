atom_feed( language: 'en-US', url: category_url( params[:id], params.merge( format: 'html' ) ) ) do |feed|
	feed.title @title
	feed.updated @results.try(:first).try(:created_at)

	@results.each do |result|
		feed.entry result, { published: result.publish_at } do |entry|
			entry.title result.title

			entry.content render( 'articles/content.html', result: result, args: {} )

			entry.author do |author|
				author.name result.user.full_name
			end
			entry.url result.url
			entry.summary (result.try(:content_preview) || result.try(:description_preview) || result.try(:sanitized_description) || result.try(:sanitized_description) || '').truncate(150)
		end
	end
end