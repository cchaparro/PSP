##########################################
searchStatus = new ReactiveVar("all")
##########################################
Template.projectsTemplate.onCreated () ->
	Meteor.subscribe "allProjects"

Template.projectsTemplate.helpers
	allProjects: () ->
		switch searchStatus.get()
			when "active"
				return db.projects.find({"projectOwner": Meteor.userId(), "completed": false, "parentId": {$exists: false}})
			when "finished"
				return db.projects.find({"projectOwner": Meteor.userId(), "completed": true, "parentId": {$exists: false}})
			when "all"
				return db.projects.find({"projectOwner": Meteor.userId(), "parentId": {$exists: false}})


Template.projectsTemplate.events
	'click .project-delete': (e,t) ->
		Meteor.call "delete_project", @_id, (error) ->
			if error
				console.log "Error deleting a project"
			else
				#sys.flashSuccess()

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