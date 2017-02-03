Meteor.publish "userNotifications", () ->
	return [
		db.notifications.find({notificationOwner: @userId})
		db.questions.find()
		db.users.find({}, {fields: {profile: 1}})
	]