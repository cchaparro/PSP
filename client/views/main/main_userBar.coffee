##################################################
notSeenNotifications = new ReactiveVar({})
##################################################
Template.main_userBar.onCreated () ->
	Meteor.subscribe "UserMenu"

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
		$('.user-dropdown').toggleClass('hide')
		$('.user-dropdown-tab').toggleClass('hide')

	'click .notification-svg, click .notification-badge': (e,t) ->
		$('.notification-box').toggleClass('hide')

		if !$('.notification-box').hasClass('hide')
			userNotifications = {}
			userNotifications = db.notifications.find({"notificationOwner": Meteor.userId()}, {sort: {"createdAt": -1}})

			userNotifications.forEach (notification) ->
				userNotifications[notification._id] = notification.seen

			notSeenNotifications.set(userNotifications)
			Meteor.call("notificationsSeen")

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


Template.userNotification.events
	'click .notification-item': (e,t) ->
		console.log @
		if @type == 'time-registered'
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
