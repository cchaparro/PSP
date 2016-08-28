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

	profilePicture: () ->
		return db.Images.findOne({_id: @profile.profileImageUrl})

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

		if currentState=="projectGeneral" or currentState=="projectTimeLog" or currentState=="projectDefectLog" or currentState=="projectSummary" or currentState=="projectScripts" or currentState=="projects"
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
		if Session.get("display-notification-box")
			Session.set("display-notification-box", false)
			userNotifications = db.notifications.find({"notificationOwner": Meteor.userId()}, {sort: {"createdAt": -1}})

			userNotifications.forEach (notification) ->
				userNotifications[notification._id] = notification.seen

			notSeenNotifications.set(userNotifications)
			Meteor.call("notificationsSeen")
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
		else
			return ""


Template.userNotification.events
	'click .notification-item': (e,t) ->
		unless @data?.reverted or @type != 'time-registered'
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
	'click .logout': () ->
		Meteor.logout()
		FlowRouter.go("/")

##################################################
Template.createProjectButton.events
	'click .create-btn': (e,t) ->
		#FlowRouter.setQueryParams({action: "alerts"});
		Modal.show('createProjectModal')

##################################################
Template.createDefectButton.events
	'click .create-btn': (e,t) ->
		Modal.show('createDefectModal')

##################################################
Template.createIterationButton.events
	'click .create-btn': (e,t) ->
		data = {
			title: "Nueva iteración"
			description: "Descripción de esta nueva iteración"
			levelPSP: "PSP 0"
			parentId: FlowRouter.getParam("fid")
		}

		Meteor.call "create_project", data, (error) ->
			if error
				console.log "Error creating a new project iteration"
				console.warn(error)
			else
				sys.flashStatus("create-project")

##################################################
