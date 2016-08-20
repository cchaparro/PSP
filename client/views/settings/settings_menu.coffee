##########################################
Template.settingsMenu.helpers
	template: () ->
		FlowRouter.watchPathChange()
		return FlowRouter.current().route.name

##########################################