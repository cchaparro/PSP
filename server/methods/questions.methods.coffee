##########################################
Meteor.methods
	send_email: (data) ->
		check(data, Object)
		@unblock()

		return Email.send({
			to: data.to,
			from: data.from,
			subject: data.subject,
			html: "<p>#{data.text}</p>",
		})

	create_question: (data, isAnswer=false) ->
		syssrv.createQuestion(data, isAnswer)

	cumplete_question: (questionId) ->
		db.questions.update({_id: questionId}, {$set: {"completed": true}})

##########################################