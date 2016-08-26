##################################################
Template.registerTemplate.onCreated () ->
	@errorState = new ReactiveVar(false)
	document.title = "Registro"


Template.registerTemplate.helpers
	errorState: () ->
		return Template.instance().errorState.get()

	errorMessage: () ->
		switch Template.instance().errorState.get()
			when 'email_exist'
				return "El correo ya esta registrado"
			when 'email'
				return "Ingresaste un correo que no es valido"
			when 'password'
				return "La contraseña ingresada no cumple con los requisitos"

		return "\xa0"


Template.registerTemplate.events
	'keypress #email': (e,t) ->
		if t.errorState.get()
			t.errorState.set(false)

	'keypress #password': (e,t) ->
		if t.errorState.get()
			t.errorState.set(false)

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
					FlowRouter.go("/projects")

		else if !sys.isEmail(email)
			t.errorState.set("email")
			$('#email').val('')
			$('#fname').val('')
			$('#lname').val('')
			$('#password').val('')

		else
			t.errorState.set("password")
			$('#password').val('')

	'click .access-selection-box': (e,t) ->
		FlowRouter.go("/")

##################################################