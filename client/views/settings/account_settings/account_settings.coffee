##################################################
Template.accountSettingsTemplate.helpers
	userData: () ->
		user = Meteor.users.findOne({_id: Meteor.userId()})
		return user if user?

Template.accountSettingsTemplate.events
	'change .uploader_file': (e,t) ->
		userId = Meteor.userId()

		FS.Utility.eachFile e, (file) ->
			newFile = new FS.File(file)
			newFile.metadata = {
				fileOwner: userId
			}
			db.files.insert newFile, (error, fileObj) ->
				if error
					console.warn(error)
				else
					intervalHandle = Meteor.setInterval(( ()->
						if fileObj.hasStored('Files')
							data = {
								"profile.profileImageUrl": "/cfs/files/Files/" + fileObj._id
							}
							Meteor.call "update_user_public_info", userId, data, fileObj._id, (error) ->
								unless error
									sys.flashStatus("update-profile-image")

							Meteor.clearInterval intervalHandle
					), 1000)

	'click .default-image': (e,t) ->
		data = {
			"profile.profileImageUrl": null
		}
		Meteor.call "update_user_public_info", Meteor.userId(), data, (error) ->
			unless error
				sys.flashStatus("update-profile-image")

##################################################