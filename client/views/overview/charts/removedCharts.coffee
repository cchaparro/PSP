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

	#Removed bug chart Context
	c1 = document.getElementById('ReplanChart')?.getContext('2d')
	c1?.canvas.width = 400
	c1?.canvas.height = 200
	c2 = document.getElementById('RedisChart')?.getContext('2d')
	c2?.canvas.width = 400
	c2?.canvas.height = 200
	c3 = document.getElementById('RecodChart')?.getContext('2d')
	c3?.canvas.width = 400
	c3?.canvas.height = 200
	c4 = document.getElementById('RecomChart')?.getContext('2d')
	c4?.canvas.width = 400
	c4?.canvas.height = 200
	c5 = document.getElementById('RepruChart')?.getContext('2d')
	c5?.canvas.width = 400
	c5?.canvas.height = 200
	c6 = document.getElementById('ReposChart')?.getContext('2d')
	c6?.canvas.width = 400
	c6?.canvas.height = 200

	#Chart properties, injected bugs
	myLineChartT = new Chart(c1).Scatter(ReplanChart,
		animation : false
		bezierCurve: true
		showTooltips: true
		scaleShowHorizontalLines: true
		scaleShowLabels: true
		scaleLabel: '<%=value%>'
		scaleArgLabel: '<%=value%>'
		emptyDataMessage: "No hay datos para graficar"
		scaleBeginAtZero: true
	)

	myLineChartI = new Chart(c2).Scatter(RedisChart,
		animation : false
		bezierCurve: true
		showTooltips: true
		scaleShowHorizontalLines: true
		scaleShowLabels: true
		scaleLabel: '<%=value%>'
		scaleArgLabel: '<%=value%>'
		emptyDataMessage: "No hay datos para graficar"
		scaleBeginAtZero: true
	)

	myLineChartR = new Chart(c3).Scatter(RecodChart,
		animation : false
		bezierCurve: true
		showTooltips: true
		scaleShowHorizontalLines: true
		scaleShowLabels: true
		scaleLabel: '<%=value%>'
		scaleArgLabel: '<%=value%>'
		emptyDataMessage: "No hay datos para graficar"
		scaleBeginAtZero: true
	)

	myLineChartR = new Chart(c4).Scatter(RecompChart,
		animation : false
		bezierCurve: true
		showTooltips: true
		scaleShowHorizontalLines: true
		scaleShowLabels: true
		scaleLabel: '<%=value%>'
		scaleArgLabel: '<%=value%>'
		emptyDataMessage: "No hay datos para graficar"
		scaleBeginAtZero: true
	)

	myLineChartR = new Chart(c5).Scatter(ReprubChart,
		animation : false
		bezierCurve: true
		showTooltips: true
		scaleShowHorizontalLines: true
		scaleShowLabels: true
		scaleLabel: '<%=value%>'
		scaleArgLabel: '<%=value%>'
		emptyDataMessage: "No hay datos para graficar"
		scaleBeginAtZero: true
	)

	myLineChartR = new Chart(c6).Scatter(ReposChart,
		animation : false
		bezierCurve: true
		showTooltips: true
		scaleShowHorizontalLines: true
		scaleShowLabels: true
		scaleLabel: '<%=value%>'
		scaleArgLabel: '<%=value%>'
		emptyDataMessage: "No hay datos para graficar"
		scaleBeginAtZero: true
	)

##########################################
Template.removedCharts.onRendered () ->
	@autorun ->
		overviewRemovedChart()

##########################################