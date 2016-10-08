##########################################
Template.communityTemplate.helpers
	generalQuestions: () ->
		return db.questions.find({questionOwner: {$ne: Meteor.userId()}, parentId: null})

	userQuestions: () ->
		return db.questions.find({questionOwner: Meteor.userId(), parentId: null})

	noQuestions: () ->
		return db.questions.find({questionOwner: Meteor.userId(), parentId: null}).count() == 0

##########################################
Template.question.helpers
	categoryColor: () ->
		switch @question.category
			when "general"
				return "#00c1ed"
			when "interface"
				return "#ff8052"
			when "psp"
				return "#ffb427"

	questionTitle: () ->
		return sys.cutText(@question.title, 70, " ...") or "" if @question.title

	questionDescription: () ->
		return sys.cutText(@question.description, 220, " ...") or "" if @question.description

##########################################
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

	isOwner: () ->
		questionId = FlowRouter.getParam("question")
		return db.questions.findOne({_id: questionId})?.questionOwner == Meteor.userId()


Template.questionTemplate.events
	'click .close-question': (e,t) ->
		questionId = FlowRouter.getParam("question")
		Meteor.call "cumplete_question", questionId, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("error-finish-question")
			else
				sys.flashStatus("finish-question")

##########################################
Template.generalQuestion.helpers
	momentToNow: (createdAt) ->
		return moment(createdAt).fromNow()

	categoryColor: () ->
		switch @category
			when "general"
				return "#00c1ed"
			when "interface"
				return "#ff8052"
			when "psp"
				return "#ffb427"

##########################################
Template.questionAnswer.helpers
	momentToNow: (createdAt) ->
		return moment(createdAt).fromNow()

##########################################
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
				sys.flashStatus("error-create-question")
			else
				sys.flashStatus("create-question")
				$(".answer-text").val('')


##########################################