#Average inverse function
invAverage = (x,numPr) ->
  return x*numPr
drawChart = () ->
  #finished projects ids
  finishedProjects = db.projects.find({"projectOwner":Meteor.userId(),"completed":true,"levelPSP":"PSP 0"}).fetch()
  colors = Meteor.settings.public.chartColors
  projectsInjected=[] #Defects Injected
  numberStages=0
  _.each finishedProjects, (f)->
    itQuery = db.plan_summary.findOne({"summaryOwner": Meteor.userId(), "projectId":f._id})
    projectsInjected.push(itQuery.injectedEstimated)
    numberStages=itQuery.injectedEstimated.length
  valuesInjected = []
  stagesLabel = []
  #Initialize arrays with the number of stages
  iterator = 0
  while iterator < numberStages
    valuesInjected.push([])
    iterator+=1
  i = 0
  while i < projectsInjected.length
    prjI = projectsInjected[i]
    valuePos = 0
    j = 0
    #Stage per project
    while j < prjI.length
      #Defects Injected per stage
      sPrjI = prjI[j]
      #i is the number of the project
      valuesInjected[j].push({x:i+1,y:sPrjI.toDate})
      stagesLabel.push(sPrjI.name)
      j+=1
    i+=1
  dataInjected = []
  #Draw a line per stage, Defects injected Chart data
  color_position = 0
  _.each valuesInjected, (v)->
    dataInjected.push({label: stagesLabel[color_position],strokeColor: colors[color_position],data:v})
    color_position+=1


  #Stages values, injected bugs
  InplanChart = [dataInjected[0]]
  IndisChart = [dataInjected[1]]
  IncodChart = [dataInjected[2]]
  IncompChart = [dataInjected[3]]
  InprubChart = [dataInjected[4]]
  InposChart = [dataInjected[5]]

  #Injected bug chart Context
  c1 = document.getElementById('InplanChart').getContext('2d')
  c2 = document.getElementById('IndisChart').getContext('2d')
  c3 = document.getElementById('IncodChart').getContext('2d')
  c4 = document.getElementById('IncomChart').getContext('2d')
  c5 = document.getElementById('InpruChart').getContext('2d')
  c6 = document.getElementById('InposChart').getContext('2d')

  #Chart properties, injected bugs
  myLineChartT = new Chart(c1).Scatter(InplanChart,
    bezierCurve: true
    showTooltips: true
    scaleShowHorizontalLines: true
    scaleShowLabels: true
    scaleLabel: '<%=value%>'
    scaleArgLabel: '<%=value%>'
    emptyDataMessage: "No hay datos para graficar"
    scaleBeginAtZero: true)

  myLineChartI = new Chart(c2).Scatter(IndisChart,
    bezierCurve: true
    showTooltips: true
    scaleShowHorizontalLines: true
    scaleShowLabels: true
    scaleLabel: '<%=value%>'
    scaleArgLabel: '<%=value%>'
    emptyDataMessage: "No hay datos para graficar"
    scaleBeginAtZero: true)

  myLineChartR = new Chart(c3).Scatter(IncodChart,
    bezierCurve: true
    showTooltips: true
    scaleShowHorizontalLines: true
    scaleShowLabels: true
    scaleLabel: '<%=value%>'
    scaleArgLabel: '<%=value%>'
    emptyDataMessage: "No hay datos para graficar"
    scaleBeginAtZero: true)

  myLineChartR = new Chart(c4).Scatter(IncompChart,
    bezierCurve: true
    showTooltips: true
    scaleShowHorizontalLines: true
    scaleShowLabels: true
    scaleLabel: '<%=value%>'
    scaleArgLabel: '<%=value%>'
    emptyDataMessage: "No hay datos para graficar"
    scaleBeginAtZero: true)

  myLineChartR = new Chart(c5).Scatter(InprubChart,
    bezierCurve: true
    showTooltips: true
    scaleShowHorizontalLines: true
    scaleShowLabels: true
    scaleLabel: '<%=value%>'
    scaleArgLabel: '<%=value%>'
    emptyDataMessage: "No hay datos para graficar"
    scaleBeginAtZero: true)

  myLineChartR = new Chart(c6).Scatter(InposChart,
    bezierCurve: true
    showTooltips: true
    scaleShowHorizontalLines: true
    scaleShowLabels: true
    scaleLabel: '<%=value%>'
    scaleArgLabel: '<%=value%>'
    emptyDataMessage: "No hay datos para graficar"
    scaleBeginAtZero: true)


Template.injectedCharts.onRendered ->
  Meteor.subscribe "chartStages"
  drawChart()