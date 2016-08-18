##################################################
Template.accountSettingsTemplate.onCreated () ->
	Meteor.subscribe "accountSettings"


Template.accountSettingsTemplate.helpers
	userData: () ->
		user = Meteor.users.findOne({_id: Meteor.userId()})
		return user if user?

Template.accountSettingsTemplate.events
	'change .uploader_file': (e,t) ->
		FS.Utility.eachFile e, (file) ->
			newFile = new FS.File(file)
			newFile.metadata = {
				fileOwner: Meteor.userId()
			}
			db.files.insert newFile, (error, fileObj) ->
				if error
					console.warn(error)
				else
					userId = Meteor.userId()

					intervalHandle = Meteor.setInterval(( ()->
						if fileObj.hasStored('Files')
							data = {
								"profile.profileImageUrl": "/cfs/files/Files/" + fileObj._id
							}
							Meteor.call "update_user_public_info", userId, data, fileObj._id
							Meteor.clearInterval intervalHandle
					), 1000)

##################################################