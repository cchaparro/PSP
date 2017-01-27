#######################################
Template.scriptsTemplate.helpers
	levelPSP: ()->
		return db.projects.findOne({_id: FlowRouter.getParam("id"), "projectOwner": Meteor.userId()})?.levelPSP

	scriptTemplate: () ->
		projectId = FlowRouter.getParam("id")
		userId = Meteor.userId()
		levelPSP = db.projects.findOne({_id: projectId, projectOwner: userId})?.levelPSP

		switch levelPSP
			when 'PSP 0'
				return 'scriptPSP0'
			when 'PSP 1'
				return 'scriptPSP1'
			when 'PSP 2'
				return 'scriptPSP2'
			else
				return false

#######################################