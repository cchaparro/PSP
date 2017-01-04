elementActive = (route) ->
	FlowRouter.watchPathChange()
	currentRoute = FlowRouter.current().route.name
	return route is currentRoute

closePopups = () ->
	Session.set 'project-sort-dropdown', false
	Session.set 'main-avatar-dropdown', false
	Session.set 'main-notification-dropdown', false
	return

projectViewAction = (route) ->
	closePopups()
	iterationId = FlowRouter.getParam("fid")
	projectId = FlowRouter.getParam("id")

	return FlowRouter.go(route, {
		fid: iterationId
		id: projectId
	})

projectViewActive = () ->
	if elementActive('privateRoute.general')
		return true

	FlowRouter.watchPathChange()
	currentRoute = FlowRouter.current().route.name
	projectViews = ['privateRoute.iterations', 'privateRoute.projectGeneral', 'privateRoute.summary', 'privateRoute.timeLog', 'privateRoute.defectLog', 'privateRoute.estimating', 'privateRoute.pqi', 'privateRoute.scripts']
	return _.contains projectViews, currentRoute


Template.masterLayout.onCreated () ->
	closePopups()


Template.masterLayout.helpers
	documentTitle: () ->
		if Session.get("route")
			route = sys.getSessionRoute(Session.get("route"))

		if Session.get("statusTimeMessage")
			document.title = "(Registrando) #{route}"
		else
			document.title = route
		return ""

	navbarElements: () ->
		avatarDropdownState = Session.get 'main-avatar-dropdown'
		notificationsDropdownState = Session.get 'main-notification-dropdown'
		return [
				icon: 'folder'
				title: 'Proyectos'
				route: 'privateRoute.general'
				active: () ->
					return projectViewActive()
				action: () ->
					closePopups()
					return FlowRouter.go(@route)
			,
				icon: 'assessment'
				title: 'Resumen'
				route: 'privateRoute.overview'
				active: () ->
					return elementActive('privateRoute.overview')
				action: () ->
					closePopups()
					return FlowRouter.go(@route)
			,
				icon: 'settings_applications'
				title: 'Configuración'
				route: 'privateRoute.settings'
				active: () ->
					return elementActive('privateRoute.settings')
				action: () ->
					closePopups()
					return FlowRouter.go(@route)
			,
				icon: 'help'
				title: 'Ayuda'
				route: 'privateRoute.help'
				active: () ->
					return elementActive('privateRoute.help')
				action: () ->
					closePopups()
					return FlowRouter.go(@route)
			,
				icon: 'notifications'
				title: 'Notificaciones'
				template: 'notificationsDropdown'
				active: () ->
					return notificationsDropdownState
				action: () ->
					Meteor.call "notificationsSeen"
					Session.set 'main-avatar-dropdown', false
					return Session.set 'main-notification-dropdown', false if notificationsDropdownState
					return Session.set 'main-notification-dropdown', true
			,
				icon: 'account_circle'
				title: 'Perfil'
				template: 'mainAvatarDropdown'
				active: () ->
					return avatarDropdownState
				action: () ->
					Session.set 'main-notification-dropdown', false
					return Session.set 'main-avatar-dropdown', false if avatarDropdownState
					return Session.set 'main-avatar-dropdown', true
		]

	projectElements: () ->
		return [
				icon: 'folder_open'
				title: 'Resumen'
				route: 'privateRoute.projectGeneral'
				active: () ->
					return elementActive('privateRoute.projectGeneral')
				action: () ->
					projectViewAction(@route)
			,
				icon: 'assessment'
				title: 'Plan Summary'
				route: 'privateRoute.summary'
				active: () ->
					return elementActive('privateRoute.summary')
				action: () ->
					projectViewAction(@route)
			,
				icon: 'access_time'
				title: 'Registro tiempos'
				route: 'privateRoute.timeLog'
				active: () ->
					return elementActive('privateRoute.timeLog')
				action: () ->
					projectViewAction(@route)
			,
				icon: 'bug_report'
				title: 'Registro defectos'
				route: 'privateRoute.defectLog'
				active: () ->
					return elementActive('privateRoute.defectLog')
				action: () ->
					projectViewAction(@route)
			,
				icon: 'timer'
				title: 'Estimación'
				route: 'privateRoute.estimating'
				active: () ->
					return elementActive('privateRoute.estimating')
				action: () ->
					projectViewAction(@route)
				hide: () ->
					projectId = FlowRouter.getParam("id")
					if projectId
						project = db.projects.findOne({_id: projectId})
						return project?.levelPSP == "PSP 0"
					return true
			,
				icon: 'show_chart'
				title: 'Graficos PQI'
				route: 'privateRoute.pqi'
				active: () ->
					return elementActive('privateRoute.pqi')
				action: () ->
					projectViewAction(@route)
				hide: () ->
					projectId = FlowRouter.getParam("id")
					if projectId
						project = db.projects.findOne({_id: projectId})
						return project?.levelPSP != "PSP 2"
					return true
			,
				icon: 'rate_review'
				title: 'Formularios'
				route: 'privateRoute.forms'
				active: () ->
					return elementActive('privateRoute.forms')
				action: () ->
					projectViewAction(@route)
				hide: () ->
					projectId = FlowRouter.getParam("id")

					if projectId
						planSummary = db.plan_summary.findOne({projectId: projectId})
						projectStages = _.filter planSummary?.timeEstimated, (stage) ->
							unless stage.finished
								return stage
						currentPos = _.first(projectStages)?.name

						return true if currentPos != "Postmortem"
						return true if db.projects.findOne({_id: projectId})?.levelPSP == "PSP 0"
					return false
			,
				icon: 'description'
				title: 'Scripts'
				route: 'privateRoute.scripts'
				active: () ->
					return elementActive('privateRoute.scripts')
				action: () ->
					projectViewAction(@route)
		]

	inProjectView: () ->
		projectParent = FlowRouter.getParam("id")
		return true if projectParent
		return false


Template.masterLayout.events
	'click': (e,t) ->
		$this = $(e.target)
		checkItem = (item, search) ->
			return item.is(search) or item.parents(search).is(search)

		if checkItem($this, ".main-wrapper")
			Session.set "main-avatar-dropdown", false
			Session.set "main-notification-dropdown", false

			unless checkItem($this, ".options")
				Session.set "project-sort-dropdown", false

		if checkItem($this, ".navbar-wrapper")
			unless checkItem($this, ".main-avatar-dropdown")
				Session.set "main-avatar-dropdown", false
				Session.set "project-sort-dropdown", false

			unless checkItem($this, ".notification-box")
				Session.set "main-notification-dropdown", false
				Session.set "project-sort-dropdown", false

	'click .close-status': (e,t) ->
		e.stopPropagation()
		e.preventDefault()

		$(e.target).closest('.status-message').animate { opacity: 0 }, 200, ->
			Session.set "statusMessage", false
