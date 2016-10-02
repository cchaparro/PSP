##################################################
Template.main_userBar.helpers
	template: () ->
		FlowRouter.watchPathChange()
		return FlowRouter.current().route.name

	userNotifications: () ->
		return db.notifications.find({"notificationOwner": Meteor.userId()}, {sort: {"createdAt": -1}})

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