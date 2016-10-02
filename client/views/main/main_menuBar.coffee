##################################################
notSeenNotifications = new ReactiveVar({})
##################################################
Template.main_menuBar.onCreated () ->
	Meteor.subscribe "UserMenu"
	Session.set("display-user-box", false)
	Session.set("display-notification-box", false)

Template.main_menuBar.helpers
	template: () ->
		FlowRouter.watchPathChange()
		return FlowRouter.current().route.name

	isProjectView: () ->
		FlowRouter.watchPathChange()
		route = FlowRouter.current().route.name
		return (route == 'projects') or (route == 'iterations') or (route == 'projectView') or (route == "projectGeneral") or (route == "projectTimeLog") or (route == "projectDefectLog") or (route == "projectSummary") or (route == "projectScripts") or (route == "estimatingtemplate")

	isSettingsView: () ->
		FlowRouter.watchPathChange()
		route = FlowRouter.current().route.name
		return (route == 'projectSettings') or (route == 'accountSettings') or (route == 'defectTypeSettings')

	userData: () ->
		user = Meteor.users.findOne({_id: Meteor.userId()})
		return user if user?

	showNotificationBadge: () ->
		return db.notifications.find({"notificationOwner": Meteor.userId(), "seen": false}).count() > 0


Template.main_menuBar.events
	'click .avatar': (e,t) ->
		e.preventDefault()
		e.stopPropagation()

		if Session.get("display-user-box")
			Session.set("display-user-box", false)
		else
			Session.set("display-user-box", true)

	'click .notification': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
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
Template.userMenuDropdown.events
	'click .logout': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		Meteor.logout()
		FlowRouter.go("/")

	'click .edit-profile': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		Modal.show('editProfileModal')

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
			when "new-user", "password-reset"
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
		e.preventDefault()
		e.stopPropagation()

		unless @data?.reverted or @data?.disabled or @type != 'time-registered'
			Session.set("display-notification-box", false)
			Modal.show('editTimeModal', @)

##################################################