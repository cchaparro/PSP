####################################
Meteor.publish "helpView", () ->
	return [
		db.questions.find()
		db.users.find({}, {fields: {'profile.profileImageUrl': 1}})
	]

####################################
