##########################################
#Average inverse function
overviewInjectedChart = (chart_width) ->
	finishedProjects = db.projects.find({ projectOwner: Meteor.userId(), completed: true}, {sort: {completedAt: 1}}).fetch()
	colors = Meteor.settings.public.chartColors

	numberStages = 0

	#projectsTime saves the project injected values
	projectsInjected = []
	stagesLabel = []
	values = []

	if finishedProjects?.length > 0
		_.each finishedProjects, (project)->
			projectSummary = db.plan_summary.findOne({projectId: project._id})
			summaryData = projectSummary?.injectedEstimated

			if summaryData?.length <= 6
				summaryData.splice(2, 0, {"name": "Revisión Diseño", "injected": 0})
				summaryData.splice(4, 0, {"name": "Revisión Código", "injected": 0})

			projectsInjected.push(projectSummary?.injectedEstimated)
			numberStages = projectSummary?.injectedEstimated?.length

		#Initialize arrays with the number of stages
		position = 0
		while position < numberStages
			values.push([])
			position+=1

		position = 0
		#Iteration that takes the time stage data from each completed project
		while position < projectsInjected?.length
			projectData = projectsInjected[position]

			projectPosition = 0
			#Iteration that saves the chart x, y axis values
			while projectPosition < projectData?.length
				stageData = projectData[projectPosition]
				stageInjected = stageData.injected
				stageName = stageData.name

				data = {
					x: position + 1
					y: stageInjected
				}

				values[projectPosition].push(data)
				stagesLabel.push(stageName)
				projectPosition+= 1

			position+= 1

		#This organizes the final data array for the charts
		finalData = []
		_.each values, (value, position) ->
			data = {
				label: stagesLabel[position]
				strokeColor: colors[position]
				data: value
			}

			finalData.push(data)

		#Stages values, injected bugs
		InplanningChart = 		[finalData[0]]
		IndesignChart = 			[finalData[1]]
		InreviewDesignChart = 	[finalData[2]]
		IncodeChart = 				[finalData[3]]
		InreviewCodeChart = 		[finalData[4]]
		IncompilationChart = 	[finalData[5]]
		IntestingChart = 			[finalData[6]]
		InpostmortemChart = 		[finalData[7]]

		#Creation of all the stages chart overviews
		sys.overviewChart('InplanningChart', InplanningChart, chart_width)
		sys.overviewChart('IndesignChart', IndesignChart, chart_width)
		sys.overviewChart('InreviewDesignChart', InreviewDesignChart, chart_width)
		sys.overviewChart('IncodeChart', IncodeChart, chart_width)
		sys.overviewChart('InreviewCodeChart', InreviewCodeChart, chart_width)
		sys.overviewChart('IncompilationChart', IncompilationChart, chart_width)
		sys.overviewChart('IntestingChart', IntestingChart, chart_width)
		sys.overviewChart('InpostmortemChart', InpostmortemChart, chart_width)

##########################################
Template.injectedCharts.onRendered () ->
	containerWidth = document.getElementById("overview-chart").offsetWidth
	chartWidth = containerWidth
	Deps.autorun ->
		overviewInjectedChart(chartWidth)

##########################################