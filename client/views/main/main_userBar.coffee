##################################################
notSeenNotifications = new ReactiveVar({})
##################################################
Template.main_userBar.onCreated () ->
	Meteor.subscribe "UserMenu"
	Session.set("display-user-box", false)
	Session.set("display-notification-box", false)

Template.main_userBar.helpers
	userData: () ->
		user = Meteor.users.findOne({_id: Meteor.userId()})
		return user if user?

	template: () ->
		FlowRouter.watchPathChange()
		return FlowRouter.current().route.name

	userNotifications: () ->
		return db.notifications.find({"notificationOwner": Meteor.userId()}, {sort: {"createdAt": -1}})

	showNotificationBadge: () ->
		return db.notifications.find({"notificationOwner": Meteor.userId(), "seen": false}).count() > 0

	viewState: () ->
		FlowRouter.watchPathChange()
		currentState = FlowRouter.current().route.name

		if currentState=="projectGeneral" or currentState=="projectTimeLog" or currentState=="projectDefectLog" or currentState=="projectSummary" or currentState=="projectScripts" or currentState=="projects" or currentState=="estimatingtemplate"
			initialRoute = "projects"
		else
			initialRoute = currentState

		Routes = [{
			title: sys.getPageName(currentState)
			route: initialRoute
			fid: false
			pid: false
			lastValue: false
		}]

		if FlowRouter.getParam("fid")
			Routes.push({
				title: "Iteraciones"
				route: "iterations"
				fid: FlowRouter.getParam("fid")
				pid: false
				lastValue: false
			})

		if FlowRouter.getParam("id")
			Project = db.projects.findOne({_id: FlowRouter.getParam("id"), "projectOwner": Meteor.userId()})

			if Project
				Routes.push({
					title: Project.title
					route: "projectGeneral"
					fid: FlowRouter.getParam("fid")
					pid: FlowRouter.getParam("id")
					lastValue: false
				})

		_.last(Routes).lastValue = true

		return Routes


Template.main_userBar.events
	'click .avatar': (e,t) ->
		if Session.get("display-user-box")
			Session.set("display-user-box", false)
		else
			Session.set("display-user-box", true)

	'click .notification-svg, click .notification-badge': (e,t) ->
		Meteor.call "notificationsSeen"
		if Session.get("display-notification-box")
			Session.set("display-notification-box", false)
			userNotifications = db.notifications.find({"notificationOwner": Meteor.userId()}, {sort: {"createdAt": -1}})

			userNotifications.forEach (notification) ->
				userNotifications[notification._id] = notification.seen

			notSeenNotifications.set(userNotifications)
		else
			Session.set("display-notification-box", true)

##################################################
Template.userNotification.helpers
	notificationSeen: () ->
		userNotifications = notSeenNotifications.get()
		unless userNotifications[@_id]?
			return true
		return userNotifications[@_id] == true

	userNotifications: () ->
		return db.notifications.find({"notificationOwner": Meteor.userId()}, {sort: {createdAt: -1}})

	momentToNow: (createdAt) ->
		return moment(createdAt).fromNow()

	badgeStatus: () ->
		type = @type
		switch type
			when "new-user"
				return "success"
			when 'time-registered'
				return "warning"

	revertMessage: () ->
		if @data?.reverted
			return "(Modificado)"
		else if @data?.disabled
			return "(Proyecto Completado)"
		else
			return ""

	notificationDisabled: () ->
		if @data?.reverted or @data?.disabled
			return true
		else
			return false


Template.userNotification.events
	'click .notification-item': (e,t) ->
		unless @data?.reverted or @data?.disabled or @type != 'time-registered'
			Session.set("display-notification-box", false)
			Modal.show('editTimeModal', @)

##################################################
Template.userMenuDropdown.helpers
	notificationIcon: () ->
		switch @type
			when 'new-user'
				return "fa-check"
			when "aqui"
				return "fa-times"

	totalAmountNotifications: () ->
		return db.notifications.find({"notificationOwner": Meteor.userId()}).count()


Template.userMenuDropdown.events
	'click .logout': (e,t) ->
		Meteor.logout()
		FlowRouter.go("/")

	'click .edit-profile': (e,t) ->
		Modal.show('editProfileModal')

##################################################
Template.createProjectButton.events
	'click .create-btn': (e,t) ->
		#FlowRouter.setQueryParams({action: "alerts"});
		Modal.show('createProjectModal')

##################################################
Template.createDefectButton.helpers
	projectIsCompleted: () ->
		return db.projects.findOne({ _id: FlowRouter.getParam("id") })?.completed


Template.createDefectButton.events
	'click .create-btn': (e,t) ->
		project = db.projects.findOne({ _id: FlowRouter.getParam("id") })
		unless project.completed
			Modal.show('createDefectModal')

##################################################
Template.createIterationButton.events
	'click .create-btn': (e,t) ->
		currentProject = db.projects.findOne({ _id: FlowRouter.getParam("fid") })

		# The currentProject takes the parent projects levelPSP and gives it to the new interation
		data = {
			title: "Nueva iteración"
			description: "Descripción de esta nueva iteración"
			levelPSP: currentProject.levelPSP
			parentId: FlowRouter.getParam("fid")
		}

		Meteor.call "create_project", data, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("error-create-iteration")
			else
				sys.flashStatus("create-iteration")

##################################################
