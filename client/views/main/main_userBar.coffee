##################################################
Template.main_userBar.helpers
	userData: () ->
		user = Meteor.users.findOne({_id: Meteor.userId()})
		return user if user?

	viewState: () ->
		FlowRouter.watchPathChange()
		currentState = FlowRouter.current().route.name

		Routes = [{
			title: sys.getPageName(currentState)
			route: FlowRouter.current().route.name
			fid: false
			pid: false
			lastValue: false
		}]

		if FlowRouter.getParam("fid")
			Routes.push({
				title: "Iteraciónes"
				route: "iterationView"
				fid: FlowRouter.getParam("fid")
				pid: false
				lastValue: false
			})

		if FlowRouter.getParam("id")
			Project = db.projects.findOne({_id: FlowRouter.getParam("id"), "projectOwner": Meteor.userId()})

			if Project
				Routes.push({
					title: Project.title
					route: "projectView"
					fid: FlowRouter.getParam("fid")
					pid: FlowRouter.getParam("id")
					lastValue: false
				})

		_.last(Routes).lastValue = true
		return Routes

##################################################
Template.userMenuDropdown.events
	'click .logout': () ->
		Meteor.logout()
		FlowRouter.go("/login")

##################################################