##########################################
FlowRouter.route '/login',
	action: ->
		BlazeLayout.render 'accessLayout', main: 'loginTemplate'
	name: 'login'

FlowRouter.route '/register',
	action: ->
		BlazeLayout.render 'accessLayout', main: 'registerTemplate'
	name: 'register'

##########################################
FlowRouter.route '/',
	action: ->
		BlazeLayout.render 'masterLayout', main: 'projectsTemplate'
	name: 'main'

FlowRouter.route '/overview',
	action: ->
		BlazeLayout.render 'masterLayout', main: 'overviewTemplate'
	name: 'overview'

FlowRouter.route '/settings',
	action: ->
		BlazeLayout.render 'masterLayout', main: 'settingsTemplate'
	name: 'settings'

FlowRouter.route '/settings/project_settings',
	action: ->
		BlazeLayout.render 'masterLayout', main: 'projectSettingsTemplate'
	name: 'projectSettings'

FlowRouter.route '/settings/account_settings',
	action: ->
		BlazeLayout.render 'masterLayout', main: 'accountSettingsTemplate'
	name: 'accountSettings'

FlowRouter.route '/help',
	action: ->
		BlazeLayout.render 'masterLayout', main: 'helpTemplate'
	name: 'help'

##########################################
FlowRouter.route '/:fid',
	action: ->
		BlazeLayout.render 'masterLayout', main: 'iterationsViewTemplate'
	name: 'iterationView'

FlowRouter.route '/:fid/:id',
	action: ->
		BlazeLayout.render 'masterLayout', main: 'projectViewTemplate'
	name: 'projectView'

##########################################
FlowRouter.route '/:fid/:id/general',
	action: ->
		BlazeLayout.render 'masterLayout', main: 'projectInformationTemplate'
	name: 'projectGeneral'

FlowRouter.route '/:fid/:id/timelog',
	action: ->
		BlazeLayout.render 'masterLayout', main: 'timeTemplate'
	name: 'projectTimeLog'

FlowRouter.route '/:fid/:id/defectlog',
	action: ->
		BlazeLayout.render 'masterLayout', main: 'defectsTemplate'
	name: 'projectDefectLog'

FlowRouter.route '/:fid/:id/plansummary',
	action: ->
		BlazeLayout.render 'masterLayout', main: 'planSummaryTemplate'
	name: 'projectSummary'

##########################################