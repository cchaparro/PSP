##########################################
timeToMinutes = (time) ->
	return Math.ceil(time / 60000)

overviewTimeChart = () ->
	#finished projects ids
	finishedProjects = db.projects.find({"projectOwner":Meteor.userId(),"completed":true}).fetch()
	colors = Meteor.settings.public.chartColors

	projectsTime = [] #Time
	planChart = []
	disChart = []
	codChart = []
	compChart = []
	prubChart = []
	posChart = []

	numberStages=0
	if finishedProjects.length > 0
		_.each finishedProjects, (project)->
			projectSummary = db.plan_summary.findOne({ "projectId": project._id })
			projectsTime.push(projectSummary?.timeEstimated)
			numberStages = projectSummary?.timeEstimated.length

		valuesTime = []
		stagesLabel = []

		#Initialize arrays with the number of stages
		iterator = 0
		while iterator < numberStages
			valuesTime.push([])
			iterator+=1
		i = 0

		while i < projectsTime.length
			prjT = projectsTime[i]
			valuePos = 0
			j = 0
			#Stage per project
			while j < prjT.length
				#Time per stage
				sPrjT = prjT[j]
				#i is number of the project
				valuesTime[j].push({x:i+1,y:timeToMinutes(sPrjT.time)})
				stagesLabel.push(sPrjT.name)
				j+=1
			i+=1


		dataTime = []
		#Draw a line per stage, Time Chart data
		color_position = 0
		_.each valuesTime, (value)->
			dataTime.push({label: stagesLabel[color_position],strokeColor: colors[color_position],data:value})
			color_position += 1

		#Stages values, time stages
		planChart = [dataTime[0]]
		disChart = [dataTime[1]]
		codChart = [dataTime[2]]
		compChart = [dataTime[3]]
		prubChart = [dataTime[4]]
		posChart = [dataTime[5]]

	#Context for each chart,Time Stages
	c1 = document.getElementById('planChart')?.getContext('2d')
	c1?.canvas.width = 400
	c1?.canvas.height = 200
	c2 = document.getElementById('disChart')?.getContext('2d')
	c2?.canvas.width = 400
	c2?.canvas.height = 200
	c3 = document.getElementById('codChart').getContext('2d')
	c3?.canvas.width = 400
	c3?.canvas.height = 200
	c4 = document.getElementById('comChart').getContext('2d')
	c4?.canvas.width = 400
	c4?.canvas.height = 200
	c5 = document.getElementById('pruChart').getContext('2d')
	c5?.canvas.width = 400
	c5?.canvas.height = 200
	c6 = document.getElementById('posChart').getContext('2d')
	c6?.canvas.width = 400
	c6?.canvas.height = 200

	#Chart properties, Time Stages
	myLineChartT = new Chart(c1).Scatter(planChart,
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

	myLineChartI = new Chart(c2).Scatter(disChart,
		animation : false
		bezierCurve: true
		showTooltips: true
		scaleShowHorizontalLines: true
		scaleShowLabels: true
		scaleLabel: '<%=value%>'
		scaleArgLabel: '<%=value%>'
		emptyDataMessage: "No hay datos para graficar"
		scaleBeginAtZero: true)

	myLineChartR = new Chart(c3).Scatter(codChart,
		animation : false
		bezierCurve: true
		showTooltips: true
		scaleShowHorizontalLines: true
		scaleShowLabels: true
		scaleLabel: '<%=value%>'
		scaleArgLabel: '<%=value%>'
		emptyDataMessage: "No hay datos para graficar"
		scaleBeginAtZero: true)

	myLineChartR = new Chart(c4).Scatter(compChart,
		animation : false
		bezierCurve: true
		showTooltips: true
		scaleShowHorizontalLines: true
		scaleShowLabels: true
		scaleLabel: '<%=value%>'
		scaleArgLabel: '<%=value%>'
		emptyDataMessage: "No hay datos para graficar"
		scaleBeginAtZero: true)

	myLineChartR = new Chart(c5).Scatter(prubChart,
		animation : false
		bezierCurve: true
		showTooltips: true
		scaleShowHorizontalLines: true
		scaleShowLabels: true
		scaleLabel: '<%=value%>'
		scaleArgLabel: '<%=value%>'
		emptyDataMessage: "No hay datos para graficar"
		scaleBeginAtZero: true)

	myLineChartR = new Chart(c6).Scatter(posChart,
		animation : false
		bezierCurve: true
		showTooltips: true
		scaleShowHorizontalLines: true
		scaleShowLabels: true
		scaleLabel: '<%=value%>'
		scaleArgLabel: '<%=value%>'
		emptyDataMessage: "No hay datos para graficar"
		scaleBeginAtZero: true)

##########################################
Template.timeCharts.onRendered () ->
	@autorun ->
		overviewTimeChart()

##########################################