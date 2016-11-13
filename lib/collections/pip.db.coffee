##########################################
db.pips = new Meteor.Collection "Pip"

schemas.pipDefects = new SimpleSchema
	"DefectType":
		type: String
		optional: false
		label: "Defect type"
	"Solved":
		type: Boolean
		optional: false
		label: "The pip solve this defect"

##########################################
############## Main Schema ###############
schemas.pips = new SimpleSchema
	"pipOwner":
		type: String
		optional: false
		label: "Id of the pip owner"

	"projectId":
		type: String
		optional: false
		label: "Id of the pip project"
	
	"title":
		type: String
		optional: false
		label: "Title of the pip"

	"createdAt":
		type: Date
		label: "Date when the pip was created"
		autoValue: (doc) ->
			if @isInsert
				return new Date()

	"problemDescription":
		type: String
		optional: true
		label: "Description of the problem"
	
	"proposalDescription":
		type: String
		optional: true
		label: "Description of the solution to the problem"

	"defectsSolved":
		type: Array
		optional: false
		label: "Solved defects with this pip"

	"defectsSolved.$":
		type: schemas.pipDefects
		optional: false
		label: "Solved defects with this pip"

##########################################
db.pips.attachSchema(schemas.pips)
##########################################