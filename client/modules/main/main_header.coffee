Template.mainHeader.helpers
	headerActions: () ->
		FlowRouter.watchPathChange()
		currentRoute = FlowRouter.current().route.name

		switch currentRoute
			when 'privateRoute.general'
				return 'createProjectAction'
			when 'privateRoute.iterations'
				return 'createIterationAction'
			when 'privateRoute.community'
				return 'createCommunityQuestionAction'
			when 'privateRoute.defectLog'
				return 'createDefectAction'
			when 'privateRoute.settings'
				return 'createDefectTypeAction'
			else
				return ''


	# TODO - Organize this
	navigationState: () ->
		FlowRouter.watchPathChange()
		currentState = FlowRouter.current().route.name

		if currentState == "privateRoute.general"
			displayMenu = true
		else
			displayMenu = false

		if currentState == "privateRoute.general" or currentState=='privateRoute.iterations' or currentState=="privateRoute.projectGeneral" or currentState=="privateRoute.timeLog" or currentState=="privateRoute.defectLog" or currentState=="privateRoute.summary" or currentState=="privateRoute.scripts" or currentState=="privateRoute.estimating" or currentState=="privateRoute.forms"
			initialRoute = "privateRoute.general"
		else if currentState == "privateRoute.community" or currentState == "privateRoute.communityQuestion" or currentState == "privateRoute.tutorial"
			initialRoute = "privateRoute.help"
		else
			initialRoute = currentState

		Routes = [{
			title: sys.getPageName(initialRoute)
			route: initialRoute
			fid: false
			pid: false
			question: false
			lastValue: false
			displayMenu: displayMenu
		}]

		if FlowRouter.getParam("fid")
			Routes.push({
				title: "Iteraciones"
				route: "privateRoute.iterations"
				fid: FlowRouter.getParam("fid")
				pid: false
				question: false
				lastValue: false
				displayMenu: false
			})

		if FlowRouter.getParam("id")
			Project = db.projects.findOne({_id: FlowRouter.getParam("id"), "projectOwner": Meteor.userId()})

			if Project
				Routes.push({
					title: Project.title
					route: "privateRoute.projectGeneral"
					fid: FlowRouter.getParam("fid")
					pid: FlowRouter.getParam("id")
					lastValue: false
					displayMenu: false
				})

		if currentState == "privateRoute.community"
			Routes.push({
				title: "Comunidad"
				route: "privateRoute.community"
				fid: false
				pid: false
				question: false
				lastValue: true
				displayMenu: false
			})

		if currentState == "privateRoute.tutorial"
			Routes.push({
				title: "Tutorial"
				route: "privateRoute.tutorial"
				fid: false
				pid: false
				question: false
				lastValue: true
				displayMenu: false
			})

		if FlowRouter.getParam("question")
			Routes.push({
				title: "Comunidad"
				route: "privateRoute.community"
				fid: false
				pid: false
				question: false
				lastValue: false
				displayMenu: false
			})

			Routes.push({
				title: "Pregunta en Comunidad"
				route: "privateRoute.communityQuestion"
				fid: FlowRouter.getParam("fid")
				pid: FlowRouter.getParam("id")
				question: FlowRouter.getParam("question")
				lastValue: true
				displayMenu: false
			})

		_.last(Routes).lastValue = true
		lastRouteName = _.last(Routes).title

		return Routes


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


Template.notificationsDropdown.onCreated () ->
	@subscribe 'userNotifications'


Template.notificationsDropdown.helpers
	userNotifications: () ->
		return db.notifications.find({"notificationOwner": Meteor.userId()}, {sort: {createdAt: -1}})

	momentToNow: (createdAt) ->
		return moment(createdAt).fromNow()

	badgeStatus: () ->
		type = @type
		switch type
			when "new-user", "password-reset", "question-response"
				return "success"
			when 'time-registered'
				return "warning"

	revertMessage: () ->
		if @data?.reverted or @data?.disabled
			return true
		else
			return false

	notReverted: () ->
		if @data
			return false if @data.disabled
			return false if @data.reverted
			return true
		return false


Template.notificationsDropdown.events
	'click .notification-item': (e,t) ->
		e.preventDefault()
		e.stopPropagation()

		if @type == 'question-response'
			questionId = @data.questionId
			FlowRouter.go('privateRoute.communityQuestion', {"question": questionId})
			Session.set 'main-notification-dropdown', false

		unless @data?.reverted or @data?.disabled or @type != 'time-registered'
			Session.set 'main-notification-dropdown', false
			Modal.show('editTimeModal', @)


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



Template.createDefectAction.helpers
	projectCompleted: () ->
		return db.projects.findOne({ _id: FlowRouter.getParam("id") })?.completed


Template.createDefectAction.events
	'click .create-defect': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		projectId = FlowRouter.getParam("id")

		project = db.projects.findOne({ _id: projectId})
		unless project.completed
			Modal.show('createDefectModal')


Template.createCommunityQuestionAction.events
	'click .create-question': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		Modal.show('createQuestionModal')
