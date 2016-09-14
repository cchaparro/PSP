##########################################
#Average inverse function
invAverage = (x,numPr) ->
	return x * numPr

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
#   #Initialize arrays with the number of stages
#   iterator = 0
#   while iterator < numberStages
#   	valuesTime.push([])
#   	iterator+=1
#   	i = 0
#   	while i < projectsTime.length
#   		prjT = projectsTime[i]
#   		valuePos = 0
#   		j = 0
#     #Stage per project
#     while j < prjT.length
#       #Time per stage
#       sPrjT = prjT[j]
#       #i is number of the project
#       valuesTime[j].push({x:i+1,y:timeToMinutes(sPrjT.time)})
#       stagesLabel.push(sPrjT.name)
#       j+=1
#       i+=1
#       dataTime = []
#   #Draw a line per stage, Time Chart data
#   color_position = 0
#   _.each valuesTime, (v)->
#   	dataTime.push({label: stagesLabel[color_position],strokeColor: colors[color_position],data:v})
#   	color_position+=1
#   #Stages values, time stages
#   planChart = [dataTime[0]]
#   disChart = [dataTime[1]]
#   codChart = [dataTime[2]]
#   compChart = [dataTime[3]]
#   prubChart = [dataTime[4]]
#   posChart = [dataTime[5]]
# #Context for each chart,Time Stages
# c1 = document.getElementById('planChart').getContext('2d')
# c2 = document.getElementById('disChart').getContext('2d')
# c3 = document.getElementById('codChart').getContext('2d')
# c4 = document.getElementById('comChart').getContext('2d')
# c5 = document.getElementById('pruChart').getContext('2d')
# c6 = document.getElementById('posChart').getContext('2d')
# #Chart properties, Time Stages
# myLineChartT = new Chart(c1).Scatter(planChart,
# 	bezierCurve: true
# 	showTooltips: true
# 	scaleShowHorizontalLines: true
# 	scaleShowLabels: true
# 	scaleLabel: '<%=value%>'
# 	scaleArgLabel: '<%=value%>'
# 	emptyDataMessage: "No hay datos para graficar"
# 	scaleBeginAtZero: true)

# myLineChartI = new Chart(c2).Scatter(disChart,
# 	bezierCurve: true
# 	showTooltips: true
# 	scaleShowHorizontalLines: true
# 	scaleShowLabels: true
# 	scaleLabel: '<%=value%>'
# 	scaleArgLabel: '<%=value%>'
# 	emptyDataMessage: "No hay datos para graficar"
# 	scaleBeginAtZero: true)

# myLineChartR = new Chart(c3).Scatter(codChart,
# 	bezierCurve: true
# 	showTooltips: true
# 	scaleShowHorizontalLines: true
# 	scaleShowLabels: true
# 	scaleLabel: '<%=value%>'
# 	scaleArgLabel: '<%=value%>'
# 	emptyDataMessage: "No hay datos para graficar"
# 	scaleBeginAtZero: true)

# myLineChartR = new Chart(c4).Scatter(compChart,
# 	bezierCurve: true
# 	showTooltips: true
# 	scaleShowHorizontalLines: true
# 	scaleShowLabels: true
# 	scaleLabel: '<%=value%>'
# 	scaleArgLabel: '<%=value%>'
# 	emptyDataMessage: "No hay datos para graficar"
# 	scaleBeginAtZero: true)

# myLineChartR = new Chart(c5).Scatter(prubChart,
# 	bezierCurve: true
# 	showTooltips: true
# 	scaleShowHorizontalLines: true
# 	scaleShowLabels: true
# 	scaleLabel: '<%=value%>'
# 	scaleArgLabel: '<%=value%>'
# 	emptyDataMessage: "No hay datos para graficar"
# 	scaleBeginAtZero: true)

# myLineChartR = new Chart(c6).Scatter(posChart,
# 	bezierCurve: true
# 	showTooltips: true
# 	scaleShowHorizontalLines: true
# 	scaleShowLabels: true
# 	scaleLabel: '<%=value%>'
# 	scaleArgLabel: '<%=value%>'
# 	emptyDataMessage: "No hay datos para graficar"
# 	scaleBeginAtZero: true)

##########################################
Template.timeCharts.onRendered () ->
	Deps.autorun ->
		overviewTimeChart()

##########################################