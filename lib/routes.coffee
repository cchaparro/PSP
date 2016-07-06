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