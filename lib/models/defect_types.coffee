##########################################
if Meteor.isServer
	syssrv.create_defect_type = (userId, data=undefined, update_user=false) ->
		if update_user
			defects = data
		else
			defects = Meteor?.settings?.public?.defectTypeValues

		data = {
			"defectTypeOwner": userId,
			"lastModified": new Date(),
			"defects": defects
		}

		defectTypeId = db.defect_types.insert(data)

		db.users.update({_id: userId}, {$set: {"defectTypes.current": defectTypeId}})
		return defectTypeId

##########################################