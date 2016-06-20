#######################################
Meteor.methods
	create_defect_types: (uid) ->
		data = {
			"defectTypeOwner": uid,
			"lastModified": new Date(),
			"defects": Meteor.settings.public.defectTypeValues
		}

		db.defect_types.insert(data)
#######################################