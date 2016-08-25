if Meteor.isServer
	Meteor.startup () ->
		Accounts.loginServiceConfiguration.remove
			service: "facebook"

		Accounts.loginServiceConfiguration.insert
			service: "facebook",
			appId: Meteor.settings.private.oAuth.facebook.appId,
			secret: Meteor.settings.private.oAuth.facebook.secret
