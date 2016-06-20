##################################################
Template.registerTemplate.events
	'submit form': (e,t) ->
		e.preventDefault()

		email = $('#email').val()
		password = $('#password1').val()
		password_confirm = $('#password2').val()

		data = {
			email: email
			password: password
			profile:
				fname: $('#fname').val()
				lname: $('#lname').val()
				profileImageUrl: null
		}

		if sys.isEmail(email) and sys.isValidPassword(password) and (password == password_confirm)
			Accounts.createUser data, (error) ->
				if error
					if error.reason == "Email already exists."
						$('#email').val('')
						$('#password1').val('')
						$('#password2').val('')
						$('#fname').val('')
						$('#lname').val('')
				else
					Meteor.call "create_defect_types", Meteor.userId(), (err)->
						if err
							console.log "Error creating Defect Types file: " + err
					FlowRouter.go("/")

		else if !sys.isEmail(email)
			$('#email').val('')
			$('#password1').val('')
			$('#fname').val('')
			$('#lname').val('')
			$('#password2').val('')

		else
			$('#password1').val('')
			$('#password2').val('')

	'click .access-selection-box': (e,t) ->
		FlowRouter.go("/login")

##################################################