Template.createContactModal.onCreated () ->
	@hasError = new ReactiveVar({name: false, email: false, subject: false, message: false})


Template.createContactModal.helpers
	nameError: () ->
		t = Template.instance()
		error = t.hasError.get()
		return error.name

	emailError: () ->
		t = Template.instance()
		error = t.hasError.get()
		return error.email

	subjectError: () ->
		t = Template.instance()
		error = t.hasError.get()
		return error.subject

	messageError: () ->
		t = Template.instance()
		error = t.hasError.get()
		return error.message


Template.createContactModal.events
	'keypress .contact-name': (e,t) ->
		name = t.$(e.target).val()
		error = t.hasError.get()
		unless name
			error.name = false
		t.hasError.set(error)

	'keypress .contact-email': (e,t) ->
		email = t.$(e.target).val()
		error = t.hasError.get()
		unless email
			error.email = false
		t.hasError.set(error)

	'keypress .contact-subject': (e,t) ->
		subject = t.$(e.target).val()
		error = t.hasError.get()
		unless subject
			error.subject = false
		t.hasError.set(error)

	'keypress .contact-message': (e,t) ->
		message = t.$(e.target).val()
		error = t.hasError.get()
		unless message
			error.message = false
		t.hasError.set(error)

	'click .contact-create': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		error = t.hasError.get()

		name = t.$('.contact-name').val()
		email = t.$('.contact-email').val()
		subject = t.$('.contact-subject').val()
		message = t.$('.contact-message').val()

		unless name
			error.name = true
		unless email
			error.email = true
		unless subject
			error.subject = true
		unless message
			error.message = true

		t.hasError.set(error)

		unless error.name or error.email or error.subject or error.message
			data = {
				to: "juanpmd@hotmail.com",
				from: email,
				subject: subject,
				text: message,
			}

			Meteor.call "send_email", data, (error) ->
				if error
					sys.flashStatus('create-contact-error')
				else
					sys.flashStatus('create-contact-successful')

			Modal.hide('createContactModal')
