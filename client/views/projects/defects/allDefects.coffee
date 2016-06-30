##########################################
Template.defectsTemplate.helpers
	alluserDefects: () ->
		return db.defects.find({"defectOwner": Meteor.userId(), "projectId": FlowRouter.getParam("id")})

	amountDefects: () ->
		defects = db.defects.find({"defectOwner": Meteor.userId(), "projectId": FlowRouter.getParam("id")})
		console.log defects.count()
		return defects.count() != 0

Template.defectsTemplate.events
	'click .btn-create-defect': (e,t) ->
		Modal.show('createDefectModal')

	'click .defect-box': (e,t) ->
		data = @
		Modal.show('createDefectModal', data)

##########################################
Template.defectsBar.events
	'click .submenu-create': (e,t) ->
		Modal.show('createDefectModal')

##########################################