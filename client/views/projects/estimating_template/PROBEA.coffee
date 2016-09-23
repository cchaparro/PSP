Template.PROBEA.onCreated () ->
	#PROBE A
	#Size Estimated Proxy Size actual - Added and modified lines
	#Time Estimated Proxy Size actual - Actual Hours
	#New time and size after the estimation
	@Beta0Size = new ReactiveVar(0)
	@Beta1Size = new ReactiveVar(0)
	
	@Beta0Time = new ReactiveVar(0)
	@Beta1Time = new ReactiveVar(0)
	
	@CorrelationTime = new ReactiveVar(0)
	@CorrelationSize = new ReactiveVar(0)
	
	@adjustedTime = new ReactiveVar(0)
	@adjustedSize = new ReactiveVar(0)
	
	@descriptionTime = new ReactiveVar("")
	@descriptionSize = new ReactiveVar("")
	
	@validProbeTime = new ReactiveVar(false)
	@validProbeSize = new ReactiveVar(false)
Template.PROBEA.helpers
	setData:()->
		totalProxy = 0
		totalAddedModifiedActualLOC = 0
		totalActualTime = 0
		projects = db.projects.find({"completed":true}).fetch()
		data = []
		if projects.length > 2
			_.each projects, (project)->
				unless project._id == FlowRouter.getParam("id")
					psProject = db.plan_summary.findOne({"projectId":project._id})?.total
					totalProxy += psProject?.proxyEstimated
					totalAddedModifiedActualLOC += (psProject?.actualAdd + psProject?.actualModified)
					totalActualTime += psProject?.totalTime
					data.push(
						{
							"ProxyE":psProject?.proxyEstimated
							"ActualLOC": psProject?.actualAdd + psProject?.actualModified
							"ActualTime":psProject?.totalTime
						})
					
			SizeLinearRegressionData = sys.regressionDataSize(data,"A",totalProxy,totalAddedModifiedActualLOC)
			Template.instance().Beta0Size.set(SizeLinearRegressionData.Beta0)
			Template.instance().Beta1Size.set(SizeLinearRegressionData.Beta1)
			Template.instance().CorrelationSize.set(SizeLinearRegressionData.Correlation)

			TimeLinearRegressionData = sys.regressionDataTime(data,"A",totalProxy,sys.timeToHours(totalActualTime))
			Template.instance().Beta0Time.set(TimeLinearRegressionData.Beta0)
			Template.instance().Beta1Time.set(TimeLinearRegressionData.Beta1)
			Template.instance().CorrelationTime.set(TimeLinearRegressionData.Correlation)


	GetTimeEstimationValues:()->
		return {"Beta0":Template.instance().Beta0Time.get().toFixed(2),"Beta1":Template.instance().Beta1Time.get().toFixed(2),"r":Template.instance().CorrelationTime.get().toFixed(2)}

	GetSizeEstimationValues:()->
		return {"Beta0":Template.instance().Beta0Size.get().toFixed(2),"Beta1":Template.instance().Beta1Size.get().toFixed(2),"r":Template.instance().CorrelationSize.get().toFixed(2)}

	AdjustedSize:()->
		psProject = db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total
		B0=Template.instance().Beta0Size.get()
		B1=Template.instance().Beta1Size.get()
		newsize = (B0+B1)*psProject?.proxyEstimated
		Template.instance().adjustedSize.set(newsize)
		return newsize.toFixed(2)

	AdjustedTime:()->
		psProject = db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total
		B0=Template.instance().Beta0Time.get()
		B1=Template.instance().Beta1Time.get()
		newTime = (B0+B1)*psProject?.proxyEstimated
		Template.instance().adjustedTime.set(newTime)
		return newTime.toFixed(2)

	DescriptionTime:()->
		projects = db.projects.find({"completed":true}).fetch()
		if projects.length >2
			r=Math.pow(Template.instance().CorrelationTime.get(),2)
			if r > 0.5
				Template.instance().descriptionTime.set("Faltan los betas")
			else
				Template.instance().descriptionTime.set("Los datos adquiridos no se correlacionan entre sí el valor de r al cuadrado debe ser > 0,5 y el valor actual es de "+r)
		else
			Template.instance().descriptionTime.set("No hay suficientes datos históricos")
		return Template.instance().descriptionTime.get()


	DescriptionSize:()->
		projects = db.projects.find({"completed":true}).fetch()
		if projects.length >2
			r=Math.pow(Template.instance().CorrelationSize.get(),2)
			if r > 0.5
				Template.instance().descriptionSize.set("Faltan los betas")
			else
				Template.instance().descriptionSize.set("Los datos adquiridos no se correlacionan entre sí el valor de r al cuadrado debe ser > 0,5 y el valor actual es de "+r)
		else
			Template.instance().descriptionSize.set("No hay suficientes datos históricos")
		return Template.instance().descriptionSize.get()


	validTime:()->
		return Template.instance().validProbeTime.get()

	validSize:()->
		return Template.instance().validProbeSize.get()
Template.PROBEA.events
	'click .save-data-time': (e,t)->
		planSummary = db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total
		if Template.instance().validProbeTime.get()
			planSummary = db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total
			plannedProductivity = parseInt(planSummary?.estimatedAddedSize/Template.instance().adjustedTime.get())
		else
			plannedProductivity = parseInt(planSummary?.productivityPlan)

		data= {
			"total.estimatedTime": sys.hoursToTime(Template.instance().adjustedTime.get())
			"total.productivityPlan" : plannedProductivity
			"probeTime":"A"
		}
		Meteor.call "update_plan_summary", FlowRouter.getParam("id"), data, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("error-project")
			else
				sys.flashStatus("save-project")
	'click .save-data-size': (e,t)->
		planSummary = db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total
		if planSummary?.estimatedTime != 0 and Template.instance().validProbeSize.get()
			plannedProductivity = parseInt(Template.instance().adjustedSize.get()/planSummary?.estimatedTime)
		else
			plannedProductivity = parseInt(planSummary?.productivityPlan)

		data= {
			"total.estimatedAddedSize" : parseInt(Template.instance().adjustedSize.get())
			"total.productivityPlan" : plannedProductivity
			"probeSize":"A"
		}
		Meteor.call "update_plan_summary", FlowRouter.getParam("id"), data, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("error-project")
			else
				sys.flashStatus("save-project")