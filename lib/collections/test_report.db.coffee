##########################################
db.testReports = new Meteor.Collection "TestReports"

##########################################
############## Main Schema ###############
schemas.testReports = new SimpleSchema
	"TestOwner":
		type: String
		optional: false
		label: "Id of the reports owner"

	"projectId":
		type: String
		optional: false
		label: "Id of the reports project"

	"createdAt":
		type: Date
		label: "Date when the test report was created"
		autoValue: (doc) ->
			if @isInsert
				return new Date()

	"purpose":
		type: String
		optional: true
		label: "Tests purpose"

	"expectedResults":
		type: String
		optional: true
		label: "Expeted results of the test"	
	
	"actualResults":
		type: String
		optional: true
		label: "Actual Results"

##########################################
db.testReports.attachSchema(schemas.testReports)
##########################################