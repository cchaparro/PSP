PQIMetrics = new ReactiveVar([])
PQIValue = new ReactiveVar(0)


drawPQIChart = (chart_width) ->
	planSummary = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})
	finalSize = planSummary?.total?.totalSize
	# CD: Calidad Diseño
	# CRD: Calidad Revisión Diseño
	# CC: Calidad Código
	# CRC: Calidad Revisión Código
	# CP: Calidad Programa
	TimeDesign = 0
	TimeCodification = 0
	TimeCodeRevision = 0
	TimeDesignRevision = 0
	TestDefects = 0
	CompilationDefects = 0

	timeStages = planSummary?.timeEstimated
	#Times in project to PQI
	_.each timeStages, (stage)->
		switch stage.name
			when 'Diseño'
				TimeDesign=stage.time
			when 'Revisión Diseño'			
				TimeDesignRevision=stage.time
			when 'Código'
				TimeCodification=stage.time
			when 'Revisión Código'
				TimeCodeRevision=stage.time
	defectStages = planSummary?.injectedEstimated
	#defects in stages
	_.each defectStages, (stage)->
		switch stage.name
			when 'Pruebas'
				TestDefects=stage.injected
			when 'Compilación'
				CompilationDefects=stage.injected
	CD = 0
	CRD = 0
	CC = 0
	CRC = 0
	CP = 0
	if TimeCodification!=0
		CD = TimeDesign/TimeCodification
		CRC = 2*(TimeCodeRevision/TimeCodification)
	if TimeDesign!=0
		CRD = 2*(TimeDesignRevision/TimeDesign)
	if finalSize!=0
		CC = 20/(10+(CompilationDefects/finalSize))	
		CP = 10/(5+(TestDefects/finalSize))
	valuesPQI = [
		{
			"alias":"CD"
			"name":"Calidad Diseño"
			"value":CD
		},
		{
			"alias":"CRD"
			"name":"Calidad Revisión Diseño"
			"value":CRD
		},
		{
			"alias":"CC"
			"name":"Calidad Código"
			"value":CC
			},
		{
			"alias":"CRC"
			"name":"Calidad Revisión Código"
			"value":CRC
			},
		{
			"alias":"CP"
			"name":"Calidad Programa"
			"value":CP
		}
	]
	PQIMetrics.set(valuesPQI)
	PQIValue.set(CD*CRD*CC*CRC*CP)
	#Chart data
	data = {
		labels: ["CD", "CRD", "CC", "CRC", "CP"],
		datasets: [
			{
				backgroundColor: "#FFFFFF"
				data: [CD, CRD, CC, CRC, CP]
			}
		]
	}
	options= {
		animation:false
		scale: {
			ticks: {
				beginAtZero: true
			}
        }
    }

	ctx = $('#projectPQIChart')?.get(0)?.getContext('2d')
	ctx?.canvas.width = chart_width
	ctx?.canvas.height = chart_width
	if ctx
		new Chart(ctx).Radar(data, options)


Template.pqiTemplate.onRendered () ->
	containerWidth = document.getElementById("pqi-information-chart").offsetWidth
	chartWidth = containerWidth - 20
	console.log chartWidth
	Deps.autorun ->
		drawPQIChart(chartWidth)


Template.pqiTemplate.helpers
	PQIValues: ()->
		return PQIMetrics.get()
	getPQI: ()->
		return PQIValue.get()