##########################################
projectViewSelector = new ReactiveVar('defectlog')
##########################################
Template.projectViewTemplate.onCreated () ->
	Meteor.subscribe "projectView", FlowRouter.getParam("id")

Template.projectViewTemplate.helpers
	projectViewSelector: () ->
		return projectViewSelector.get()

##########################################
Template.projectViewMenu.helpers
	projectViewSelector: () ->
		return projectViewSelector.get()


Template.projectViewMenu.events
	'click .project-view-menu li': (e,t) ->
		value = $(e.target).closest('li').data('value')
		projectViewSelector.set(value)
##########################################