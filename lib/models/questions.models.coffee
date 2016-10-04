##########################################
if Meteor.isServer
	syssrv.createQuestion = (data, isAnswer) ->
		data.questionOwner = Meteor.userId()

		if isAnswer
			db.questions.update({_id: data.parentId}, { $inc: {amountAnswers: 1} })

			#This is the root question which just got a answer over
			answeredQuestion = db.questions.findOne({_id: data.parentId})

			unless answeredQuestion?.questionOwner == Meteor.userId()
				name = "#{Meteor.user().profile.fname} #{Meteor.user().profile.lname}" 
				notification = {
					title: "Probando aqui funciona bien todo esto y deberia demostrar"
					sender: Meteor.userId()
					senderName: name
					questionId: data.parentId
				}
				syssrv.newNotification("question-response", answeredQuestion?.questionOwner, notification)

		db.questions.insert(data)


##########################################