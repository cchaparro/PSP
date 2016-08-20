##########################################
# This redirects to projects if the user is logged or to login if the user is not logged
if Meteor.isClient
	Accounts.onLogin () ->
		FlowRouter.go('projects')

	Accounts.onLogout () ->
		FlowRouter.go('login')


FlowRouter.triggers.enter([ (content, redirect) ->
	unless Meteor.userId()
		console.log "Not logged in --> Redirecting"
		FlowRouter.go('login')
], except: [
	'register'
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




Projects = FlowRouter.group(
	prefix: '/projects'
)

Projects.route '/',
	name: 'projects'
	subscriptions: (params, queryParams) ->
		@register 'allProjects', Meteor.subscribe "allProjects"

	action: ->
		BlazeLayout.render 'masterLayout', main: 'projectsTemplate'


Projects.route '/:fid',
	name: 'iterations'
	subscriptions: (params, queryParams) ->
		@register 'allProjects', Meteor.subscribe "allProjects"

	action: ->
		BlazeLayout.render 'masterLayout', main: 'iterationsViewTemplate'


Projects.route '/:fid/:id',
	name: 'projectGeneral'

	subscriptions: (params) ->
		@register 'projectView', Meteor.subscribe "projectView", params.id

	action: () ->
		BlazeLayout.render 'masterLayout', main: 'projectInformationTemplate'


Projects.route '/:fid/:id/time-log',
	name: 'projectTimeLog'

	subscriptions: (params) ->
		@register 'projectView', Meteor.subscribe "projectView", params.id

	action: () ->
		BlazeLayout.render 'masterLayout', main: 'timeTemplate'


Projects.route '/:fid/:id/defect-log',
	name: 'projectDefectLog'

	subscriptions: (params) ->
		@register 'projectView', Meteor.subscribe "projectView", params.id

	action: () ->
		BlazeLayout.render 'masterLayout', main: 'defectsTemplate'


Projects.route '/:fid/:id/plan-summary',
	name: 'projectSummary'

	subscriptions: (params) ->
		@register 'projectView', Meteor.subscribe "projectView", params.id

	action: () ->
		BlazeLayout.render 'masterLayout', main: 'planSummaryTemplate'


Projects.route '/:fid/:id/scripts',
	name: 'projectScripts'

	subscriptions: (params) ->
		@register 'projectView', Meteor.subscribe "projectView", params.id

	action: () ->
		BlazeLayout.render 'masterLayout', main: 'scriptsTemplate'




Settings = FlowRouter.group(
	prefix: '/settings'
)

Settings.route '/project',
	name: 'projectSettings'
	subscriptions: (params, queryParams) ->
		@register 'projectSettings', Meteor.subscribe "projectSettings"

	action: ->
		BlazeLayout.render 'masterLayout', main: 'projectSettingsTemplate'


Settings.route '/account',
	name: 'accountSettings'
	subscriptions: (params, queryParams) ->
		@register 'accountSettings', Meteor.subscribe "accountSettings"

	action: ->
		BlazeLayout.render 'masterLayout', main: 'accountSettingsTemplate'


Settings.route '/type-defects',
	name: 'defectTypeSettings'
	subscriptions: (params, queryParams) ->
		@register 'projectSettings', Meteor.subscribe "projectSettings"

	action: ->
		BlazeLayout.render 'masterLayout', main: 'defectTypeSettingsTemplate'




FlowRouter.route '/overview',
	name: 'overview'
	action: ->
		BlazeLayout.render 'masterLayout', main: 'overviewTemplate'




FlowRouter.route '/help',
	name: 'help'
	action: ->
		BlazeLayout.render 'masterLayout', main: 'helpTemplate'

##########################################