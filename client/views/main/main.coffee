##################################################
# Template.masterLayout.onRendered ()->
# 	instance = Template.instance()

# 	instance.autorun ()->
# 		action = FlowRouter.getQueryParam('action')
# 		if action == 'alerts'
# 			Modal.show('createProjectModal')
# 			#FlowRouter.setQueryParams action: null

Template.masterLayout.onCreated ->
	unless Meteor.userId()
		FlowRouter.go("/login")

##########################################
Template.statusMessage.helpers
	statusMessage: () ->
		msg = Session.get "statusMessage"
		if msg
			return msg
		return false

##########################################
Template.statusTimeMessage.helpers
	timeMessage: () ->
		msg = Session.get "statusTimeMessage"
		if msg
			return msg
		return false

##########################################