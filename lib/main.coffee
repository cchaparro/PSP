if Meteor.isServer
	Meteor.startup () ->
		Accounts.loginServiceConfiguration.remove
			service: "facebook"

		Accounts.loginServiceConfiguration.insert
			service: "facebook",
			appId: Meteor.settings.private.oAuth.facebook.appId
			secret: Meteor.settings.private.oAuth.facebook.secret


		Accounts.loginServiceConfiguration.remove
			service: "google"

		Accounts.loginServiceConfiguration.insert
			service: "google",
			clientId: Meteor.settings.private.oAuth.google.clientId
			secret: Meteor.settings.private.oAuth.google.secret
