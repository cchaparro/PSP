##########################################
#Average inverse function
overviewInjectedChart = () ->
	finishedProjects = db.projects.find({"projectOwner": Meteor.userId(), "completed": true}).fetch()
	colors = Meteor.settings.public.chartColors

	projectsInjected = [] #Defects Injected
	InplanChart = []
	IndisChart = []
	IncodChart = []
	IncompChart = []
	InprubChart = []
	InposChart = []
	numberStages = 0

	if finishedProjects.length > 0
		_.each finishedProjects, (project)->
			projectSummary = db.plan_summary.findOne({"summaryOwner": Meteor.userId(), "projectId":project._id})
			projectsInjected.push(projectSummary.injectedEstimated)
			numberStages = projectSummary.injectedEstimated.length

		valuesInjected = []
		stagesLabel = []

		#Initialize arrays with the number of stages
		iterator = 0
		while iterator < numberStages
			valuesInjected.push([])
			iterator+=1

		#Finished projects iterator
		projectNumber = 0

		while projectNumber < projectsInjected.length
			prjI = projectsInjected[projectNumber]
			valuePos = 0
			projectStage = 0
			#Stage per project
			while projectStage < prjI.length
				#Defects Injected per stage
				sPrjI = prjI[projectStage]
				valuesInjected[projectStage].push({x:projectNumber+1,y:sPrjI.injected})
				stagesLabel.push(sPrjI.name)
				projectStage+=1
			projectNumber+=1

		dataInjected = []
		#Draw a line per stage, Defects injected Chart data
		stage_position = 0
		_.each valuesInjected, (v)->
			dataInjected.push({label: stagesLabel[stage_position],strokeColor: colors[stage_position],data:v})
			stage_position+=1

		#Stages values, injected bugs
		InplanChart = [dataInjected[0]]
		IndisChart = [dataInjected[1]]
		IncodChart = [dataInjected[2]]
		IncompChart = [dataInjected[3]]
		InprubChart = [dataInjected[4]]
		InposChart = [dataInjected[5]]

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