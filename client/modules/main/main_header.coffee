Template.mainHeader.helpers
	headerActions: () ->
		FlowRouter.watchPathChange()
		currentRoute = FlowRouter.current().route.name

		switch currentRoute
			when 'privateRoute.general'
				return 'createProjectAction'
			when 'privateRoute.iterations'
				return 'createIterationAction'
			else
				return ''


Template.mainHeader.events
	'click .sort-option': (e,t) ->
		e.preventDefault()
		e.stopPropagation()

		currentState = Session.get 'project-sort-dropdown'
		Session.set 'project-sort-dropdown', !currentState


Template.mainAvatarDropdown.events
	'click .account-edit': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		Session.set 'main-avatar-dropdown', false
		Modal.show('editProfileModal')

	'click .account-logout': (e,t) ->
		e.preventDefault()
		e.stopPropagation()

		Meteor.logout () ->
			FlowRouter.go('publicRoute.login')


Template.createProjectAction.events
	'click .create-project': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		Modal.show('createProjectModal')


Template.projectSortDropdown.helpers
	sortElements: () ->
		userSort = Meteor.user()?.settings?.projectSort
		return [
			title: 'Por titulo'
			element: 'title'
			active: () ->
				return userSort is 'title'
		,
			title: 'Por fecha de creación'
			element: 'date'
			active: () ->
				return userSort is 'date'
		,
			title: 'Por color'
			element: 'color'
			active: () ->
				return userSort is 'color'
		]


Template.projectSortDropdown.events
	'click .project-sort-option': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		selected = @element

		Meteor.call "change_project_sorting_settings", selected, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("change-project-sorting-error")
			else
				sys.flashStatus("change-project-sorting-successful")


Template.createIterationAction.events
	'click .create-iteration': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		projectParent = FlowRouter.getParam("fid")
		currentProject = db.projects.findOne({ _id: projectParent})

		# The currentProject takes the parent projects levelPSP and gives it to the new interation
		data = {
			title: "Nueva iteración"
			description: "Este proyecto aun no tiene asignado una descripción general sobre el mismo."
			levelPSP: currentProject.levelPSP
			parentId: projectParent
		}

		Meteor.call "create_project", data, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("create-iteration-error")
			else
				sys.flashStatus("create-iteration-successful")
