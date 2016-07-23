####################################
Meteor.publish "UserMenu", () ->
	return db.notifications.find({"notificationOwner": @userId})

Meteor.publish "projectSettings", () ->
	return [
		db.users.find({_id: @userId})
		db.projects.find({"projectOwner": @userId})
	]

####################################