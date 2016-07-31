#######################################
Meteor.methods
	create_defect_types: (userId, data=undefined, update_user=false) ->
		syssrv.create_defect_type(userId, data, update_user)

#######################################