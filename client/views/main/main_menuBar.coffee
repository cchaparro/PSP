##################################################
Template.main_menuBar.helpers
	template: () ->
		FlowRouter.watchPathChange()
		return FlowRouter.current().route.name

	isProjectView: () ->
		FlowRouter.watchPathChange()
		route = FlowRouter.current().route.name
		return (route == 'main') or (route == 'projectView') or (route == 'iterationView') or (route == "projectGeneral") or (route == "projectTimeLog") or (route == "projectDefectLog") or (route == "projectSummary")

	isSettingsView: () ->
		FlowRouter.watchPathChange()
		route = FlowRouter.current().route.name
		return (route == 'projectSettings') or (route == 'accountSettings') or (route == 'defectTypeSettings')

##################################################