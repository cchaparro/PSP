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
Template.PROBEC.helpers
	setData:()->
		totalProxy = 0
		totalAddedModifiedActualLOC = 0
		totalActualTime = 0
		projects = db.projects.find({"completed":true}).fetch()
		_.each projects, (project)->
			unless project._id == FlowRouter.getParam("id")
				psProject = db.plan_summary.findOne({"projectId":project._id})?.total
				totalProxy += psProject.proxyEstimated
				totalAddedModifiedActualLOC += (psProject.actualAdd + psProject.actualModified)
				totalActualTime += psProject.totalTime
				
		newBetaSize1=(totalAddedModifiedActualLOC/totalProxy).toFixed(2)
		Template.instance().Beta1Size.set(newBetaSize1)

		newBetaTime1=(sys.timeToMinutes(totalActualTime)/totalProxy).toFixed(2)
		Template.instance().Beta1Time.set(newBetaTime1)

		
	GetTimeEstimationValues:()->
		return {"Beta0":Template.instance().Beta0Time.get(),"Beta1":Template.instance().Beta1Time.get()}

	GetSizeEstimationValues:()->
		return {"Beta0":Template.instance().Beta0Size.get(),"Beta1":Template.instance().Beta1Size.get()}

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
Template.PROBEC.events
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