##########################################
#Average inverse function
overviewRemovedChart = () ->
	finishedProjects = db.projects.find({"projectOwner": Meteor.userId(), "completed": true}).fetch()
	colors = Meteor.settings.public.chartColors

	projectsRemoved = [] #Defects removed
	numberStages = 0
	ReplanChart = []
	RedisChart = []
	RecodChart = []
	RecompChart = []
	ReprubChart = []
	ReposChart = []

	if finishedProjects.length > 0
		_.each finishedProjects, (project)->
			planSummary = db.plan_summary.findOne({"summaryOwner": Meteor.userId(), "projectId":project._id})
			projectsRemoved.push(planSummary.removedEstimated)
			numberStages=planSummary.timeEstimated.length

		valuesRemoved = []
		stagesLabel = []
		#Initialize arrays with the number of stages
		iterator = 0
		while iterator < numberStages
			valuesRemoved.push([])
			iterator+=1
		projectNumber = 0

		while projectNumber < projectsRemoved.length
			prjR = projectsRemoved[projectNumber]
			valuePos = 0
			projectStage = 0
			#Stage per project
			while projectStage < prjR.length
				#Defects removed per stage
				sPrjR = prjR[projectStage]
				#i is the number of the project
				valuesRemoved[projectStage].push({x:projectNumber+1,y:sPrjR.removed})
				stagesLabel.push(sPrjR.name)
				projectStage+=1
			projectNumber+=1

		dataRemoved = []
		#Draw a line per stage, Defects injected Chart data
		stage_position = 0
		_.each valuesRemoved, (v)->
			dataRemoved.push({label:stagesLabel[stage_position],strokeColor: colors[stage_position],data:v})
			stage_position+=1

		#Stages values, removed bugs
		ReplanChart = [dataRemoved[0]]
		RedisChart = [dataRemoved[1]]
		RecodChart = [dataRemoved[2]]
		RecompChart = [dataRemoved[3]]
		ReprubChart = [dataRemoved[4]]
		ReposChart = [dataRemoved[5]]

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