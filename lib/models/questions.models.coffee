##########################################
if Meteor.isServer
	syssrv.createQuestion = (data, isAnswer) ->
		data.questionOwner = Meteor.userId()

		if isAnswer
			db.questions.update({_id: data.parentId}, { $inc: {amountAnswers: 1} })

		db.questions.insert(data)


##########################################