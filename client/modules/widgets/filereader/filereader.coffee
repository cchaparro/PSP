Template.filereaderTemplate.events
	'click .filereader_action': (e, t) ->
		$filereader = t.$(".filereader_file")
		$filereader.click();

	'change .filereader_file': (e) ->
		files = e.target.files
		file = files[0]
		reader = new FileReader()
		self = @

		reader.onload = () ->
			result = @result
			self.settings.success(result, file.type)

		reader.readAsText(file)
