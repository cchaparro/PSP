Template.projectsTemplate.onCreated () ->
	@subscribe 'sortView'
	@hoveredProject = new ReactiveVar(false)


Template.projectsTemplate.helpers
	projects: () ->
		user = Meteor.user()
		userId = Meteor.userId()

		switch user?.settings?.projectSort
			when "date"
				return db.projects.find({projectOwner: userId, parentId: null}, {sort: {createdAt: 1}})
			when "title"
				return db.projects.find({projectOwner: userId, parentId: null}, {sort: {title: 1}})
			when "color"
				return db.projects.find({projectOwner: userId, parentId: null}, {sort: {color: 1}})

	hoverIcon: () ->
		t = Template.instance()
		hoverStatus = t.hoveredProject.get()
		projectId = @_id

		if hoverStatus == projectId
			return 'arrow_back'
		else
			return 'clear'

	amountProjects: () ->
		userId = Meteor.userId()
		projects = db.projects.find({projectOwner: userId, parentId: null})
		return projects.count() != 0

	projectCompleted: () ->
		return false if !@completed
		iterations = db.projects.find({parentId: @_id, completed: false}).count()
		return false if iterations > 0
		return true

	isRegistering: () ->
		recordingProject = Session.get "statusTimeMessage"
		return true if @_id == recordingProject?.projectId
		return true if @parentId? and @parentId == recordingProject?.projectId
		return false


Template.projectsTemplate.events
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

		Meteor.call "delete_project", projectId, true, (error) ->
			if error
				console.warn(error)
				sys.flashStatus('delete-project-error')
			else
				sys.flashStatus('delete-project-successful')
