##################################################
Template.forgotPasswordTemplate.onCreated () ->
	@errorState = new ReactiveVar(false)
	@emailSent = new ReactiveVar(false)
	document.title = "Recuperar Contraseña"


Template.forgotPasswordTemplate.helpers
	errorMessage: () ->
		isError = Template.instance().errorState.get()
		return "Ingresaste un correo que no es valido" or "\xa0" if isError

	emailIsSent: () ->
		return Template.instance().emailSent.get()


Template.forgotPasswordTemplate.events
	'click .access-selection-box': (e,t) ->
		FlowRouter.go("/")

	'submit form': (e,t) ->
		e.preventDefault()
		email = $('#email').val()

		if sys.isEmail(email)
			options = {email: email}
			Accounts.forgotPassword options, (error) ->
				if error
					console.warn(error)
				else
					t.emailSent.set(true)
		else
			if email.length > 0
				t.errorState.set("email")
				$('#email').val('')

##################################################
Template.resetPasswordTemplate.events
	'click .access-selection-box': (e,t) ->
		FlowRouter.go("/")

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

##################################################