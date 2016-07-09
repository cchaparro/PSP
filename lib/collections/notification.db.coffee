##########################################
db.notifications = new Meteor.Collection "Notifications"
##########################################
############## Main Schema ###############
schemas.notifications = new SimpleSchema
	"notificationOwner":
		type: String
		optional: false
		label: "Id of the notification owner"

	"type":
		type: String
		optional: false
		label: "Type of the notification, this makes the template"

	"createdAt":
		type: Date
		label: "Date when the defect was created"
		autoValue: (doc) ->
			if @isInsert
				return new Date()

	"title":
		type: String
		optional: true
		label: "Title of the notification"

	"subject":
		type: String
		optional: true
		label: "Description of the notification"

##########################################
db.notifications.attachSchema(schemas.notifications)
##########################################