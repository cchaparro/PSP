##########################################
overviewTimeChart = () ->
	userId = Meteor.userId()
	finishedProjects = db.projects.find({ projectOwner: userId, completed: true}, {sort: {completedAt: 1}}).fetch()
	colors = Meteor.settings.public.chartColors

	amountStages = 0 #TODO it should be 8

	#projectsTime saves the project timeEstimated values (stages time)
	projectsTime = []
	stagesLabel = []
	values = []

	if finishedProjects.length > 0
		_.each finishedProjects, (project)->
			projectSummary = db.plan_summary.findOne({ projectId: project._id })
			summaryData = projectSummary?.timeEstimated

			if summaryData?.length <= 6
				summaryData.splice(2, 0, {"name": "Revisión Diseño", "time": 0})
				summaryData.splice(4, 0, {"name": "Revisión Código", "time": 0})

			projectsTime.push(projectSummary?.timeEstimated)
			amountStages = projectSummary?.timeEstimated?.length

		#Initialize arrays with the number of stages
		position = 0
		while position < amountStages
			values.push([])
			position+= 1

		position = 0
		#Iteration that takes the time stage data from each completed project
		while position < projectsTime.length
			projectData = projectsTime[position]

			projectPosition = 0
			#Iteration that saves the chart x, y axis values
			while projectPosition < projectData.length
				stageData = projectData[projectPosition]
				stageTime = stageData.time
				stageName = stageData.name

				if stageTime == 0
					stageTimeMinutes = 0
				else
					stageTimeMinutes = Math.ceil(stageTime / 60000)

				data = {
					x: position + 1
					y: stageTimeMinutes
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


		planningChart = [finalData[0]]
		designChart = [finalData[1]]
		reviewDesignChart = [finalData[2]]
		codeChart = [finalData[3]]
		reviewCodeChart = [finalData[4]]
		compilationChart = [finalData[5]]
		testingChart = [finalData[6]]
		postmortemChart = [finalData[7]]

		#Creation of all the stages chart overviews
		sys.overviewChart('planningChart', planningChart)
		sys.overviewChart('designChart', designChart)
		sys.overviewChart('reviewDesignChart', reviewDesignChart)
		sys.overviewChart('codeChart', codeChart)
		sys.overviewChart('reviewCodeChart', reviewCodeChart)
		sys.overviewChart('compilationChart', compilationChart)
		sys.overviewChart('testingChart', testingChart)
		sys.overviewChart('postmortemChart', postmortemChart)

##########################################
Template.timeCharts.onRendered () ->
	@autorun ->
		overviewTimeChart()

##########################################