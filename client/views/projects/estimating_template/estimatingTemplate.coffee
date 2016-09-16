PROBEC:(Projects)->
	return Projects



Template.historicalData.onCreated () ->
	@historicalProjectsData = new ReactiveVar([])
	@PROBESize = new ReactiveVar("PROBE D")
	@PROBETime = new ReactiveVar("PROBE D")
	@Beta0 = new ReactiveVar(0)
	@Beta1 = new ReactiveVar(0)
	@correlation = new ReactiveVar(0)
	#PROBE C
	#Size Estimated Proxy Size actual added and modified lines
	@totalProxySize = new ReactiveVar(0)
	@totalActualAddedModifiedLOC = new ReactiveVar(0)
	#Time Estimated Proxy Size - Actual hours
	@totalActualTime = new ReactiveVar(0)
	#PROBE B
	#Size Planned Added & Modified Size - Actual Added & Modified Size
	@totalPlanAddedModifiedLOC = new ReactiveVar(0)
	#Time Planned Added & Modified Size - Actual hours
	#PROBE A
	#Size Estimated Proxy Size actual - Added and modified lines
	#Time Estimated Proxy Size actual - Actual Hours

Template.historicalData.helpers
	gethistoricalProjects:()->
		totalProxy = 0
		totalActualLOC = 0
		totalPlanLOC = 0
		totalActualTime = 0
		projects = db.projects.find({"completed":true}).fetch()
		data = []
		_.each projects, (project)->
			unless project._id == FlowRouter.getParam("id")
				psProject = db.plan_summary.findOne({"projectId":project._id})?.total

				totalProxy += psProject.proxyEstimated
				totalActualLOC += psProject.ActualLOC
				totalPlanLOC += psProject.estimatedAddedSize
				totalActualTime += psProject.ActualTime
				#X is the proxy size for probe A and Planned added and modified 
				data.push({"Name":project.title, "Proxy":psProject.estimatedAdd + psProject.estimatedModified, "ActualLOC": psProject.actualAdd + psProject.actualModified, "EstimatedTime":psProject.estimatedTime, "ActualTime":psProject.totalTime})
		Template.instance().totalProxySize.set(totalProxy)
		Template.instance().totalActualAddedModifiedLOC.set(totalActualLOC)
		Template.instance().totalPlanAddedModifiedLOC.set(totalPlanLOC)
		Template.instance().totalActualTime.set(totalActualTime)
		Template.instance().historicalProjectsData.set(data)
	historicalProjects:()->
		return Template.instance().historicalProjectsData.get()
	PROBETimeGet:()->
		return Template.instance().PROBETime.get()
	PROBESizeGet:()->
		return Template.instance().PROBESize.get()
	GetEstimationValues:()->
		return {"Beta0":Template.instance().Beta0.get(),"Beta1":Template.instance().Beta1.get(),"r":Template.instance().correlation.get()}
Template.historicalData.events
	'click .save-data': (e,t)->
		PROBE = t.PROBESize.get()
		psProject = db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total
		console.log PROBE
		if PROBE == "PROBE D"
			data= {
				"total.estimatedAddedSize" : psProject.proxyEstimated
			}
			Meteor.call "update_plan_summary", FlowRouter.getParam("id"), data, (error) ->
				if error
					console.warn(error)
					sys.flashStatus("error-project")
				else
					sys.flashStatus("save-project")
					t.deleteActive.set(false)
	'click .probe-size-option':(e,t)->
		value = $(e.target).data('value')
		switch value
			when "A"
				Template.instance().PROBESize.set("PROBE A")
			when "B"
				Template.instance().PROBESize.set("PROBE B")
			when "C"
				Template.instance().PROBESize.set("PROBE C")
			when "D"
				Template.instance().PROBESize.set("PROBE D")
	'click .probe-time-option':(e,t)->
		value = $(e.target).data('value')
		switch value
			when "A"
				Template.instance().PROBETime.set("PROBE A")
			when "B"
				Template.instance().PROBETime.set("PROBE B")
			when "C"
				Template.instance().PROBETime.set("PROBE C")
			when "D"
				Template.instance().PROBETime.set("PROBE D")