##################################################
Template.accountSettingsTemplate.onCreated () ->
	Meteor.subscribe "accountSettings"


Template.accountSettingsTemplate.helpers
	userData: () ->
		user = Meteor.users.findOne({_id: Meteor.userId()})
		return user if user?

##################################################