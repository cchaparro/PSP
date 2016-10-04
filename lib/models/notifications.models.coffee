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

			when 'password-reset'
				title = {
					sender: sender
					main: "Has cambiado tu contraseña de"
					secondary: "pspconnect.co"
				}
				subject = "Realizaste un cambio en la contraseña utilizada para iniciar sesión."

			when 'question-response'
				title = {
					sender: sender
					main: "respondió a tu pregunta"
					secondary: sys.cutText(data.title, 30, " ...")
				}

				extraData = {
					questionId: data.questionId
				}
				subject = "#{data.senderName} respondio a la pregunta que publicaste."

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


		data = {
			title: title
			subject: subject
			type: type
			notificationOwner: userId
		}

		if extraData?
			data["data"] = extraData

		db.notifications.insert(data)

	# This is used to disable all the time notfications of a completed project, this means that the user should not be able to edit the time of a project that was already computed.
	syssrv.disableTimeNotifications = (summaryId) ->
		db.notifications.update({ "data.id": summaryId }, {$set: {"data.disabled": true}}, {multi:true})


##########################################


