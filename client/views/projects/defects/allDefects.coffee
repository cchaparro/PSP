##########################################
Template.defectsTemplate.onCreated () ->
	Meteor.subscribe "projectView", FlowRouter.getParam("id")
	document.title = "Defects Log"
	@hoveredDefect = new ReactiveVar(false)


Template.defectsTemplate.helpers
	alluserDefects: () ->
		return db.defects.find({"defectOwner": Meteor.userId(), "projectId": FlowRouter.getParam("id"), "created": {$not: false}})

	amountDefects: () ->
		defects = db.defects.find({"defectOwner": Meteor.userId(), "projectId": FlowRouter.getParam("id"), "created": {$not: false}})
		return defects.count() != 0

	defectDescription: () ->
		return sys.cutText(@description, 75, " ...") or "" if @description

	isHovered: () ->
		return Template.instance().hoveredDefect.get() == @_id

Template.defectsTemplate.events
	'click .btn-create-defect': (e,t) ->
		Modal.show('createDefectModal')

	'click .defect-content': (e,t) ->
		data = @
		Modal.show('createDefectModal', data)

	'click .fa-times': (e,t) ->
		t.hoveredDefect.set(@_id)
		$(".defect-box").removeClass("defect-box-hover")
		t.$(e.target).closest(".defect-box").addClass("defect-box-hover")

	'click .fa-arrow-left': (e,t) ->
		t.hoveredDefect.set(false)
		$(".defect-box").removeClass("defect-box-hover")

	'click .confirm-delete': (e,t) ->
		Meteor.call "delete_defect", @_id, FlowRouter.getParam("id"), (error) ->
			if error
				console.log "Error deleting a defect"
			else
				sys.flashStatus("delete-defect")

##########################################
Template.defectsBar.events
	'click .submenu-create': (e,t) ->
		Modal.show('createDefectModal')

##########################################