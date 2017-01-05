Template.uploaderTemplate.events
	'click .uploader_action': (e, t) ->
		$fileUploader = t.$(".uploader_file")
		$fileUploader.click();
