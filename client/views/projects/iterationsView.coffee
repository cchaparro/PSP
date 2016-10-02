##########################################
Template.iterationsViewTemplate.helpers
	selectedProject: () ->
		return db.projects.findOne({_id: FlowRouter.getParam("fid")})

	projectIterations: () ->
		return db.projects.find({parentId: FlowRouter.getParam("fid")}, {sort: {createdAt: 1}}).fetch()

	isRegistering: () ->
		recordingProject = Session.get "statusTimeMessage"
		return true if @_id == recordingProject?.iterationId
		return false


Template.iterationsViewTemplate.events
	'click .create-iteration': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		currentProject = db.projects.findOne({ _id: FlowRouter.getParam("fid") })

		# The currentProject takes the parent projects levelPSP and gives it to the new interation
		data = {
			title: "Nueva iteración"
			description: "Descripción de esta nueva iteración"
			levelPSP: currentProject.levelPSP
			parentId: FlowRouter.getParam("fid")
		}

		Meteor.call "create_project", data, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("error-create-iteration")
			else
				sys.flashStatus("create-iteration")

##########################################
Template.projectIterationBox.onCreated () ->
	@hoveredIteration = new ReactiveVar(false)


Template.projectIterationBox.helpers
	isHovered: () ->
		return Template.instance().hoveredIteration.get() == @_id

	isRegistering: () ->
		recordingProject = Session.get "statusTimeMessage"
		return true if @_id == recordingProject?.iterationId
		return false


Template.projectIterationBox.events
	'click .project-delete': (e,t) ->
		Meteor.call "delete_project", @_id, (error) ->
			if error
				console.log "Error deleting a iteration of a project"
				console.warn(error)

	'click .fa-times': (e,t) ->
		t.hoveredIteration.set(@_id)
		$(".iteration-box").removeClass("iteration-box-hover")
		t.$(e.target).closest(".iteration-box").addClass("iteration-box-hover")

	'click .fa-arrow-left': (e,t) ->
		t.hoveredIteration.set(false)
		$(".iteration-box").removeClass("iteration-box-hover")

	'click .confirm-delete': (e,t) ->
		Meteor.call "delete_project", @_id, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("error-iteration-delete")
			else
				sys.flashStatus("iteration-delete")

##########################################