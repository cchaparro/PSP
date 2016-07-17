##################################################
Meteor.users.after.insert (userId, doc) ->
	data = {
		settings:
			probeC: false
			probeD: true
	}

	db.users.update({_id: @_id}, {$set: data})

##################################################