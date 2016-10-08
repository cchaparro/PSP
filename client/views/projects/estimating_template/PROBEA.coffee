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
					totalActualTime += sys.timeToHours(psProject?.totalTime)
					data.push(
						{
							"ProxyE":psProject?.proxyEstimated
							"ActualLOC": psProject?.actualAdd + psProject?.actualModified
							"ActualTime":sys.timeToHours(psProject?.totalTime)
						})
					
			SizeLinearRegressionData = sys.regressionDataSize(data,"A",totalProxy,totalAddedModifiedActualLOC)
			Template.instance().Beta0Size.set(SizeLinearRegressionData.Beta0)
			Template.instance().Beta1Size.set(SizeLinearRegressionData.Beta1)
			Template.instance().CorrelationSize.set(SizeLinearRegressionData.Correlation)

			TimeLinearRegressionData = sys.regressionDataTime(data,"A",totalProxy,totalActualTime)
			Template.instance().Beta0Time.set(TimeLinearRegressionData.Beta0)
			Template.instance().Beta1Time.set(TimeLinearRegressionData.Beta1)
			Template.instance().CorrelationTime.set(TimeLinearRegressionData.Correlation)


	GetTimeEstimationValues:()->
		beta0 = Template.instance().Beta0Time.get().toFixed(2)
		beta1 = Template.instance().Beta1Time.get().toFixed(2)		
		correlation = Template.instance().CorrelationTime.get().toFixed(2)
		return {"Beta0":beta0,"Beta1":beta1,"r":correlation}

	GetSizeEstimationValues:()->
		beta0 = Template.instance().Beta0Size.get().toFixed(2)
		beta1 = Template.instance().Beta1Size.get().toFixed(2)		
		correlation = Template.instance().CorrelationSize.get().toFixed(2)
		return {"Beta0":beta0,"Beta1":beta1,"r":correlation}

	AdjustedSize:()->
		psProject = db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total
		B0=Template.instance().Beta0Size.get()
		B1=Template.instance().Beta1Size.get()
		newsize = B0+(B1*parseInt(psProject?.proxyEstimated))
		Template.instance().adjustedSize.set(newsize)
		return newsize.toFixed(2)

	AdjustedTime:()->
		psProject = db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total
		B0=Template.instance().Beta0Time.get()
		B1=Template.instance().Beta1Time.get()
		newTime = (B0+(B1*parseInt(psProject?.proxyEstimated)))
		Template.instance().adjustedTime.set(newTime)
		return newTime.toFixed(2)

	DescriptionTime:()->
		projects = db.projects.find({"completed":true}).fetch()
		if projects.length >2
			r=Math.pow(Template.instance().CorrelationTime.get(),2)
			if r > 0.5
				b0 = Template.instance().Beta0Time.get()
				p = Template.instance().adjustedTime.get() * 0.5
				if b0 < p 
					b1 = Template.instance().Beta1Time.get()
					user = db.users.findOne({_id: Meteor.userId()})
					historicProductivity = (user.profile.sizeAmount.add+user.profile.sizeAmount.modified)/sys.timeToHours(user.profile.total.time) * 0.50
					if b1 <= 1/(historicProductivity)
						Template.instance().descriptionTime.set("PROBE A cumple con los requisitos necesarios, tus párametros de regresión estan dentro de los límites")
						Template.instance().validProbeTime.set(true)
					else
						Template.instance().descriptionTime.set("El valor de 1/Beta1 debe estar entre el 50% de la productividad histórica, el valor de 1/Beta1 es: " + 1/b1.toFixed(2) + " y la productividad histórica es: " + historicProductivity.toFixed(2)+ " LOC/Hrs")
				else
					Template.instance().descriptionTime.set("El valor de Beta 0 debe ser más pequeño que el 25% del tiempo estimado del proyecto, el valor de Beta 0 es: " + b0.toFixed(2) + " y el valor del nuevo tiempo * 25% es: " + p.toFixed(2))
			else
				Template.instance().descriptionTime.set("Los datos adquiridos no se correlacionan entre sí, el valor de r al cuadrado debe ser > 0,5 y el valor actual es de "+r.toFixed(2))
		else
			Template.instance().descriptionTime.set("No hay suficientes datos históricos")
		return Template.instance().descriptionTime.get()

	DescriptionSize:()->
		projects = db.projects.find({"completed":true}).fetch()
		if projects.length >2
			r=Math.pow(Template.instance().CorrelationSize.get(),2)
			if r > 0.5
				b0 = Template.instance().Beta0Size.get()
				#New estimated size
				p= Template.instance().adjustedSize.get()*0.25
				if b0 < p
					b1= Template.instance().Beta1Size.get()
					if b1<=2 and b1>=0
						Template.instance().descriptionSize.set("PROBE A cumple con los requisitos necesarios, tus párametros de regresión estan dentro de los límites")
						Template.instance().validProbeSize.set(true)
					else
						Template.instance().descriptionSize.set("El valor de Beta 1 debe estar entre 0 y 2, en este caso Beta 0 es: " + b1.toFixed(2))
				else
					Template.instance().descriptionSize.set("El valor de Beta 0 debe ser significante más pequeño que el nuevo tamaño del proyecto, el valor de Beta 0 es: " + b0.toFixed(2) + " y el valor del nuevo tamaño * 25% es: " + p.toFixed(2))
			else
				Template.instance().descriptionSize.set("Los datos adquiridos no se correlacionan entre sí el valor de r al cuadrado debe ser > 0,5 y el valor actual es de "+r.toFixed(2))
		else
			Template.instance().descriptionSize.set("No hay suficientes datos históricos")
		return Template.instance().descriptionSize.get()

	validTime:()->
		return Template.instance().validProbeTime.get()

	validSize:()->
		return Template.instance().validProbeSize.get()

	probeEditable: () ->
		projectStages = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})?.timeEstimated
		currentStage = _.findWhere projectStages, {finished: false}
		projectIsCompleted = db.projects.findOne({ _id: FlowRouter.getParam("id") })?.completed		
		return false if projectIsCompleted
		return true if currentStage?.name == "Planeación"
		return false


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
				sys.flashStatus("error-save-time-estimated")
			else
				sys.flashStatus("save-summary-estimated")

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
				sys.flashStatus("error-save-size-estimated")
			else
				sys.flashStatus("save-size-estimated")