if Meteor.isServer
	Meteor.startup () ->
		# This code runs when meteor starts and what it does is render the facebook and google logins
		Accounts.loginServiceConfiguration.remove
			service: "facebook"

		Accounts.loginServiceConfiguration.remove
			service: "google"

		Accounts.loginServiceConfiguration.insert
			service: "facebook",
			appId: Meteor.settings.private.oAuth.facebook.appId
			secret: Meteor.settings.private.oAuth.facebook.secret

		Accounts.loginServiceConfiguration.insert
			service: "google",
			clientId: Meteor.settings.private.oAuth.google.clientId
			secret: Meteor.settings.private.oAuth.google.secret

		# Configuration of the mailgun provider
		mailLogin = Meteor.settings.private.mail.login
		mailPassword = Meteor.settings.private.mail.password
		process.env.MAIL_URL = "smtp://#{mailLogin}:#{mailPassword}@smtp.mailgun.org:587"


		# This is used to change the message for the resetPassword email. This gives a different url from the default
		Accounts.emailTemplates.resetPassword.subject = (user) ->
			return "Restablecer contraseña pspconnect"

		Accounts.emailTemplates.resetPassword.text = (user, url) ->
			token = url.substring(url.lastIndexOf('/') + 1, url.length)
			newUrl = Meteor.absoluteUrl('reset-password/' + token)
			text = "Hola #{user.profile.fname} #{user.profile.lname}, \n"
			text+= 'Dale click al siguiente link para configurar la contraseña de su cuenta pspconnect \n'
			text+= newUrl
			return text
