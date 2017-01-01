Template.editProfileModal.onCreated () ->
	Meteor.subscribe "UserMenu"
	@currentUpload = new ReactiveVar(false)


Template.editProfileModal.helpers
	user: () ->
		return Meteor.user()

	currentUpload: () ->
		return Template.instance().currentUpload.get()


Template.editProfileModal.events
	'click .edit-profile-upload': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		$fileUploader = t.$(".image-upload")
		$fileUploader.click()

	'change .image-upload': (e,t) ->
		userId = Meteor.userId()
		hostPath = window.location.host

		if e.currentTarget.files and e.currentTarget.files[0]
			# We upload only one file, in case there was multiple files selected
			file = e.currentTarget.files[0]
			if file
				uploadInstance = db.Images.insert({
					file: file
					streams: 'dynamic'
					chunkSize: 'dynamic'
				}, false)

				uploadInstance.on 'start', ->
					t.currentUpload.set(@)

				#uploadInstance.on 'progress', (value) ->
				#	console.log "progreso nuevo " + value

				uploadInstance.on 'end', (error, fileObj) ->
					if error
						console.log 'Error during upload: ' + error.reason
					else
						switch fileObj.type
							when "image/jpeg"
								type = "jpeg"
							when "image/jpg"
								type = "jpg"
							when "image/png"
								type = "png"

						data = {
							"profile.profileImageUrl": "http://#{hostPath}/cdn/storage/Images/#{fileObj._id}/original/#{fileObj._id}.#{type}"
						}
						Meteor.call "update_user_public_info", userId, data, fileObj._id, (error) ->
							unless error
								sys.flashStatus("update-profile-image")
								t.currentUpload.set(false)

				uploadInstance.start()

	'click .edit-profile-default-image': (e,t) ->
		e.preventDefault()
		e.stopPropagation()

		data = {
			"profile.profileImageUrl": null
		}
		Meteor.call "update_user_public_info", Meteor.userId(), data, (error) ->
			unless error
				sys.flashStatus("update-profile-image")

	'click .edit-profile-save': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		userId = Meteor.userId()

		data = {
			"profile.fname": t.$('[name="firstName"]').val()
			"profile.lname": t.$('[name="lastName"]').val()
		}
		Meteor.call "update_user_public_info", userId, data, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("error-profile-update")
			else
				sys.flashStatus("profile-update")

