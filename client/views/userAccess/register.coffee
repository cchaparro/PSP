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
			when 'missing-fields'
				return "Debes llenar los campos para terminar el registro"

		return "\xa0"


Template.registerTemplate.events
	'keypress #fname, keypress #lname': (e,t) ->
		if t.errorState.get() == 'missing-fields'
			t.errorState.set(false)

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
				email: email
				service: "email"
				fname: $('#fname').val()
				lname: $('#lname').val()
				profileImageUrl: null
				summaryAmount: Meteor.settings.public.userAmount
				sizeAmount:
					base: 0
					add: 0
					modified: 0
					deleted: 0
					reused: 0
				total:
					time: 0
					injected: 0
					removed: 0
					size: 0
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
					FlowRouter.go('privateRoute.general')

		else if !sys.isEmail(email) and email.length > 0
			t.errorState.set("email")
			$('#email').val('')
			$('#fname').val('')
			$('#lname').val('')
			$('#password').val('')

		else if password.length > 0 and !sys.isValidPassword(password)
			t.errorState.set("password")
			$('#password').val('')

		else
			$('#fname').val('')
			$('#lname').val('')
			$('#email').val('')
			$('#password').val('')
			t.errorState.set("missing-fields")

	'click .access-selection-box': (e,t) ->
		FlowRouter.go('publicRoute.login')

##################################################