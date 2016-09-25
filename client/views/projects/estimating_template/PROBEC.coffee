Template.PROBEC.onCreated () ->
	#PROBE C
	#Size Estimated Proxy Size - actual added and modified lines
	#Time Estimated Proxy Size - Actual hours
	#New time and size after estimation
	#Betas
	@Beta0Size = new ReactiveVar(0)
	@Beta1Size = new ReactiveVar(0)
	
	@Beta0Time = new ReactiveVar(0)
	@Beta1Time = new ReactiveVar(0)

	@adjustedTime = new ReactiveVar(0)
	@adjustedSize = new ReactiveVar(0)

	@descriptionTime = new ReactiveVar("")
	@descriptionSize = new ReactiveVar("")	

	@validProbeTime = new ReactiveVar(false)
	@validProbeSize = new ReactiveVar(false)


Template.PROBEC.helpers
	setData:()->
		totalProxy = 0
		totalAddedModifiedActualLOC = 0
		totalActualTime = 0
		projects = db.projects.find({"completed":true}).fetch()
		if projects.length>0
			_.each projects, (project)->
				unless project._id == FlowRouter.getParam("id")
					psProject = db.plan_summary.findOne({"projectId":project._id})?.total
					totalProxy += psProject?.proxyEstimated
					totalAddedModifiedActualLOC += (psProject?.actualAdd + psProject?.actualModified)
					totalActualTime += psProject?.totalTime
					
			newBetaSize1=(totalAddedModifiedActualLOC/totalProxy).toFixed(2)
			Template.instance().Beta1Size.set(newBetaSize1)

			newBetaTime1=(sys.timeToHours(totalActualTime)/totalProxy).toFixed(2)
			Template.instance().Beta1Time.set(newBetaTime1)

		
	GetTimeEstimationValues:()->
		return {"Beta0":Template.instance().Beta0Time.get(),"Beta1":Template.instance().Beta1Time.get()}

	GetSizeEstimationValues:()->
		return {"Beta0":Template.instance().Beta0Size.get(),"Beta1":Template.instance().Beta1Size.get()}

	AdjustedSize:()->
		psProject = db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total
		B0=Template.instance().Beta0Size.get()
		B1=Template.instance().Beta1Size.get()
		newsize = (B0+B1)*psProject?.proxyEstimated
		Template.instance().adjustedSize.set(newsize)
		return newsize

	AdjustedTime:()->
		psProject = db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total
		B0=Template.instance().Beta0Time.get()
		B1=Template.instance().Beta1Time.get()
		newTime = (B0+B1)*psProject?.proxyEstimated
		Template.instance().adjustedTime.set(newTime)
		return newTime
		
	DescriptionTime:()->
		projects = db.projects.find({"completed":true}).fetch()
		if projects.length >0
			b1 = Template.instance().Beta1Time.get()
			user = db.users.findOne({_id: Meteor.userId()})
			historicProductivity = (user.profile.sizeAmount.add+user.profile.sizeAmount.modified)/sys.timeToHours(user.profile.total.time)
			if (1/b1)>=(historicProductivity*0.30) and (1/b1)<=(historicProductivity*1.30)
				Template.instance().descriptionTime.set("PROBE C cumple con los requisitos necesarios, la pendiente de la linea se encuentra dentro de los límites")
				Template.instance().validProbeTime.set(true)
			else 
				Template.instance().descriptionTime.set("El valor de 1/Beta1 debe ser cercano a tu productividad histórica, el valor de 1/Beta1 es: " + 1/b1 + " y tu productividad histórica es: " + historicProductivity.toFixed(2) + "LOC/Hrs")
		else
			Template.instance().descriptionTime.set("No hay suficientes datos históricos")
		return Template.instance().descriptionTime.get()


	DescriptionSize:()->
		projects = db.projects.find({"completed":true}).fetch()
		if projects.length >0
			b1= Template.instance().Beta1Size.get()
			if b1<=2 and b1>=0
				Template.instance().descriptionSize.set("PROBE C cumple con los requisitos necesarios, la pendiente de la linea se encuentra dentro de los límites")
				Template.instance().validProbeSize.set(true)
			else
				Template.instance().descriptionSize.set("El valor de Beta 1 debe estar cerca a cero")

		else
			Template.instance().descriptionSize.set("No hay suficientes datos históricos")
		return Template.instance().descriptionSize.get()
	
	validTime:()->
		return Template.instance().validProbeTime.get()

	validSize:()->
		return Template.instance().validProbeSize.get()


Template.PROBEC.events
	'click .save-data-time': (e,t)->
		planSummary = db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total
		plannedProductivity = parseInt(planSummary?.estimatedAddedSize/Template.instance().adjustedTime.get())
		data= {
			"total.estimatedTime": sys.hoursToTime(Template.instance().adjustedTime.get())
			"total.productivityPlan" : plannedProductivity
			"probeTime":"C"
		}
		Meteor.call "update_plan_summary", FlowRouter.getParam("id"), data, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("error-project")
			else
				sys.flashStatus("save-project")
	'click .save-data-size': (e,t)->
		planSummary = db.plan_summary.findOne({"projectId":FlowRouter.getParam("id")})?.total
		if planSummary?.estimatedTime != 0
			plannedProductivity = parseInt(Template.instance().adjustedSize.get()/planSummary?.estimatedTime)
		else
			plannedProductivity = parseInt(planSummary?.productivityPlan)

		data= {
			"total.estimatedAddedSize" : parseInt(Template.instance().adjustedSize.get())
			"total.productivityPlan" : plannedProductivity
			"probeSize":"C"
		}
		Meteor.call "update_plan_summary", FlowRouter.getParam("id"), data, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("error-project")
			else
				sys.flashStatus("save-project")