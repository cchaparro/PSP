##########################################
db.defect_types = new Meteor.Collection "DefectTypes"
##########################################
schemas.defects = new SimpleSchema
	"name":
		type: String
		label: "Defect type name"

	"description":
		type: String
		label: "Defect type description"

##########################################
############## Main Schema ###############
schemas.defect_types = new SimpleSchema
	"lastModified":
		type: Date
		label: "Date when the defect type was last modified"
		autoValue: (doc) ->
			if @isInsert
				return new Date()

	"defectTypeOwner":
		type: String
		optional: false
		label: "Id of the defect type list owner"

	"defects":
		type: Array
		label: "Time estimation of Plan Summary"

	"defects.$":
		type: schemas.defects
		label: "One time estimation of Plan Summary"

##########################################
db.defect_types.attachSchema(schemas.defect_types)
##########################################