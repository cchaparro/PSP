# Template.projectViewMenu.helpers
# 	projectViewSelector: () ->
# 		return projectViewSelector.get()

# 	notPSP0: () ->
# 		return !(db.projects.findOne({"_id":FlowRouter.getParam("id")})?.levelPSP=="PSP 0")

# 	isPSP2: () ->
# 		return (db.projects.findOne({"_id":FlowRouter.getParam("id")})?.levelPSP=="PSP 2")

# 	routeFid: () ->
# 		return FlowRouter.getParam("fid")

# 	routeId: () ->
# 		return FlowRouter.getParam("id")

# 	template: () ->
# 		FlowRouter.watchPathChange()
# 		return FlowRouter.current().route.name

# 	isPostmortem: () ->
# 		planSummary = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})
# 		projectStages = _.filter planSummary?.timeEstimated, (stage) ->
# 			unless stage.finished
# 				return stage
# 		currentPos = _.first(projectStages)?.name

# 		return currentPos == "Postmortem" or projectStages.length == 0


Template.projectMessages.helpers
	projectCompleted: () ->
		return db.projects.findOne({ _id: FlowRouter.getParam("id") })?.completed
