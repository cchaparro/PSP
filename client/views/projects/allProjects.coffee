##########################################
Template.projectsTemplate.onCreated () ->
	Meteor.subscribe "allProjects"
	document.title = "PSP Connect"
	@hoveredProject = new ReactiveVar(false)

Template.projectsTemplate.helpers
	allProjects: () ->
		return db.projects.find({"projectOwner": Meteor.userId(), "parentId": {$exists: false}})

	isHovered: () ->
		return Template.instance().hoveredProject.get() == @_id

	amountProjects: () ->
		projects = db.projects.find({"projectOwner": Meteor.userId(), "parentId": {$exists: false}})
		return projects.count() != 0


Template.projectsTemplate.events
	'click .fa-times': (e,t) ->
		t.hoveredProject.set(@_id)
		$(".project-box").removeClass("project-box-hover")
		t.$(e.target).closest(".project-box").addClass("project-box-hover")

	'click .fa-arrow-left': (e,t) ->
		t.hoveredProject.set(false)
		$(".project-box").removeClass("project-box-hover")

	'click .confirm-delete': (e,t) ->
		Meteor.call "delete_project", @_id, true, (error) ->
			if error
				console.log "Error deleting a project (and his iterations)"
				console.warn(error)
			else
				sys.flashStatus("delete-project")

##########################################