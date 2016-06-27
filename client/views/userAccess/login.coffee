##################################################
Template.loginTemplate.onCreated () ->
	@errorState = new ReactiveVar("default")
	document.title = "Inicio de Sesión"


Template.loginTemplate.helpers
	errorState: () ->
		return Template.instance().errorState.get()

	errorMessage: () ->
		switch Template.instance().errorState.get()
			when 'default'
				return " "
			when 'user'
				return "El correo ingresado no esta registrado"
			when 'email'
				return "Ingresaste un correo que no es valido"
			when 'password'
				return "La contraseña ingresada es incorrecta"


Template.loginTemplate.events
	'submit form': (e,t) ->
		e.preventDefault()

		email = $('#email').val()
		password = $('#password').val()

		if sys.isEmail(email) and (email!= '') and (password!= '')
			Meteor.loginWithPassword email, password, (error) ->
				if error
					if error.reason == "User not found"
						t.errorState.set("user")
						$('#email').val('')
						$('#password').val('')

					else if error.reason == "Incorrect password"
						t.errorState.set("password")
						$('#password').val('')

				else
					FlowRouter.go("/")

		if !sys.isEmail(email)
			t.errorState.set("email")
			$('#email').val('')
			$('#password').val('')


	'click .access-selection-box': (e,t) ->
		FlowRouter.go("/register")

##################################################