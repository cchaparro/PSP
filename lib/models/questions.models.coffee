##########################################
if Meteor.isServer
	syssrv.createQuestion = (data) ->
		data.questionOwner = Meteor.userId()

		db.questions.insert(data)


##########################################