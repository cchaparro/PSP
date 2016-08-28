##################################################
Template.accountSettingsTemplate.onCreated () ->
	Meteor.subscribe "accountSettings"


Template.accountSettingsTemplate.helpers
	userData: () ->
		user = Meteor.users.findOne({_id: Meteor.userId()})
		return user if user?

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
					console.log "I just started, this is: ", this
					#template.currentUpload.set this

				uploadInstance.on 'end', (error, fileObj) ->
					if error
						console.log 'Error during upload: ' + error.reason
					else
						console.log 'File "' + fileObj.name + '" successfully uploaded'
						#template.currentUpload.set false
				uploadInstance.start()


		#FS.Utility.eachFile e, (file) ->
		#	newFile = new FS.File(file)
		#	newFile.metadata = {
		#		fileOwner: userId
		#	}
		#	db.files.insert newFile, (error, fileObj) ->
		#		if error
		#			console.warn(error)
		#		else
		#			intervalHandle = Meteor.setInterval(( ()->
		#				if fileObj.hasStored('Files')
		#					data = {
		#						"profile.profileImageUrl": "/cfs/files/Files/" + fileObj._id
		#					}
		#					Meteor.call "update_user_public_info", userId, data, fileObj._id, (error) ->
		#						unless error
		#							sys.flashStatus("update-profile-image")
#
#							Meteor.clearInterval intervalHandle
#					), 1000)

	# 'click .default-image': (e,t) ->
	# 	data = {
	# 		"profile.profileImageUrl": null
	# 	}
	# 	Meteor.call "update_user_public_info", Meteor.userId(), data, (error) ->
	# 		unless error
	# 			sys.flashStatus("update-profile-image")

	# 'click .save-profile-settings': (e,t) ->
	# 	data = {
	# 		"profile.fname": $("#fname").val()
	# 		"profile.lname": $("#lname").val()
	# 	}
	# 	Meteor.call "update_user_public_info", Meteor.userId(), data, (error) ->
	# 		if error
	# 			sys.flashStatus("profile-update-error")
	# 		else
	# 			sys.flashStatus("profile-update")

##################################################