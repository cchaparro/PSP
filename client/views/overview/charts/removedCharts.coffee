##########################################
#Average inverse function
overviewRemovedChart = () ->
	finishedProjects = db.projects.find({"projectOwner": Meteor.userId(), "completed": true}).fetch()
	colors = Meteor.settings.public.chartColors

	numberStages = 0

	#projectsTime saves the project timeEstimated values (stages time)
	projectsRemoved = []
	stagesLabel = []
	values = []

	if finishedProjects.length > 0
		_.each finishedProjects, (project)->
			planSummary = db.plan_summary.findOne({projectId: project._id})
			projectsRemoved.push(planSummary.removedEstimated)
			numberStages = planSummary.removedEstimated.length

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
		ReplanChart = [finalData[0]]
		RedisChart = [finalData[1]]
		RecodChart = [finalData[2]]
		RecompChart = [finalData[3]]
		ReprubChart = [finalData[4]]
		ReposChart = [finalData[5]]

		#Creation of all the stages chart overviews
		sys.overviewChart('ReplanChart', ReplanChart)
		sys.overviewChart('RedisChart', RedisChart)
		sys.overviewChart('RecodChart', RecodChart)
		sys.overviewChart('RecomChart', RecompChart)
		sys.overviewChart('RepruChart', ReprubChart)
		sys.overviewChart('ReposChart', ReposChart)

##########################################
Template.removedCharts.onRendered () ->
	@autorun ->
		overviewRemovedChart()

##########################################