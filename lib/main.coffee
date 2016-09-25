if Meteor.isServer
	Meteor.startup () ->
		# This is used for the testing performance of kadira
		Kadira.connect(Meteor.settings.private.kadira.appId, Meteor.settings.private.kadira.appSecret)

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
