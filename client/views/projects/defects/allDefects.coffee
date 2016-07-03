##########################################
Template.defectsTemplate.helpers
	alluserDefects: () ->
		return db.defects.find({"defectOwner": Meteor.userId(), "projectId": FlowRouter.getParam("id")})

	amountDefects: () ->
		defects = db.defects.find({"defectOwner": Meteor.userId(), "projectId": FlowRouter.getParam("id")})
		return defects.count() != 0

	defectDescription: () ->
		return sys.cutText(@description, 75, " ...")

Template.defectsTemplate.events
	'click .btn-create-defect': (e,t) ->
		Modal.show('createDefectModal')

	'click .defect-content': (e,t) ->
		data = @
		Modal.show('createDefectModal', data)

	'click .defect-delete': (e,t) ->
		console.log @
		Meteor.call "delete_defect", @_id, (error) ->
			if error
				console.log "Error deleting a defect"
			else
				sys.flashSuccess()

##########################################
Template.defectsBar.events
	'click .submenu-create': (e,t) ->
		Modal.show('createDefectModal')

##########################################