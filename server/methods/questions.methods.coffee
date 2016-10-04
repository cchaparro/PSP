##########################################
Meteor.methods
	create_question: (data, isAnswer=false) ->
		syssrv.createQuestion(data, isAnswer)

	cumplete_question: (questionId) ->
		db.questions.update({_id: questionId}, {$set: {"completed": true}})

##########################################