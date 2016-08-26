##########################################
db.defects = new Meteor.Collection "Defects"

##########################################
############## Main Schema ###############
schemas.defects = new SimpleSchema
	"defectOwner":
		type: String
		optional: false
		label: "Id of the defect owner"

	"projectId":
		type: String
		optional: false
		label: "Id of the defects project"

	"createdAt":
		type: Date
		label: "Date when the defect was created"
		autoValue: (doc) ->
			if @isInsert
				return new Date()

	"parentId":
		type: String
		optional: true
		label: "Id of the parent defect"

	"parentId":
		type: String
		optional: true
		label: "Id of the parent defect"

	"typeDefect":
		type: String
		optional: true
		label: "Type of the defect"

	"injected":
		type: String
		optional: true
		label: "When the defect was injected"

	"removed":
		type: String
		optional: true
		label: "When the defect was removed"

	"fixCount":
		type: Number
		optional: true
		label: "When the defect was injected"

	"description":
		type: String
		optional: true
		label: "Description of the defect"

	"time":
		type: Number
		optional: true
		label: "Time that took to fix the defect"

	"created":
		type: Boolean
		defaultValue: false
		label: "This is the value given if all the defect information was delivered by the user"

##########################################
db.defects.attachSchema(schemas.defects)
##########################################
