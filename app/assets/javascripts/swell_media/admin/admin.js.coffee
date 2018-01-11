
$(->

	if $('.editor-full').summernote != undefined
		$('.editor-full').summernote
			height: 400

		$('.editor-small').summernote
			toolbar: [ ['style', ['bold', 'italic', 'underline', 'clear']] ]

	if $('#asset-upload-json').length > 0
		imageUploadToS3 = JSON.parse $('#asset-upload-json').text()
		imageUploadToS3['callback'] = (url, key) ->
			#The URL and Key returned from Amazon.
			console.log url
			console.log key

	$('textarea.wysiwyg').each ->
		$this = $(this)
		$this.froalaEditor({
			heightMin: $this.data('heightmin'),
			linkInsertButtons: ['linkBack'],
			linkList: false,
			codeBeautifier: true,
			linkMultipleStyles: false,
			toolbarInline: false,
			pastePlain: true,
			charCounterCount: false,
			placeholderText: $this.attr('placeholder'),
			height: $this.data('height'),
			toolbarSticky: true,
			imageUploadToS3: imageUploadToS3,
		})
	$('textarea.wysiwyg-inline').each ->
		$this = $(this)
		$this.froalaEditor({
			heightMin: $this.data('heightmin'),
			linkInsertButtons: ['linkBack'],
			linkList: false,
			codeBeautifier: true,
			linkMultipleStyles: false,
			toolbarInline: true,
			pastePlain: true,
			charCounterCount: false,
			toolbarButtons: ['bold', 'italic', 'underline', 'strikeThrough', 'color', 'emoticons', '-', 'paragraphFormat', 'align', 'formatOL', 'formatUL', 'indent', 'outdent', '-', 'insertImage', 'insertLink', 'insertFile', 'insertVideo', 'undo', 'redo']
			height: $this.data('height'),
			placeholderText: $this.attr('placeholder'),
			#toolbarSticky: false,
			imageUploadToS3: imageUploadToS3,
		})

	# $('.medium-editor').mediumEditorInput()

	if $('.datepicker').datetimepicker != undefined
		$('.datepicker').datetimepicker
			dateFormat: 'dd MM, yy'


	if not not $('#article_category_id').val()
		$('#article_category_name').hide()

	$('#article_category_id').change ->
		if not not $(@).val()
			$('#article_category_name').hide()
		else
			$('#article_category_name').show()


	$('.table-multi-select').each ->
		$table = $(this)
		$selector_inputs = $('tbody td.table-multi-select-column input', $table)
		$select_all_inputs = $('thead th.table-multi-select-column input', $table)
		$select_count_container = $('.table-multi-select-count', $table)

		update_table = () ->
			select_count = $('tbody td.table-multi-select-column input:checked', $table).length
			$select_count_container.html( select_count )

			if select_count > 0
				$table.addClass('table-multi-select-selected')
			else
				$table.removeClass('table-multi-select-selected')


		$select_all_inputs.change ->
			$input = $(this)

			if $input.is(':checked')
				$selector_inputs.prop('checked', true)
				$select_all_inputs.prop('checked', true)
			else
				$selector_inputs.prop('checked', false)
				$select_all_inputs.prop('checked', false)

			$selector_inputs.change()

		$selector_inputs.change ->
			$input = $(this)

			if $input.is(':checked')
				$input.parents('tr').addClass('table-multi-select-row-selected')
			else
				$input.parents('tr').removeClass('table-multi-select-row-selected')

			update_table()
);
