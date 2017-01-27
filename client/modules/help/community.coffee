Template.communityTemplate.helpers
	userQuestions: () ->
		userId = Meteor.userId()
		return db.questions.find({questionOwner: userId, parentId: null})

	generalQuestions: () ->
		userId = Meteor.userId()
		return db.questions.find({questionOwner: {$ne: userId}, parentId: null})

	noQuestions: () ->
		return db.questions.find({parentId: null}).count() == 0


Template.question.helpers
	categoryColor: () ->
		switch @question.category
			when "general"
				return "#00c1ed"
			when "interface"
				return "#ff8052"
			when "psp"
				return "#ffb427"

	questionCategory: () ->
		switch @question.category
			when "general"
				return "General"
			when "interface"
				return "Interfaz"
			when "psp"
				return "Metodologia PSP"

	questionTitle: () ->
		return sys.cutText(@question.title, 70, " ...") or "" if @question.title

	questionDescription: () ->
		return sys.cutText(@question.description, 165, " ...") or "" if @question.description


Template.closeQuestionAction.helpers
	questionDisabled: () ->
		questionId = FlowRouter.getParam("question")
		userId = Meteor.userId()
		return true if db.questions.findOne({_id: questionId})?.questionOwner != userId
		return true if db.questions.findOne({_id: questionId})?.completed
		return false


Template.closeQuestionAction.events
	'click .question-close': (e,t) ->
		e.stopPropagation()
		e.preventDefault()
		questionId = FlowRouter.getParam("question")

		Meteor.call "cumplete_question", questionId, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("question-close-error")
			else
				sys.flashStatus("question-close-successful")


Template.questionTemplate.helpers
	questionView: () ->
		questionId = FlowRouter.getParam("question")
		return db.questions.findOne({_id: questionId})

	questionAnswers: () ->
		questionId = FlowRouter.getParam("question")
		return db.questions.find({parentId: questionId})

	isFinished:() ->
		questionId = FlowRouter.getParam("question")
		return db.questions.findOne({_id: questionId})?.completed


Template.generalQuestion.helpers
	categoryColor: () ->
		switch @category
			when "general"
				return "#00c1ed"
			when "interface"
				return "#ff8052"
			when "psp"
				return "#ffb427"

	questionCategory: () ->
		switch @category
			when "general"
				return "General"
			when "interface"
				return "Interfaz"
			when "psp"
				return "Metodologia PSP"


Template.addQuestionAnswer.events
	'click .add-answer': (e,t) ->
		questionId = FlowRouter.getParam("question")
		questionCategory = db.questions.findOne({_id: questionId})?.category
		text = $(".answer-text").val()

		data = {
			title: null
			description: text
			category: questionCategory
			parentId: questionId
			amountAnswers: 0
			completed: false
		}

		Meteor.call "create_question", data, true, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("question-answer-error")
			else
				sys.flashStatus("question-answer-successful")
				$(".answer-text").val('')

