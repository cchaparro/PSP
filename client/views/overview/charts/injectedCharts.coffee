##########################################
#Average inverse function
overviewInjectedChart = () ->
	finishedProjects = db.projects.find({"projectOwner": Meteor.userId(), "completed": true}).fetch()
	colors = Meteor.settings.public.chartColors

	numberStages = 0

	#projectsTime saves the project injected values
	projectsInjected = []
	stagesLabel = []
	values = []

	if finishedProjects.length > 0
		_.each finishedProjects, (project)->
			projectSummary = db.plan_summary.findOne({projectId: project._id})
			projectsInjected.push(projectSummary.injectedEstimated)
			numberStages = projectSummary.injectedEstimated.length

		#Initialize arrays with the number of stages
		position = 0
		while position < numberStages
			values.push([])
			position+=1

		position = 0
		#Iteration that takes the time stage data from each completed project
		while position < projectsInjected.length
			projectData = projectsInjected[position]

			projectPosition = 0
			#Iteration that saves the chart x, y axis values
			while projectPosition < projectData.length
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
		InplanChart = [finalData[0]]
		IndisChart = [finalData[1]]
		IncodChart = [finalData[2]]
		IncompChart = [finalData[3]]
		InprubChart = [finalData[4]]
		InposChart = [finalData[5]]

		#Creation of all the stages chart overviews
		sys.overviewChart('InplanChart', InplanChart)
		sys.overviewChart('IndisChart', IndisChart)
		sys.overviewChart('IncodChart', IncodChart)
		sys.overviewChart('IncomChart', IncompChart)
		sys.overviewChart('InpruChart', InprubChart)
		sys.overviewChart('InposChart', InposChart)

##########################################
Template.injectedCharts.onRendered () ->
	@autorun ->
		overviewInjectedChart()

##########################################