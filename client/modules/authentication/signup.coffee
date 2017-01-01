Template.registerTemplate.onCreated () ->
	@errorState = new ReactiveVar(false)


Template.registerTemplate.helpers
	errorState: () ->
		return Template.instance().errorState.get()

	errorMessage: () ->
		errorState = Template.instance().errorState.get()
		switch errorState
			when 'email_exist'
				return "El correo electrónico que ingresaste ya se encuentra registrado en la plataforma."
			when 'email'
				return "Ingresaste un correo electrónico que no es valido."
			when 'password'
				return "La contraseña ingresada debe tener al menos 6 caracteres."
			when 'missing-fields'
				return "Debes llenar todos los campos para completar el registro."
			else
				return false


Template.registerTemplate.events
	'keypress [name="firstName"], keypress [name="lastName"]': (e,t) ->
		if t.errorState.get() == 'missing-fields'
			t.errorState.set(false)

	'keypress [name="emailAddress"]': (e,t) ->
		if t.errorState.get()
			t.errorState.set(false)

	'keypress [name="password"]': (e,t) ->
		if t.errorState.get()
			t.errorState.set(false)

	'submit form': (e, t) ->
		e.preventDefault()
		# e.stopPropagation()

		email = t.$('[name="emailAddress"]').val()
		password = t.$('[name="password"]').val()
		firstName = t.$('[name="firstName"]').val()
		lastName = t.$('[name="lastName"]').val()

		data = {
			email: email
			service: 'email'
			password: password
			profile:
				fname: firstName
				lname: lastName
				profileImageUrl: null
				summaryAmount: Meteor.settings.public.userAmount
				sizeAmount: { base: 0, add: 0, modified: 0, deleted: 0, reused: 0 }
				total: { time: 0, injected: 0, removed: 0, size: 0 }
		}

		if sys.isEmail(email) and sys.isValidPassword(password)
			Accounts.createUser data, (error, result) ->
				if error
					if error.reason == "Email already exists."
						t.errorState.set("email_exist")
						t.$('[name="emailAddress"]').val('')
						t.$('[name="password"]').val('')
						t.$('[name="firstName"]').val('')
						t.$('[name="lastName"]').val('')
				else
					FlowRouter.go("privateRoute.general")

		else if !sys.isEmail(email) and email.length > 0
			t.errorState.set("email")
			t.$('[name="emailAddress"]').val('')
			t.$('[name="password"]').val('')
			t.$('[name="firstName"]').val('')
			t.$('[name="lastName"]').val('')

		else if password.length > 0 and !sys.isValidPassword(password)
			t.errorState.set("password")
			t.$('[name="password"]').val('')

		else
			t.$('[name="emailAddress"]').val('')
			t.$('[name="password"]').val('')
			t.$('[name="firstName"]').val('')
			t.$('[name="lastName"]').val('')
			t.errorState.set("missing-fields")
