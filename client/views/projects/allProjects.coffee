##########################################
Template.projectsTemplate.onCreated () ->
	@hoveredProject = new ReactiveVar(false)

Template.projectsTemplate.helpers
	allProjects: () ->
		return db.projects.find({"projectOwner": Meteor.userId(), "parentId": {$exists: false}})

	isHovered: () ->
		return Template.instance().hoveredProject.get() == @_id

	amountProjects: () ->
		projects = db.projects.find({"projectOwner": Meteor.userId(), "parentId": {$exists: false}})
		return projects.count() != 0

	projectCompleted: () ->
		return false if !@completed
		iterations = db.projects.find({"parentId": @_id, "completed": false}).fetch().length
		return false if iterations > 0
		return true


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