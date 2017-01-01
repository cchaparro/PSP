Template.defectsTemplate.onCreated () ->
	@hoveredDefect = new ReactiveVar(false)


Template.defectsTemplate.helpers
	defects: () ->
		projectId = FlowRouter.getParam("id")
		return db.defects.find({defectOwner: Meteor.userId(), projectId: projectId, created: {$not: false}})

	hoverIcon: () ->
		t = Template.instance()
		hoverStatus = t.hoveredDefect.get()
		defectId = @_id

		if hoverStatus == defectId
			return 'arrow_back'
		else
			return 'clear'

	amountDefects: () ->
		defects = db.defects.find({"defectOwner": Meteor.userId(), "projectId": FlowRouter.getParam("id"), "created": {$not: false}})
		return defects.count() != 0

	defectDescription: () ->
		return sys.cutText(@description, 70, " ...") or "" if @description

	projectColor: () ->
		return db.projects.findOne({_id: FlowRouter.getParam("id")})?.color


Template.defectsTemplate.events
	'click .defect-content': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		data = @
		Modal.show('createDefectModal', data)

	'click .clear': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		defectId = @_id

		t.hoveredDefect.set(defectId)
		$(".project-box").removeClass("project-box-hover")
		t.$(e.target).closest(".project-box").addClass("project-box-hover")

	'click .arrow_back': (e,t) ->
		e.preventDefault()
		e.stopPropagation()

		t.hoveredDefect.set(false)
		$(".project-box").removeClass("project-box-hover")

	'click .confirm-delete-project': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		defectId = @_id
		projectId = FlowRouter.getParam("id")

		Meteor.call "delete_defect", defectId, projectId, (error) ->
			if error
				sys.flashStatus("delete-defect-error")
			else
				sys.flashStatus("delete-defect-successful")
