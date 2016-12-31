Template.iterationsViewTemplate.onCreated () ->
	@hoveredProject = new ReactiveVar(false)


Template.iterationsViewTemplate.helpers
	iterations: () ->
		projectParent = FlowRouter.getParam("fid")
		return db.projects.find({parentId: projectParent}, {sort: {createdAt: 1}})

	hoverIcon: () ->
		t = Template.instance()
		hoverStatus = t.hoveredProject.get()
		projectId = @_id

		if hoverStatus == projectId
			return 'arrow_back'
		else
			return 'clear'

	projectParent: () ->
		projectParent = FlowRouter.getParam("fid")
		return db.projects.findOne({_id: projectParent})

	isRegistering: () ->
		recordingProject = Session.get "statusTimeMessage"
		return true if @_id == recordingProject?.iterationId
		return false


Template.iterationsViewTemplate.events
	'click .project-delete': (e,t) ->
		Meteor.call "delete_project", @_id, (error) ->
			if error
				console.log "Error deleting a iteration of a project"
				console.warn(error)

	'click .clear': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		projectId = @_id

		t.hoveredProject.set(projectId)
		$(".project-box").removeClass("project-box-hover")
		t.$(e.target).closest(".project-box").addClass("project-box-hover")

	'click .arrow_back': (e,t) ->
		e.preventDefault()
		e.stopPropagation()

		t.hoveredProject.set(false)
		$(".project-box").removeClass("project-box-hover")

	'click .confirm-delete-project': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		projectId = @_id

		Meteor.call "delete_project", projectId, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("delete-iteration-error")
			else
				sys.flashStatus("delete-iteration-successful")
