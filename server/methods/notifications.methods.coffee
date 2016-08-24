#######################################
Meteor.methods
	createNotification: (type, userId) ->
		syssrv.newNotification(type, userId)

	notificationsSeen: () ->
		db.notifications.update({"notificationOwner": Meteor.userId(), "seen": false}, {$set: {"seen": true}}, {multi:true})

	notificationClicked: (notificationId) ->
		db.notifications.update({_id: notificationId, "notificationOwner": Meteor.userId(), "clicked": false}, {$set: {"seen": true, "clicked": true}})

	disable_notification: (notificationId) ->
		db.notifications.update({_id: notificationId}, {$set: {"data.reverted": true}})

#######################################