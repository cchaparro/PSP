##########################################
#Average inverse function
overviewRemovedChart = (chart_width) ->
	finishedProjects = db.projects.find({ projectOwner: Meteor.userId(), completed: true}, {sort: {completedAt: 1}}).fetch()
	colors = Meteor.settings.public.chartColors

	numberStages = 0

	#projectsTime saves the project timeEstimated values (stages time)
	projectsRemoved = []
	stagesLabel = []
	values = []

	if finishedProjects.length > 0
		_.each finishedProjects, (project)->
			planSummary = db.plan_summary.findOne({projectId: project._id})
			summaryData = planSummary?.removedEstimated

			if summaryData?.length <= 6
				summaryData.splice(2, 0, {"name": "Revisión Diseño", "removed": 0})
				summaryData.splice(4, 0, {"name": "Revisión Código", "removed": 0})

			projectsRemoved.push(planSummary?.removedEstimated)
			numberStages = planSummary?.removedEstimated?.length


		#Initialize arrays with the number of stages
		position = 0
		while position < numberStages
			values.push([])
			position+=1

		position = 0
		#Iteration that takes the time stage data from each completed project
		while position < projectsRemoved.length
			projectData = projectsRemoved[position]

			projectPosition = 0
			#Iteration that saves the chart x, y axis values
			while projectPosition < projectData.length
				stageData = projectData[projectPosition]
				stageRemoved = stageData.removed
				stageName = stageData.name

				data = {
					x: position + 1
					y: stageRemoved
				}

				values[projectPosition].push(data)
				stagesLabel.push(stageName)
				projectPosition+=1

			position+=1

		finalData = []
		_.each values, (value, position) ->
			data = {
				label: stagesLabel[position]
				strokeColor: colors[position]
				data: value
			}

			finalData.push(data)

		#Stages values, removed bugs
		RemplanningChart = 		[finalData[0]]
		RemdesignChart = 			[finalData[1]]
		RemreviewDesignChart = 	[finalData[2]]
		RemcodeChart = 			[finalData[3]]
		RemreviewCodeChart = 	[finalData[4]]
		RemcompilationChart = 	[finalData[5]]
		RemtestingChart = 		[finalData[6]]
		RempostmortemChart = 	[finalData[7]]

		#Creation of all the stages chart overviews
		sys.overviewChart('RemplanningChart', RemplanningChart, chart_width)
		sys.overviewChart('RemdesignChart', RemdesignChart, chart_width)
		sys.overviewChart('RemreviewDesignChart', RemreviewDesignChart, chart_width)
		sys.overviewChart('RemcodeChart', RemcodeChart, chart_width)
		sys.overviewChart('RemreviewCodeChart', RemreviewCodeChart, chart_width)
		sys.overviewChart('RemcompilationChart', RemcompilationChart, chart_width)
		sys.overviewChart('RemtestingChart', RemtestingChart, chart_width)
		sys.overviewChart('RempostmortemChart', RempostmortemChart, chart_width)

##########################################
Template.removedCharts.onRendered () ->
	containerWidth = document.getElementById("overview-chart").offsetWidth
	chartWidth = containerWidth
	Deps.autorun ->
		overviewRemovedChart(chartWidth)

##########################################