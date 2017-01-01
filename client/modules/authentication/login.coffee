Template.loginTemplate.onCreated () ->
	@errorState = new ReactiveVar(false)


Template.loginTemplate.helpers
	errorState: () ->
		return Template.instance().errorState.get()

	errorMessage: () ->
		errorState = Template.instance().errorState.get()
		switch errorState
			when 'user'
				return "El correo electrónico ingresado no esta registrado."
			when 'email'
				return "Ingresaste un correo electrónico que no es valido"
			when 'password'
				return "La contraseña ingresada es incorrecta"
			else
				return false


Template.loginTemplate.events
	'keypress [name="emailAddress"]': (e,t) ->
		if t.errorState.get()
			t.errorState.set(false)

	'keypress [name="password"]': (e,t) ->
		if t.errorState.get()
			t.errorState.set(false)

	'submit form': (e, t) ->
		e.preventDefault()
		e.stopPropagation()

		email = t.$('[name="emailAddress"]').val()
		password = t.$('[name="password"]').val()

		if sys.isEmail(email) and password
			Meteor.loginWithPassword email, password, (error) ->
				if error
					if error.reason == "User not found"
						t.errorState.set("user")
						t.$('[name="emailAddress"]').val('')
						t.$('[name="password"]').val('')

					else if error.reason == "Incorrect password"
						t.errorState.set("password")
						t.$('[name="password"]').val('')
				else
					FlowRouter.go("privateRoute.general")

		if !sys.isEmail(email) and email.length > 0
			t.errorState.set("email")
			t.$('[name="emailAddress"]').val('')
			t.$('[name="password"]').val('')

	'click .auth-forgot': (e,t) ->
		FlowRouter.go('publicRoute.forgot')

	'click .auth-facebook': (e,t) ->
		e.preventDefault()
		e.stopPropagation()

		Meteor.loginWithFacebook { requestPermissions: [ 'email' ] }, (error) ->
			if error
				console.warn(error)
			else
				FlowRouter.go("privateRoute.general")

	'click .auth-google': (e,t) ->
		e.preventDefault()
		e.stopPropagation()

		Meteor.loginWithGoogle { requestPermissions: [ 'email' ] }, (error) ->
			if error
				console.warn(error)
			else
				FlowRouter.go("privateRoute.general")
