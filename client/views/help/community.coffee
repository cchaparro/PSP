##########################################
Template.communityTemplate.helpers
	generalQuestions: () ->
		return db.questions.find({questionOwner: {$ne: Meteor.userId()}})

	userQuestions: () ->
		return db.questions.find({questionOwner: Meteor.userId()})

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

##########################################