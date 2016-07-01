##########################################
searchStatus = new ReactiveVar("all")
##########################################
Template.projectsTemplate.onCreated () ->
	Meteor.subscribe "allProjects"
	document.title = "PSP Connect"
	@hoveredProject = new ReactiveVar(false)

Template.projectsTemplate.helpers
	allProjects: () ->
		switch searchStatus.get()
			when "active"
				return db.projects.find({"projectOwner": Meteor.userId(), "completed": false, "parentId": {$exists: false}})
			when "finished"
				return db.projects.find({"projectOwner": Meteor.userId(), "completed": true, "parentId": {$exists: false}})
			when "all"
				return db.projects.find({"projectOwner": Meteor.userId(), "parentId": {$exists: false}})

	isHovered: () ->
		return Template.instance().hoveredProject.get() == @_id


Template.projectsTemplate.events
	'click .fa-times': (e,t) ->
		t.hoveredProject.set(@_id)
		$(".project-box").removeClass("project-box-hover")
		t.$(e.target).closest(".project-box").addClass("project-box-hover")

	'click .fa-arrow-left': (e,t) ->
		t.hoveredProject.set(false)
		$(".project-box").removeClass("project-box-hover")

	'click .confirm-delete': (e,t) ->
		Meteor.call "delete_project", @_id, (error) ->
			if error
				console.log "Error deleting a project"
				console.warn(error)
			else
				sys.flashSuccess()

##########################################
Template.allProjectsBar.helpers
	tabStatus: () ->
		return searchStatus.get()


Template.allProjectsBar.events
	'click .submenu-create': (e,t) ->
		#FlowRouter.setQueryParams({action: "alerts"});
		Modal.show('createProjectModal')

	'click .submenu-tab': (e,t) ->
		value = $(e.target).data('value')
		searchStatus.set(value)

##########################################