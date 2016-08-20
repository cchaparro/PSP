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