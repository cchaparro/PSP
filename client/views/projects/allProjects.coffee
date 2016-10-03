##########################################
Template.projectsTemplate.onCreated () ->
	@hoveredProject = new ReactiveVar(false)

Template.projectsTemplate.helpers
	allProjects: () ->
		user = db.users.findOne({_id: Meteor.userId()})
		switch user?.settings?.projectSort
			when "date"
				return db.projects.find({"projectOwner": Meteor.userId(), "parentId": null}, {sort: {createdAt: 1}})
			when "title"
				return db.projects.find({"projectOwner": Meteor.userId(), "parentId": null}, {sort: {title: 1}})
			when "color"
				return db.projects.find({"projectOwner": Meteor.userId(), "parentId": null}, {sort: {color: 1}})

	isHovered: () ->
		return Template.instance().hoveredProject.get() == @_id

	amountProjects: () ->
		projects = db.projects.find({"projectOwner": Meteor.userId(), "parentId": null})
		return projects.count() != 0

	projectCompleted: () ->
		return false if !@completed
		iterations = db.projects.find({"parentId": @_id, "completed": false}).fetch().length
		return false if iterations > 0
		return true

	isRegistering: () ->
		recordingProject = Session.get "statusTimeMessage"
		return true if @_id == recordingProject?.projectId
		return true if @parentId? and @parentId == recordingProject?.projectId
		return false


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
				console.warn(error)
				sys.flashStatus("error-project-delete")
			else
				sys.flashStatus("project-delete")

##########################################