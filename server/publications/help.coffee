####################################
Meteor.publish "helpView", () ->
	return [
		db.questions.find()
		db.users.find({}, {fields: {'profile.profileImageUrl': 1, 'profile.fname': 1, 'profile.lname': 1}})
	]

####################################
