elementActive = (route) ->
	FlowRouter.watchPathChange()
	currentRoute = FlowRouter.current().route.name

	return false if Session.get 'main-avatar-dropdown'
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
					return elementActive('privateRoute.general')
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
				active: () ->
					return notificationsDropdownState
				action: () ->
					return true
			,
				icon: 'account_circle'
				title: 'Perfil'
				template: 'mainAvatarDropdown'
				active: () ->
					return avatarDropdownState
				action: () ->
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
			,
				icon: 'show_chart'
				title: 'Graficos PQI'
				route: 'privateRoute.pqi'
				active: () ->
					return elementActive('privateRoute.pqi')
				action: () ->
					projectViewAction(@route)
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

			unless checkItem($this, ".options")
				Session.set "project-sort-dropdown", false

		if checkItem($this, ".navbar-wrapper")
			unless checkItem($this, ".main-avatar-dropdown")
				Session.set "main-avatar-dropdown", false
				Session.set "project-sort-dropdown", false

	'click .close-status': (e,t) ->
		e.stopPropagation()
		e.preventDefault()

		$(e.target).closest('.status-message').animate { opacity: 0 }, 200, ->
			Session.set "statusMessage", false

	# 	if checkItem($this, ".master-content")
	# 		Session.set("display-notification-box", false)
	# 		Session.set("display-user-box", false)
	# 		unless checkItem($this, ".navigation-option")
	# 			Session.set("navigation-menu", false)

	# 	if checkItem($this, ".main-menu-content")
	# 		unless checkItem($this, ".notification") or checkItem($this, ".notification-box")
	# 			Session.set("display-notification-box", false)
	# 		unless checkItem($this, ".avatar-box")
	# 			Session.set("display-user-box", false)

	# 		Session.set("navigation-menu", false)

	# 	if checkItem($this, ".main-menu-user")
	# 		unless checkItem($this, ".notification") or checkItem($this, ".notification-box")
	# 			Session.set("display-notification-box", false)
	# 		unless checkItem($this, ".avatar-box")
	# 			Session.set("display-user-box", false)

