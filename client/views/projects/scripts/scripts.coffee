#######################################
Template.scriptsTemplate.helpers
	projectPSPversion: ()->
		return db.projects.findOne({_id: FlowRouter.getParam("id"), "projectOwner": Meteor.userId()})?.levelPSP

#######################################