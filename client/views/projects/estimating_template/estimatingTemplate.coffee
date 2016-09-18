Template.historicalData.onCreated () ->
	@historicalProjectsData = new ReactiveVar([])
	#PROBE for time and size
	@PROBESize = new ReactiveVar("PROBE D")
	@PROBETime = new ReactiveVar("PROBE D")
	#Betas
	@Beta0Size = new ReactiveVar(0)
	@Beta1Size = new ReactiveVar(0)
	@Beta0Time = new ReactiveVar(0)
	@Beta1Time = new ReactiveVar(0)
	@Correlation = new ReactiveVar(0)
	#PROBE C
	#Size Estimated Proxy Size - actual added and modified lines
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
	#New time and size after the estimation
	@adjustedTime = new ReactiveVar(0)
	@adjustedSize = new ReactiveVar(0)

Template.historicalData.helpers
	gethistoricalProjects:()->
		totalProxy = 0
		totalAddedModifiedActualLOC = 0
		totalPlanLOC = 0
		totalActualTime = 0
		projects = db.projects.find({"completed":true}).fetch()
		data = []
		_.each projects, (project)->
			unless project._id == FlowRouter.getParam("id")
				psProject = db.plan_summary.findOne({"projectId":project._id})?.total

				totalProxy += psProject.proxyEstimated
				totalAddedModifiedActualLOC += (psProject.actualAdd + psProject.actualModified)
				totalPlanLOC += psProject.estimatedAddedSize
				totalActualTime += psProject.totalTime
				#X is the proxy size for probe A and Planned added and modified 
				data.push(
					{
						"Name":project.title
						"ProxyE":psProject.proxyEstimated
						"ActualLOC": psProject.actualAdd + psProject.actualModified
						"EstimatedTime":psProject.estimatedTime
						"ActualTime":psProject.totalTime
						"PlanLOC":psProject.estimatedAddedSize
					})
		Template.instance().totalProxySize.set(totalProxy)
		Template.instance().totalActualAddedModifiedLOC.set(totalAddedModifiedActualLOC)
		Template.instance().totalPlanAddedModifiedLOC.set(totalPlanLOC)
		Template.instance().totalActualTime.set(totalActualTime)
		Template.instance().historicalProjectsData.set(data)

	historicalProjects:()->
		return Template.instance().historicalProjectsData.get()

	PROBETimeGet:()->
		return Template.instance().PROBETime.get()

	PROBESizeGet:()->
		return Template.instance().PROBESize.get()

	GetTimeEstimationValues:()->
		return {"Beta0":Template.instance().Beta0Time.get(),"Beta1":Template.instance().Beta1Time.get(),"r":Template.instance().Correlation.get()}

	GetSizeEstimationValues:()->
		return {"Beta0":Template.instance().Beta0Size.get(),"Beta1":Template.instance().Beta1Size.get(),"r":Template.instance().Correlation.get()}

	PlanSummary:()->
		return db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total

	AdjustedSize:()->
		psProject = db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total
		B0=Template.instance().Beta0Size.get()
		B1=Template.instance().Beta1Size.get()
		newsize = (B0+B1)*psProject.proxyEstimated
		Template.instance().adjustedSize.set(newsize)
		return newsize

	AdjustedTime:()->
		psProject = db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total
		B0=Template.instance().Beta0Time.get()
		B1=Template.instance().Beta1Time.get()
		newTime = (B0+B1)*psProject.proxyEstimated
		Template.instance().adjustedTime.set(newTime)
		return newTime

