#######################################
Meteor.methods
	createNotification: (type, uid) ->
		switch type
			when 'new-user'
				title = "Bienvenido a PSP Connect"
				subject = "Gracias por registrarte a nuestra plataforma. esperamos que tengas una gran experiencia en ella."
			when 'time-registered'
				title = "Nuevo timepo registrado"
				subject = "Acabas de registrar un nuevo tiempo en el proyecto"
			when "aqui"
				title = "nooo"

		data = {
			title: title
			subject: subject
			type: type
			notificationOwner: uid
		}

		db.notifications.insert(data)

	notificationsSeen: () ->
		db.notifications.update({"notificationOwner": Meteor.userId(), "seen": false}, {$set: {"seen": true}}, {multi:true})

	notificationClicked: (notificationId) ->
		db.notifications.update({_id: notificationId, "notificationOwner": Meteor.userId(), "clicked": false}, {$set: {"seen": true, "clicked": true}})

#######################################