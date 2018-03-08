
$(->

	admin_clipboard = new ClipboardJS('[data-clipboard-target],[data-clipboard-text]');

	if $('.editor-full').summernote != undefined
		$('.editor-full').summernote
			height: 400

		$('.editor-small').summernote
			toolbar: [ ['style', ['bold', 'italic', 'underline', 'clear']] ]

	if $('.datepicker').datetimepicker != undefined
		$('.datepicker').datetimepicker
			dateFormat: 'dd MM, yy'
	if $('.datetimepicker').datetimepicker != undefined
		$('.datetimepicker').datetimepicker({
			format: 'YYYY-MM-DD HH:mm:ss Z',
			icons: {
				time: "fa fa-clock-o",
				date: "fa fa-calendar",
				up: "fa fa-chevron-up",
				down: "fa fa-chevron-down",
				next: "fa fa-chevron-right",
				previous: "fa fa-chevron-left",
				today: "fa fa-crosshairs",
				clear: "fa fa-trash",
				close: "fa fa-remove",
			}
		})


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
