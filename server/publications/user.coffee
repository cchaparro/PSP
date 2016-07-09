####################################
Meteor.publish "UserMenu", () ->
	return db.notifications.find({"notificationOwner": @userId})

####################################