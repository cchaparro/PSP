##################################################
Template.loginTemplate.onCreated () ->

Template.loginTemplate.helpers

Template.loginTemplate.events
	'submit form': (e,t) ->
		e.preventDefault()

		email = $('#email').val()
		password = $('#password').val()

		if sys.isEmail(email) and (email isnt '') and (password isnt '')
			Meteor.loginWithPassword email, password, (error) ->
				if error
					if error.reason == "User not found"
						$('#email').val('')
						$('#password').val('')

					else if error.reason == "Incorrect password"
						$('#password').val('')

				else
					FlowRouter.go("/")

		if not sys.isEmail(email)
			$('#email').val('')
			$('#password').val('')


	'click .access-selection-box': (e,t) ->
		FlowRouter.go("/register")

##################################################