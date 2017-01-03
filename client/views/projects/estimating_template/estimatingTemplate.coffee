Template.historicalData.onCreated () ->
	@historicalProjectsData = new ReactiveVar([])
	@autorun ->
		projects = db.projects.find({"completed":true}).fetch()
		data = []

		_.each projects, (project)->
			unless project._id == FlowRouter.getParam("id")
				psProject = db.plan_summary.findOne({"projectId":project._id})?.total
				#X is the proxy size for probe A and Planned added and modified
				data.push(
					{
						"Name":project.title
						"ProxyE":psProject?.proxyEstimated
						"ActualLOC": psProject?.actualAdd + psProject?.actualModified
						"EstimatedTime":psProject?.estimatedTime
						"ActualTime":psProject?.totalTime
						"PlanLOC":psProject?.estimatedAddedSize
					})

		Template.instance().historicalProjectsData.set(data)


Template.historicalData.helpers
	historicalProjects:()->
		return Template.instance().historicalProjectsData.get()
