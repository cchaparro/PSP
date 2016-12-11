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

	#Injected bug chart Context
	c1 = document.getElementById('InplanChart')?.getContext('2d')
	c1?.canvas.width = 400
	c1?.canvas.height = 200
	c2 = document.getElementById('IndisChart')?.getContext('2d')
	c2?.canvas.width = 400
	c2?.canvas.height = 200
	c3 = document.getElementById('IncodChart')?.getContext('2d')
	c3?.canvas.width = 400
	c3?.canvas.height = 200
	c4 = document.getElementById('IncomChart')?.getContext('2d')
	c4?.canvas.width = 400
	c4?.canvas.height = 200
	c5 = document.getElementById('InpruChart')?.getContext('2d')
	c5?.canvas.width = 400
	c5?.canvas.height = 200
	c6 = document.getElementById('InposChart')?.getContext('2d')
	c6?.canvas.width = 400
	c6?.canvas.height = 200

	#Chart properties, injected bugs
	myLineChartT = new Chart(c1).Scatter(InplanChart,
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

	myLineChartI = new Chart(c2).Scatter(IndisChart,
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

	myLineChartR = new Chart(c3).Scatter(IncodChart,
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

	myLineChartR = new Chart(c4).Scatter(IncompChart,
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

	myLineChartR = new Chart(c5).Scatter(InprubChart,
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

	myLineChartR = new Chart(c6).Scatter(InposChart,
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
Template.injectedCharts.onRendered () ->
	@autorun ->
		overviewInjectedChart()

##########################################