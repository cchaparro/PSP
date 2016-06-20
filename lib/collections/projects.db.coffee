##########################################
db.projects = new Meteor.Collection "Projects"
##########################################
############## Main Schema ###############
schemas.projects = new SimpleSchema
	"title":
		type: String
		label: "Title of the Project"

	"description":
		type: String
		label: "Description of the project"

	"projectOwner":
		type: String
		label: "User who created the project"

	"parentId":
		type: String
		optional: true
		label: "Parent project id"

	"createdAt":
		type: Date
		label: "Date when the project was created"
		autoValue: (doc) ->
			if @isInsert
				return new Date()

	"levelPSP":
		type: String
		label: "Level of PSP of the project"

	"completed":
		type: Boolean
		label: "If the project was finished or not"
		autoValue: (doc) ->
			if @isInsert
				return false

##########################################
db.projects.attachSchema(schemas.projects)
##########################################