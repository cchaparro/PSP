##################################################
Meteor.users.after.insert (userId, doc) ->
	# Creates the default defect type template for the user
	defectTypeId = syssrv.create_defect_type(@_id)

	data = {
		settings:
			probeC: false
			probeD: true

		defectTypes:
			default: defectTypeId
			current: defectTypeId
	}

	db.users.update({_id: @_id}, {$set: data})

	# This creates the welcome notification for the new user
	notificationData = {
		sender: @_id
	}
	syssrv.newNotification("new-user", @_id, notificationData)

##################################################