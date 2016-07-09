#######################################
Meteor.methods
	createNotification: (type, uid) ->
		switch type
			when 'new-user'
				title = "Bienvenido a PSP Connect"
				subject = "Gracias por registrarte a nuestra plataforma. esperamos que tengas una gran experiencia en ella."
			when "aqui"
				title = "nooo"

		data = {
			title: title
			subject: subject
			type: type
			createdAt: new Date()
			notificationOwner: uid
		}

		db.notifications.insert(data)

#######################################