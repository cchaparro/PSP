Template.resetPasswordTemplate.events
	'submit form': (e,t) ->
		e.preventDefault()
		password1 = $('#password1').val()
		password2 = $('#password2').val()

		if password1 == password2
			token = FlowRouter.getParam("token")

			Accounts.resetPassword token, password1, (error) ->
				if error
					console.warn(error)
				else
					Meteor.call "createNotification", "password-reset", Meteor.userId()
					FlowRouter.go('privateRoute.general')
