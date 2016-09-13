##########################################
if Meteor.isServer
	syssrv.newNotification = (type, userId, data) ->
		if data?.sender?
			sender = data.sender
		else
			sender = userId

		switch type
			when 'new-user'
				title = {
					sender: sender
					main: "bienvenido a la plataforma"
					secondary: "pspconnect.co"
				}
				subject = "Gracias por registrarte a nuestra plataforma. esperamos que tengas una gran experiencia en ella."

			when 'time-registered'
				title = {
					sender: sender
					main: "registró un nuevo tiempo en"
					secondary: data.title
				}

				extraData = {
					time: data.time
					stage: data.stage
					id: data.id
				}
				#Fueron registrados 18horas, 12 minutos, 29 segundos. Para modificar este dato de click aqui
				subject = 'Fueron registrados ' + sys.displayTime(data.time) + ". Para modificar este dato de click aqui."

			when "aqui"
				title = "nooo"

		data = {
			title: title
			subject: subject
			type: type
			notificationOwner: userId
		}

		if extraData?
			data["data"] = extraData

		db.notifications.insert(data)


##########################################


