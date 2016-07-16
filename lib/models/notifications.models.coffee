##########################################
if Meteor.isServer
	syssrv.newNotification = (type, userId, data) ->
		switch type
			when 'new-user'
				title = "Bienvenido a PSP Connect"
				subject = "Gracias por registrarte a nuestra plataforma. esperamos que tengas una gran experiencia en ella."
			when 'time-registered'
				title = "Nuevo tiempo registrado"
				subject = 'Acabas de registrar un nuevo tiempo en el proyecto "' + data.title + "'."
			when "aqui"
				title = "nooo"

		data = {
			title: title
			subject: subject
			type: type
			notificationOwner: userId
		}

		db.notifications.insert(data)


##########################################


