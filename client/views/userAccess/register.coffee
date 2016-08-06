##################################################
Template.registerTemplate.onCreated () ->
	@errorState = new ReactiveVar("default")
	document.title = "Registro"


Template.registerTemplate.helpers
	errorState: () ->
		return Template.instance().errorState.get()

	errorMessage: () ->
		switch Template.instance().errorState.get()
			when 'default'
				return " "
			when 'email_exist'
				return "El correo ya esta registrado"
			when 'email'
				return "Ingresaste un correo que no es valido"
			when 'password'
				return "La contraseña ingresada no cumple con los requisitos"


Template.registerTemplate.events
	'submit form': (e,t) ->
		e.preventDefault()

		email = $('#email').val()
		password = $('#password').val()

		data = {
			email: email
			password: password
			profile:
				fname: $('#fname').val()
				lname: $('#lname').val()
				profileImageUrl: null
				summaryAmount: Meteor.settings.public.userAmount
				total:
					time: 0
					injected: 0
					removed: 0
		}

		if sys.isEmail(email) and sys.isValidPassword(password)
			Accounts.createUser data, (error, result) ->
				if error
					if error.reason == "Email already exists."
						t.errorState.set("email_exist")
						$('#email').val('')
						$('#password').val('')
						$('#fname').val('')
						$('#lname').val('')
				else
					FlowRouter.go("/")

		else if !sys.isEmail(email)
			t.errorState.set("email")
			$('#email').val('')
			$('#fname').val('')
			$('#lname').val('')

		else
			t.errorState.set("password")
			$('#password').val('')

	'click .access-selection-box': (e,t) ->
		FlowRouter.go("/login")

##################################################