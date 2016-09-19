Template.PROBEB.onCreated () ->
	#PROBE B
	#Size Planned Added & Modified Size - Actual Added & Modified Size
	#Time Planned Added & Modified Size - Actual hours
	@Beta0Size = new ReactiveVar(0)
	@Beta1Size = new ReactiveVar(0)
	
	@Beta0Time = new ReactiveVar(0)
	@Beta1Time = new ReactiveVar(0)
	
	@CorrelationTime = new ReactiveVar(0)
	@CorrelationSize = new ReactiveVar(0)

	#New time and size after estimation
	@adjustedTime = new ReactiveVar(0)
	@adjustedSize = new ReactiveVar(0)

	@descriptionTime = new ReactiveVar("")
	@descriptionSize = new ReactiveVar("")

	@validProbeTime = new ReactiveVar(false)
	@validProbeSize = new ReactiveVar(false)
Template.PROBEB.helpers
	setData:()->
		totalAddedModifiedActualLOC = 0
		totalPlanLOC = 0
		totalActualTime = 0
		projects = db.projects.find({"completed":true}).fetch()
		data = []
		if projects.length > 3
			_.each projects, (project)->
				unless project._id == FlowRouter.getParam("id")
					psProject = db.plan_summary.findOne({"projectId":project._id})?.total

					totalAddedModifiedActualLOC += (psProject.actualAdd + psProject.actualModified)
					totalPlanLOC += psProject.estimatedAddedSize
					totalActualTime += psProject.totalTime
					data.push(
						{
							"ActualLOC": psProject.actualAdd + psProject.actualModified
							"ActualTime":psProject.totalTime
							"PlanLOC":psProject.estimatedAddedSize
						})
			
			TimeLinearRegressionData = sys.regressionDataTime(data,"B",totalPlanLOC,sys.timeToMinutes(totalActualTime))
			Template.instance().Beta0Time.set(TimeLinearRegressionData.Beta0)
			Template.instance().Beta1Time.set(TimeLinearRegressionData.Beta1)
			Template.instance().CorrelationTime.set(TimeLinearRegressionData.Correlation)

			SizeLinearRegressionData = sys.regressionDataSize(data,"B",totalPlanLOC,totalAddedModifiedActualLOC)
			Template.instance().Beta0Size.set(SizeLinearRegressionData.Beta0)
			Template.instance().Beta1Size.set(SizeLinearRegressionData.Beta1)
			Template.instance().CorrelationSize.set(SizeLinearRegressionData.Correlation)

			Template.instance().validProbeTime.set(true)
			Template.instance().validProbeSize.set(true)		
		else
			Template.instance().descriptionSize.set("No hay suficientes datos históricos")
			Template.instance().descriptionTime.set("No hay suficientes datos históricos")

	GetTimeEstimationValues:()->
		return {"Beta0":Template.instance().Beta0Time.get(),"Beta1":Template.instance().Beta1Time.get(),"r":Template.instance().CorrelationTime.get()}

	GetSizeEstimationValues:()->
		return {"Beta0":Template.instance().Beta0Size.get(),"Beta1":Template.instance().Beta1Size.get(),"r":Template.instance().CorrelationSize.get()}

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

	DescriptionTime:()->
		return Template.instance().descriptionTime.get()

	DescriptionSize:()->
		return Template.instance().descriptionSize.get()
	
	ValidTime:()->
		return Template.instance().ValidTime.get()

	validSize:()->
		return Template.instance().validSize.get()

Template.PROBEB.events
	'click .save-data-time': (e,t)->
		data= {
			"total.estimatedTime": sys.minutesToTime(Template.instance().adjustedTime.get())
		}
		Meteor.call "update_plan_summary", FlowRouter.getParam("id"), data, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("error-project")
			else
				sys.flashStatus("save-project")
	'click .save-data-size': (e,t)->
		data= {
			"total.estimatedAddedSize" : parseInt(Template.instance().adjustedSize.get())
		}
		Meteor.call "update_plan_summary", FlowRouter.getParam("id"), data, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("error-project")
			else
				sys.flashStatus("save-project")