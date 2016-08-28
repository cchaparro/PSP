##################################################
Template.accountSettingsTemplate.onCreated () ->
	Meteor.subscribe "accountSettings"


Template.accountSettingsTemplate.helpers
	userData: () ->
		user = Meteor.users.findOne({_id: Meteor.userId()})
		return user if user?

	profilePicture: () ->
		return db.Images.findOne({_id: @profile.profileImageUrl})


Template.accountSettingsTemplate.events
	'change .uploader_file': (e,t) ->
		userId = Meteor.userId()

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
					#template.currentUpload.set this

				uploadInstance.on 'end', (error, fileObj) ->
					if error
						console.log 'Error during upload: ' + error.reason
					else
						#console.log 'File "', fileObj
						data = {
							"profile.profileImageUrl": fileObj._id
						}
						Meteor.call "update_user_public_info", userId, data, (error) ->
							unless error
								sys.flashStatus("update-profile-image")

						#template.currentUpload.set false

				uploadInstance.start()


	'click .default-image': (e,t) ->
		data = {
			"profile.profileImageUrl": null
		}
		Meteor.call "update_user_public_info", Meteor.userId(), data, (error) ->
			unless error
				sys.flashStatus("update-profile-image")

	'click .save-profile-settings': (e,t) ->
		data = {
			"profile.fname": $("#fname").val()
			"profile.lname": $("#lname").val()
		}
		Meteor.call "update_user_public_info", Meteor.userId(), data, (error) ->
			if error
				sys.flashStatus("profile-update-error")
			else
				sys.flashStatus("profile-update")

##################################################