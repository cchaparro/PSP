privateRoutes = FlowRouter.group
	triggersEnter: [ ()->
		unless Meteor.loggingIn() or Meteor.userId()
			route = FlowRouter.current()
			currentRoute = route.route.name

			unless currentRoute is 'login'
				FlowRouter.go('publicRoute.login')
	]


# privateRoutes defined routes
privateRoutes.route '/',
	name: 'privateRoute.general'
	subscriptions: (params, queryParams) ->
		@register 'allProjects', Meteor.subscribe "allProjects"
	action: ->
		Session.set 'route', 'privateRoute.general'
		BlazeLayout.render 'masterLayout', main: 'projectsTemplate'


privateRoutes.route '/project/:fid',
	name: 'privateRoute.iterations'
	subscriptions: (params, queryParams) ->
		@register 'allProjects', Meteor.subscribe "allProjects"
	action: ->
		Session.set 'route', 'privateRoute.iterations'
		BlazeLayout.render 'masterLayout', main: 'iterationsViewTemplate'


privateRoutes.route '/project/:fid/:id',
	name: 'privateRoute.projectGeneral'
	subscriptions: (params) ->
		@register 'projectView', Meteor.subscribe "projectView", params.id
	action: () ->
		Session.set 'route', 'privateRoute.projectGeneral'
		BlazeLayout.render 'masterLayout', main: 'projectInformationTemplate', menu: "projectViewMenu", information: "projectInformation"


privateRoutes.route '/project/:fid/:id/summary',
	name: 'privateRoute.summary'
	subscriptions: (params) ->
		@register 'projectView', Meteor.subscribe "projectView", params.id
	action: () ->
		Session.set 'route', 'privateRoute.summary'
		BlazeLayout.render 'masterLayout', main: 'planSummaryTemplate', menu: "projectViewMenu", information: "projectInformation"


privateRoutes.route '/project/:fid/:id/time',
	name: 'privateRoute.timeLog'
	subscriptions: (params) ->
		Session.set 'route', 'privateRoute.timeLog'
		@register 'projectView', Meteor.subscribe "projectView", params.id
	action: () ->
		BlazeLayout.render 'masterLayout', main: 'timeTemplate', menu: "projectViewMenu", information: "timeLogInformation"


privateRoutes.route '/project/:fid/:id/defects',
	name: 'privateRoute.defectLog'
	subscriptions: (params) ->
		@register 'projectView', Meteor.subscribe "projectView", params.id
	action: () ->
		Session.set 'route', 'privateRoute.defectLog'
		BlazeLayout.render 'masterLayout', main: 'defectsTemplate', menu: "projectViewMenu", information: "projectInformation"


privateRoutes.route '/project/:fid/:id/scripts',
	name: 'privateRoute.scripts'
	subscriptions: (params) ->
		@register 'projectView', Meteor.subscribe "projectView", params.id
	action: () ->
		Session.set 'route', 'privateRoute.scripts'
		BlazeLayout.render 'masterLayout', main: 'scriptsTemplate', menu: "projectViewMenu", information: "projectInformation"


privateRoutes.route '/project/:fid/:id/form',
	name: 'privateRoute.forms'
	subscriptions: (params) ->
		@register 'projectView', Meteor.subscribe "pspForms", params.id
	action: () ->
		Session.set 'route', 'privateRoute.forms'
		BlazeLayout.render 'masterLayout', main: 'formTemplate', menu: "projectViewMenu"


privateRoutes.route '/project/:fid/:id/estimating',
	name: 'privateRoute.estimating'
	subscriptions: (params) ->
		@register 'projectView', Meteor.subscribe "estimatingView", params.id
	action: () ->
		Session.set 'route', 'privateRoute.estimating'
		BlazeLayout.render 'masterLayout', main: 'estimatingTemplate', menu: "projectViewMenu"


privateRoutes.route '/project/:fid/:id/pqi-template',
	name: 'privateRoute.pqi'
	subscriptions: (params) ->
		@register 'projectView', Meteor.subscribe "estimatingView", params.id
	action: () ->
		Session.set 'route', 'privateRoute.pqi'
		BlazeLayout.render 'masterLayout', main: 'pqiTemplate', menu: "projectViewMenu"





privateRoutes.route '/settings',
	name: 'privateRoute.settings'
	subscriptions: (params, queryParams) ->
		@register 'projectSettings', Meteor.subscribe "projectSettings"

	action: ->
		Session.set 'route', 'privateRoute.settings'
		BlazeLayout.render 'masterLayout', main: 'defectTypeSettingsTemplate', menu: "settingsMenu"


privateRoutes.route '/overview',
	name: 'privateRoute.overview'
	subscriptions: (params, queryParams) ->
		@register 'chartStages', Meteor.subscribe "chartStages"
	action: ->
		Session.set 'route', 'privateRoute.overview'
		BlazeLayout.render 'masterLayout', main: 'overviewTemplate'


privateRoutes.route '/help/',
	name: 'privateRoute.help'
	action: ->
		Session.set "route", "privateRoute.help"
		BlazeLayout.render 'masterLayout', main: 'helpTemplate'

privateRoutes.route '/help/community',
	name: 'privateRoute.community'
	subscriptions: (params, queryParams) ->
		@register 'helpView', Meteor.subscribe "helpView"
	action: ->
		Session.set "route", "privateRoute.community"
		BlazeLayout.render 'masterLayout', main: 'communityTemplate'

privateRoutes.route '/help/community/:question',
	name: 'privateRoute.communityQuestion'
	action: ->
		Session.set "route", "privateRoute.community"
		BlazeLayout.render 'masterLayout', main: 'questionTemplate'

	subscriptions: (params, queryParams) ->
		@register 'helpView', Meteor.subscribe "helpView"

privateRoutes.route '/help/tutorial',
	name: 'privateRoute.tutorial'
	action: ->
		Session.set "route", 'privateRoute.tutorial'
		BlazeLayout.render 'masterLayout', main: 'tutorialTemplate'

