##########################################
# This redirects to projects if the user is logged or to login if the user is not logged
if Meteor.isClient
	Accounts.onLogin () ->
		FlowRouter.go('projects')

	Accounts.onLogout () ->
		FlowRouter.go('login')

# This triggers the verification if logged in when the route changes. If its not it will always take you to the login route
FlowRouter.triggers.enter([ (content, redirect) ->
	unless Meteor.userId()
		FlowRouter.go('login')
], except: [
	'register', 'forgot', 'reset-password'
])

##########################################
FlowRouter.route '/',
	name: 'login'
	action: ->
		if Meteor.userId()
			FlowRouter.go('projects')
		BlazeLayout.render 'accessLayout', main: 'loginTemplate'


FlowRouter.route '/register',
	name: 'register'
	action: ->
		if Meteor.userId()
			FlowRouter.go('projects')
		BlazeLayout.render 'accessLayout', main: 'registerTemplate'


FlowRouter.route '/forgot',
	name: 'forgot'
	action: ->
		if Meteor.userId()
			FlowRouter.go('projects')
		BlazeLayout.render 'accessLayout', main: 'forgotPasswordTemplate'


FlowRouter.route '/reset-password/:token',
	name: 'reset-password'
	action: ->
		if Meteor.userId()
			FlowRouter.go('projects')
		BlazeLayout.render 'accessLayout', main: 'resetPasswordTemplate'


# This group is created to structure all the route pages inside the '/projects'
Projects = FlowRouter.group(
	prefix: '/projects'
)

Projects.route '/',
	name: 'projects'
	subscriptions: (params, queryParams) ->
		@register 'allProjects', Meteor.subscribe "allProjects"

	action: ->
		Session.set "route", "projects"
		BlazeLayout.render 'masterLayout', main: 'projectsTemplate'


Projects.route '/:fid',
	name: 'iterations'
	subscriptions: (params, queryParams) ->
		@register 'allProjects', Meteor.subscribe "allProjects"

	action: ->
		Session.set "route", "iterations"
		BlazeLayout.render 'masterLayout', main: 'iterationsViewTemplate'


Projects.route '/:fid/:id',
	name: 'projectGeneral'

	subscriptions: (params) ->
		@register 'projectView', Meteor.subscribe "projectView", params.id

	action: () ->
		Session.set "route", "general"
		BlazeLayout.render 'masterLayout', main: 'projectInformationTemplate', menu: "projectViewMenu"


Projects.route '/:fid/:id/time-log',
	name: 'projectTimeLog'

	subscriptions: (params) ->
		Session.set "route", "timeLog"
		@register 'projectView', Meteor.subscribe "projectView", params.id

	action: () ->
		BlazeLayout.render 'masterLayout', main: 'timeTemplate', menu: "projectViewMenu"


Projects.route '/:fid/:id/defect-log',
	name: 'projectDefectLog'

	subscriptions: (params) ->
		@register 'projectView', Meteor.subscribe "projectView", params.id

	action: () ->
		Session.set "route", "defectLog"
		BlazeLayout.render 'masterLayout', main: 'defectsTemplate', menu: "projectViewMenu"


Projects.route '/:fid/:id/plan-summary',
	name: 'projectSummary'

	subscriptions: (params) ->
		@register 'projectView', Meteor.subscribe "projectView", params.id

	action: () ->
		Session.set "route", "planSummary"
		BlazeLayout.render 'masterLayout', main: 'planSummaryTemplate', menu: "projectViewMenu"


Projects.route '/:fid/:id/scripts',
	name: 'projectScripts'

	subscriptions: (params) ->
		@register 'projectView', Meteor.subscribe "projectView", params.id

	action: () ->
		Session.set "route", "scripts"
		BlazeLayout.render 'masterLayout', main: 'scriptsTemplate', menu: "projectViewMenu"


Projects.route '/:fid/:id/estimating-template',
	name: 'estimatingtemplate'

	subscriptions: (params) ->
		@register 'projectView', Meteor.subscribe "estimatingView", params.id

	action: () ->
		Session.set "route", "estimatingTemplate"
		BlazeLayout.render 'masterLayout', main: 'estimatingTemplate', menu: "projectViewMenu"


Settings = FlowRouter.group(
	prefix: '/settings'
)

Settings.route '/project',
	name: 'projectSettings'
	subscriptions: (params, queryParams) ->
		@register 'projectSettings', Meteor.subscribe "projectSettings"

	action: ->
		Session.set "route", "settings"
		BlazeLayout.render 'masterLayout', main: 'projectSettingsTemplate', menu: "settingsMenu"



Settings.route '/type-defects',
	name: 'defectTypeSettings'
	subscriptions: (params, queryParams) ->
		@register 'projectSettings', Meteor.subscribe "projectSettings"

	action: ->
		Session.set "route", "defectTypes"
		BlazeLayout.render 'masterLayout', main: 'defectTypeSettingsTemplate', menu: "settingsMenu"


FlowRouter.route '/overview',
	name: 'overview'

	subscriptions: (params, queryParams) ->
		@register 'chartStages', Meteor.subscribe "chartStages"

	action: ->
		BlazeLayout.render 'masterLayout', main: 'overviewTemplate'




Help = FlowRouter.group(
	prefix: '/help'
)

Help.route '/',
	name: 'help'
	action: ->
		Session.set "route", "help"
		BlazeLayout.render 'masterLayout', main: 'helpTemplate'

Help.route '/community',
	name: 'community'
	action: ->
		Session.set "route", "community"
		BlazeLayout.render 'masterLayout', main: 'communityTemplate'

	subscriptions: (params, queryParams) ->
		@register 'helpView', Meteor.subscribe "helpView"

Help.route '/contact',
	name: 'help-contact'
	action: ->
		Session.set "route", "help-contact"
		BlazeLayout.render 'masterLayout', main: 'contactTemplate'

##########################################