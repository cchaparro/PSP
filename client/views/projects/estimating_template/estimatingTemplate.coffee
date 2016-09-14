Template.historicalData.onCreated () ->
	@historicalProjectsData = new ReactiveVar([])
	@totalProxy = new ReactiveVar(0)
	@totalActualLOC = new ReactiveVar(0)
	@totalEstimatedTime = new ReactiveVar(0)
	@totalActualTime = new ReactiveVar(0)
	@squareTotalSize = new ReactiveVar(0)
	@squareTotalProxy = new ReactiveVar(0)
	@TotalXYA = new ReactiveVar(0) #PROBE A X * Y
	@TotalXYB = new ReactiveVar(0) #PROBE B X * Y
	@squareTotalTimeActual = new ReactiveVar(0)

Template.historicalData.helpers
	gethistoricalProjects:()->
		totalProxy = 0
		totalActualLOC = 0
		totalEstimatedTime = 0
		totalActualTime = 0
		squareTotalSize = 0
		squareTotalProxy = 0
		TotalXYA = 0
		TotalXYB = 0
		squareTotalTimeActual = 0
		projects = db.projects.find({"completed":true}).fetch()
		data = []
		_.each projects, (project)->
			unless project._id == FlowRouter.getParam("id")
				psProject = db.plan_summary.findOne({"projectId":project._id})

				totalProxy += psProject.total.estimatedAdd + psProject.total.estimatedModified 
				totalActualLOC += psProject.ActualLOC
				totalEstimatedTime += psProject.EstimatedTime
				totalActualTime += psProject.ActualTime
				squareTotalSize += Math.pow(psProject.total.actualAdd + psProject.total.actualModified,2)
				squareTotalProxy += Math.pow(psProject.total.estimatedAdd + psProject.total.estimatedModified,2)
				TotalXYA += (psProject.total.estimatedAdd + psProject.total.estimatedModified)*psProject.total.totalTime
				TotalXYB += (psProject.total.estimatedAdd + psProject.total.estimatedModified)*(psProject.total.actualAdd + psProject.total.actualModified)
				squareTotalTimeActual += Math.pow(psProject.total.totalTime,2)
				#X is the proxy size for probe A and Planned added and modified 
				data.push({"Name":project.title, "Proxy":psProject.total.estimatedAdd + psProject.total.estimatedModified, "ActualLOC": psProject.total.actualAdd + psProject.total.actualModified, "EstimatedTime":psProject.total.estimatedTime, "ActualTime":psProject.total.totalTime,"PROBEA":(psProject.total.estimatedAdd + psProject.total.estimatedModified)*psProject.total.totalTime, "PROBEB":(psProject.total.estimatedAdd + psProject.total.estimatedModified)*(psProject.total.actualAdd + psProject.total.actualModified)})
		Template.instance().totalProxy.set(totalProxy)
		Template.instance().totalActualLOC.set(totalActualLOC)
		Template.instance().totalEstimatedTime.set(totalEstimatedTime)
		Template.instance().totalActualTime.set(totalActualTime)
		Template.instance().squareTotalSize.set(squareTotalSize)
		Template.instance().squareTotalProxy.set(squareTotalProxy)
		Template.instance().historicalProjectsData.set(data)
		console.log data
	historicalProjects:()->
		return Template.instance().historicalProjectsData.get()
	detailValues:()->
		data = Template.instance().historicalProjectsData.get()
		returnData = []		

		_.each data,(d)->


		return totals
	ProxyAverage:()->
		return Template.instance().totalProxy.get()/Template.instance().historicalProjectsData.get().length
	ActualLOCAverage:()->
		return Template.instance().totalActualLOC.get()/Template.instance().historicalProjectsData.get().length
	ActualTimeAverage:()->
		return Template.instance().totalActualTime.get()/Template.instance().historicalProjectsData.get().length
