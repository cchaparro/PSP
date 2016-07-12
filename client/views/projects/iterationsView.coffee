##########################################
Template.iterationsViewTemplate.onCreated () ->
	Meteor.subscribe "allProjects"


Template.iterationsViewTemplate.helpers
	selectedProject: () ->
		return db.projects.findOne({_id: FlowRouter.getParam("fid")})

	projectIterations: () ->
		return db.projects.find({parentId: FlowRouter.getParam("fid")}).fetch()


Template.iterationsViewTemplate.events
	'click .submenu-create': (e,t) ->
		data = {
			title: "Nueva iteración"
			description: "Descripción de esta nueva iteración"
			levelPSP: "PSP 0"
			parentId: FlowRouter.getParam("fid")
		}

		Meteor.call "create_project", data, (error) ->
			if error
				console.log "Error creating a new project iteration"
				console.warn(error)
			else
				sys.flashStatus("create-project")

##########################################
Template.projectIterationBox.onCreated () ->
	@hoveredIteration = new ReactiveVar(false)


Template.projectIterationBox.helpers
	isHovered: () ->
		return Template.instance().hoveredIteration.get() == @_id


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
				console.log "Error deleting a iteration"
				console.warn(error)
			else
				sys.flashStatus("delete-project")

##########################################