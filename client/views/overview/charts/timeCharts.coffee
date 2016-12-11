##########################################
overviewTimeChart = () ->
	userId = Meteor.userId()
	finishedProjects = db.projects.find({ projectOwner: userId, completed: true}).fetch()
	colors = Meteor.settings.public.chartColors

	amountStages = 6 #TODO it should be 8

	#projectsTime saves the project timeEstimated values (stages time)
	projectsTime = []
	stagesLabel = []
	values = []

	if finishedProjects.length > 0
		_.each finishedProjects, (project)->
			projectSummary = db.plan_summary.findOne({ projectId: project._id })
			projectsTime.push(projectSummary?.timeEstimated)

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

				data = {
					x: position + 1
					y: Math.ceil(stageTime / 60000)
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
		codeChart = [finalData[2]]
		compilationChart = [finalData[3]]
		testingChart = [finalData[4]]
		postmortemChart = [finalData[5]]

		#Creation of all the stages chart overviews
		sys.overviewChart('planChart', planningChart)
		sys.overviewChart('disChart', designChart)
		sys.overviewChart('codChart', codeChart)
		sys.overviewChart('comChart', compilationChart)
		sys.overviewChart('pruChart', testingChart)
		sys.overviewChart('posChart', postmortemChart)

##########################################
Template.timeCharts.onRendered () ->
	@autorun ->
		overviewTimeChart()

##########################################