Template.historicalData.events
	'click .save-data': (e,t)->
		PROBESize = t.PROBESize.get()
		PROBETime = t.PROBETime.get()
		psProject = db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total
		if PROBESize == "PROBE D"
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
			data= {
				"total.estimatedAddedSize" : Template.instance().adjustedTime.get()
			}
			Meteor.call "update_plan_summary", FlowRouter.getParam("id"), data, (error) ->
				if error
					console.warn(error)
					sys.flashStatus("error-project")
				else
					sys.flashStatus("save-project")

		if PROBETime == "PROBE D"
				estimatedHours = sys.minutesToTime($(".newTime").val())
				if estimatedHours != 0
					timedata = {
						"total.estimatedTime": estimatedHours
					}
					Meteor.call "update_plan_summary", FlowRouter.getParam("id"), timedata, (error) ->
						if error
							console.warn(error)
							sys.flashStatus("error-project")
						else
							sys.flashStatus("save-project")
				else
					sys.flashStatus("summary-missing")
		else 
			timedata = {
				"total.estimatedTime": sys.minutesToTime(Template.instance().adjustedTime.get())
			}
			Meteor.call "update_plan_summary", FlowRouter.getParam("id"), timedata, (error) ->
				if error
					console.warn(error)
					sys.flashStatus("error-project")
				else
					sys.flashStatus("save-project")

	'click .probe-size-option':(e,t)->
		value = $(e.target).data('value')
		switch value

			when "A"
				Template.instance().PROBESize.set("PROBE A")
				totalProxy = Template.instance().totalProxySize.get()
				totalAddedModifiedActualLOC = Template.instance().totalActualAddedModifiedLOC.get()
				LinearRegressionData = sys.regressionDataSize(Template.instance().historicalProjectsData.get(),"A",totalProxy,totalAddedModifiedActualLOC)
				Template.instance().Beta0Size.set(LinearRegressionData.Beta0)
				Template.instance().Beta1Size.set(LinearRegressionData.Beta1)
				Template.instance().Correlation.set(LinearRegressionData.Correlation)

			when "B"
				Template.instance().PROBESize.set("PROBE B")
				totalAddedModifiedPlanLOC = Template.instance().totalPlanAddedModifiedLOC.get()
				totalAddedModifiedActualLOC = Template.instance().totalActualAddedModifiedLOC.get()
				LinearRegressionData = sys.regressionDataSize(Template.instance().historicalProjectsData.get(),"B",totalAddedModifiedPlanLOC,totalAddedModifiedActualLOC)
				Template.instance().Beta0Size.set(LinearRegressionData.Beta0)
				Template.instance().Beta1Size.set(LinearRegressionData.Beta1)
				Template.instance().Correlation.set(LinearRegressionData.Correlation)

			when "C"
				Template.instance().PROBESize.set("PROBE C")
				Template.instance().Beta0Size.set(0)
				newBeta1=(Template.instance().totalActualAddedModifiedLOC.get()/Template.instance().totalProxySize.get()).toFixed(2)
				Template.instance().Beta1Size.set(newBeta1)

			when "D"
				Template.instance().PROBESize.set("PROBE D")
	'click .probe-time-option':(e,t)->
		value = $(e.target).data('value')
		switch value
			when "A"
				Template.instance().PROBETime.set("PROBE A")
				totalProxy = Template.instance().totalProxySize.get()
				ActualTime = sys.timeToMinutes(Template.instance().totalActualTime.get())
				LinearRegressionData = sys.regressionDataTime(Template.instance().historicalProjectsData.get(),"A",totalProxy,ActualTime)
				Template.instance().Beta0Time.set(LinearRegressionData.Beta0)
				Template.instance().Beta1Time.set(LinearRegressionData.Beta1)
				Template.instance().Correlation.set(LinearRegressionData.Correlation)

			when "B"
				Template.instance().PROBETime.set("PROBE B")
				totalAddedModifiedPlanLOC = Template.instance().totalPlanAddedModifiedLOC.get()
				ActualTime = sys.timeToMinutes(Template.instance().totalActualTime.get())
				LinearRegressionData = sys.regressionDataTime(Template.instance().historicalProjectsData.get(),"A",totalAddedModifiedPlanLOC,ActualTime)
				Template.instance().Beta0Time.set(LinearRegressionData.Beta0)
				Template.instance().Beta1Time.set(LinearRegressionData.Beta1)
				Template.instance().Correlation.set(LinearRegressionData.Correlation)

			when "C"
				Template.instance().PROBETime.set("PROBE C")
				newBeta1=(sys.timeToMinutes(Template.instance().totalActualTime.get())/Template.instance().totalProxySize.get()).toFixed(2)
				Template.instance().Beta0Time.set(0)
				Template.instance().Beta1Time.set(newBeta1)

			when "D"
				Template.instance().PROBETime.set("PROBE D")