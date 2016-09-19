Template.PROBED.onCreated () ->
	#New time and size after  estimation, in this case is the input value

Template.PROBED.helpers
	PlanSummary:()->
		return db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total


Template.PROBED.events
	'click .save-data-time': (e,t)->
		psProject = db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total
		estimatedHours = sys.minutesToTime($(".newTime").val())
		if estimatedHours != 0 
			data= {
				"total.estimatedTime": estimatedHours
			}
			Meteor.call "update_plan_summary", FlowRouter.getParam("id"), data, (error) ->
				if error
					console.warn(error)
					sys.flashStatus("error-project")
				else
					sys.flashStatus("save-project")
		else
			sys.flashStatus("summary-missing")
	'click .save-data-size':(e,t)->
		psProject = db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total
		if psProject.proxyEstimated != 0
			data= {
				"total.estimatedAddedSize" : psProject.proxyEstimated
			}
			Meteor.call "update_plan_summary", FlowRouter.getParam("id"), data, (error) ->
				if error
					console.warn(error)
					sys.flashStatus("error-project")
				else
					sys.flashStatus("save-project")
		else
			sys.flashStatus("summary-missing")