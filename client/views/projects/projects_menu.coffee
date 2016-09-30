##########################################
Template.projectViewMenu.helpers
	projectViewSelector: () ->
		return projectViewSelector.get()

	routeFid: () ->
		return FlowRouter.getParam("fid")

	routeId: () ->
		return FlowRouter.getParam("id")

	template: () ->
		FlowRouter.watchPathChange()
		return FlowRouter.current().route.name

##########################################
Template.projectMessages.helpers
	projectCompleted: () ->
		return db.projects.findOne({ _id: FlowRouter.getParam("id") })?.completed

##########################################