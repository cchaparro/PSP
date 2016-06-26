##################################################
Template.registerTemplate.onCreated () ->
	@errorState = new ReactiveVar("default")


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
				name: $('#name').val()
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
						$('#name').val('')
				else
					Meteor.call "create_defect_types", Meteor.userId(), (error)->
						if error
							console.log "Error creating Defect Types file in user registration"
							console.warn(error)

					FlowRouter.go("/")

		else if !sys.isEmail(email)
			t.errorState.set("email")
			$('#email').val('')
			$('#name').val('')

		else
			t.errorState.set("password")
			$('#password').val('')

	'click .access-selection-box': (e,t) ->
		FlowRouter.go("/login")

##################################################