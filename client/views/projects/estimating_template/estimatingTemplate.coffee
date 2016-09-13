Template.historicalData.helpers
	historicalProjects:()->
		projects = db.projects.find().fetch()
		data = []
		console.log projects
		_.each projects, (project)->
			psProject = db.plan_summary.findOne({"projectId":project._id})
			data.push({"Name":project.title, "Proxy":psProject.total.estimatedAdd + psProject.total.estimatedModified, "ActualLOC": psProject.total.actualAdd + psProject.total.actualModified, "EstimatedTime":psProject.total.estimatedTime, "ActualTime":psProject.total.totalTime})
		console.log data
		return data
		