#######################################
Meteor.methods
	change_project_settings: () ->
		userSettings = db.users.findOne({_id: Meteor.userId()}).settings

		data = {
			"settings.probeC": !userSettings.probeC
			"settings.probeD": !userSettings.probeD
		}
		db.users.update({_id: Meteor.userId()}, {$set: data})


	change_project_sorting_settings: (value) ->
		check(value, String)
		db.users.update({_id: Meteor.userId()}, {$set: { "settings.projectSort": value }})


	update_user_public_info: (userId, data, fileId) ->
		db.Images.remove({_id: {$ne: fileId}, userId: userId})
		db.users.update({_id: userId}, {$set: data})

#######################################