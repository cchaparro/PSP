Template.PROBED.onCreated () ->
	#New time and size after  estimation, in this case is the input value


Template.PROBED.helpers
	PlanSummary:()->
		return db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total

	probeEditable: () ->
		projectStages = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})?.timeEstimated
		currentStage = _.findWhere projectStages, {finished: false}
		projectIsCompleted = db.projects.findOne({ _id: FlowRouter.getParam("id") })?.completed		
		return false if projectIsCompleted
		return true if currentStage?.name == "Planeación"
		return false


Template.PROBED.events

	'click .save-data-time': (e,t)->
		planSummary = db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total
		estimatedHours = $(".newTime").val()
		estimatedHours = parseFloat(estimatedHours)

		if estimatedHours != 0 
			plannedProductivity = parseInt((planSummary.estimatedAddedSize/estimatedHours))
			estimatedHours = sys.hoursToTime(estimatedHours)
			data= {
				"total.estimatedTime": estimatedHours
				"probeTime":"D"
				"total.productivityPlan" : plannedProductivity
			}
			Meteor.call "update_plan_summary", FlowRouter.getParam("id"), data, (error) ->
				if error
					console.warn(error)
					sys.flashStatus("error-save-time-estimated")
				else
					sys.flashStatus("save-summary-estimated")
		else
			sys.flashStatus("time-missing")

	'click .save-data-size':(e,t)->
		planSummary = db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total
		estimatedLOC = $(".newLOC").val()
		estimatedLOC = parseInt(estimatedLOC)

		if planSummary?.proxyEstimated != 0 and estimatedLOC!=0
			totalEstimatedSize	= planSummary?.proxyEstimated - planSummary?.estimatedModified - planSummary?.estimatedDeleted + planSummary?.estimatedBase + planSummary?.estimatedReused
			if planSummary?.estimatedTime != 0
				plannedProductivity = parseInt((estimatedLOC/planSummary?.estimatedTime))
			else
				plannedProductivity = parseInt(planSummary?.productivityPlan)

			data= {
				"total.estimatedAddedSize" : estimatedLOC
				"probeSize":"D"
				"total.productivityPlan" : plannedProductivity
				"total.estimatedTotalSize" : totalEstimatedSize
			}
			Meteor.call "update_plan_summary", FlowRouter.getParam("id"), data, (error) ->
				if error
					console.warn(error)
					sys.flashStatus("error-save-size-estimated")
				else
					sys.flashStatus("save-size-estimated")
		else
			sys.flashStatus("size-missing")