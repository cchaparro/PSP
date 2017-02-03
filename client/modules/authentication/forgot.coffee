Template.forgotPasswordTemplate.onCreated () ->
	@errorState = new ReactiveVar(false)
	@emailSent = new ReactiveVar(false)
	document.title = "Recuperar Contraseña"


Template.forgotPasswordTemplate.helpers
	errorMessage: () ->
		isError = Template.instance().errorState.get()
		return "Ingresaste un correo que no es valido" or false if isError

	emailIsSent: () ->
		return Template.instance().emailSent.get()


Template.forgotPasswordTemplate.events
	'click .access-selection-box': (e,t) ->
		FlowRouter.go('publicRoute.login')

	'submit form': (e,t) ->
		e.preventDefault()
		email = t.$('[name="email"]').val()
		console.log email

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
				t.$('[name="email"]').val('')

