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
				TimeDesign = sys.timeToHours(stage.time)
			when 'Revisión Diseño'			
				TimeDesignRevision = sys.timeToHours(stage.time)
			when 'Código'
				TimeCodification = sys.timeToHours(stage.time)
			when 'Revisión Código'
				TimeCodeRevision = sys.timeToHours(stage.time)

	defectStages = planSummary?.injectedEstimated
	#defects in stages
	_.each defectStages, (stage)->
		switch stage.name
			when 'Pruebas'
				TestDefects=stage.injected
			when 'Compilación'
				CompilationDefects=stage.injected
	CD = 1
	CRD = 1
	CC = 1
	CRC = 1
	CP = 1

	if TimeCodification!=0
		CD = TimeDesign/TimeCodification
		CRC = Math.min(2*(TimeCodeRevision/TimeCodification))

	if TimeDesign!=0
		CRD = Math.min(2*(TimeDesignRevision/TimeDesign),1)

	if finalSize!=0
		CC = Math.min(20/(10+((CompilationDefects*1000)/finalSize)),1)
		CP = Math.min(10/(5+((TestDefects*1000)/finalSize)),1)

	valuesPQI = [
		{
			"alias":"CD"
			"name":"Calidad Diseño"
			"value":CD.toFixed(2)
		},
		{
			"alias":"CRD"
			"name":"Calidad Revisión Diseño"
			"value":CRD.toFixed(2)
		},
		{
			"alias":"CC"
			"name":"Calidad Código"
			"value":CC.toFixed(2)
			},
		{
			"alias":"CRC"
			"name":"Calidad Revisión Código"
			"value":CRC.toFixed(2)
			},
		{
			"alias":"CP"
			"name":"Calidad Programa"
			"value":CP.toFixed(2)
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
				data: [CD.toFixed(2), CRD.toFixed(2), CC.toFixed(2), CRC.toFixed(2), CP.toFixed(2)]
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
	Deps.autorun ->
		drawPQIChart(chartWidth)


Template.pqiTemplate.helpers
	PQIValues: ()->
		return PQIMetrics.get()

	getPQI: ()->
		return PQIValue.get().toFixed(2)

	applyStyle:()->
		return PQIValue.get() < 0.5
