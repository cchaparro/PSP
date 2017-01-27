publicRoutes = FlowRouter.group
	triggersEnter: [ ()->
		if Meteor.userId()
			FlowRouter.go('privateRoute.general')
	]

publicRoutes.route '/login',
	name: 'publicRoute.login'
	action: ->
		BlazeLayout.render 'accessLayout', main: 'loginTemplate'

publicRoutes.route '/signup',
	name: 'publicRoute.signup'
	action: ->
		BlazeLayout.render 'accessLayout', main: 'registerTemplate'

publicRoutes.route '/forgot',
	name: 'publicRoute.forgot'
	action: ->
		BlazeLayout.render 'accessLayout', main: 'forgotPasswordTemplate'

publicRoutes.route '/reset-password/:token',
	name: 'publicRoute.resetPassword'
	action: ->
		BlazeLayout.render 'accessLayout', main: 'resetPasswordTemplate'
