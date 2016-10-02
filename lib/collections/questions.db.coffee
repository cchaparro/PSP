##########################################
db.questions = new Meteor.Collection "Questions"
##########################################
############## Main Schema ###############
schemas.questions = new SimpleSchema
	"title":
		type: String
		label: "Title of the question"

	"description":
		type: String
		label: "Description of the question"

	"questionOwner":
		type: String
		label: "User who created the question"

	"parentId":
		type: String
		optional: true
		label: "Parent question id"

	"createdAt":
		type: Date
		label: "Date when the project was created"
		autoValue: (doc) ->
			if @isInsert
				return new Date()

	"category":
		type: String
		label: "This is the category of the question"

	"amountAnswers":
		type: Number
		label: "This is the amount of answers that the question has"

	"completed":
		type: Boolean
		label: "If the question was closed or not"
		autoValue: (doc) ->
			if @isInsert
				return false

##########################################
db.questions.attachSchema(schemas.questions)
##########################################