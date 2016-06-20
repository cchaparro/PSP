##################################################
Template.main_menuBar.helpers
	template: () ->
		FlowRouter.watchPathChange()
		return FlowRouter.current().route.name

	isProjectView: () ->
		FlowRouter.watchPathChange()
		route = FlowRouter.current().route.name
		return (route == 'main') or (route == 'projectView') or (route == 'iterationView')

##################################################