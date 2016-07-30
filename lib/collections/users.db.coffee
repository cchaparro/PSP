# ##########################################
db.users = Meteor.users
# ##########################################
# schemas.userPublicFields = new SimpleSchema
# 	"fname":
# 		type: String
# 		label: "Users first name"

# 	"lname":
# 		type: String
# 		label: "Users last name"

# 	"profileImageUrl":
# 		type: String
# 		label: "Users profile image URL"
# 		optional: true

# ############## Main Schema ###############
# schemas.user = new SimpleSchema
# 	emails:
# 		optional: true
# 		type: [Object]
# 		custom: () ->
# 			console.log @

# 	"emails.$": {
# 		type: Object
# 	},
# 	"emails.$.address": {
# 		type: String,
# 		regEx: SimpleSchema.RegEx.Email
# 	},
# 	"emails.$.verified": {
# 		type: Boolean
# 	},

# 	#"createdAt":
# 	#	type: Date
# 	#	label: "User creation date"

# 	"profile":
# 		type: schemas.userPublicFields
# 		label: "Users profile information (fname, lname, imageUrl"

# "DefectTypeList":
# 	type: String
# 	optional: true
# 	label: "Id of the defect type created as default"

# ##########################################
# db.users.attachSchema(schemas.user)
# ##########################################