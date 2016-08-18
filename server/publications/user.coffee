####################################
Meteor.publish "UserMenu", () ->
	return [
		db.notifications.find({"notificationOwner": @userId})
		db.users.find({_id: @userId})
	]

Meteor.publish "projectSettings", () ->
	return [
		db.users.find({_id: @userId})
		db.projects.find({"projectOwner": @userId})
		db.defect_types.find({"defectTypeOwner": @userId})
	]

Meteor.publish "accountSettings", () ->
	return [
		db.users.find({_id: @userId})
		db.files.find({ "metadata.fileOwner": @userId})
	]

####################################