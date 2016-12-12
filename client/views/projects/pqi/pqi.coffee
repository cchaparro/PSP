
drawPQIChart = ()->
	data = {
		labels: ["CD", "CRD", "CC", "CRC", "CP"],
		datasets: [
			{
				backgroundColor: "#4283f4"
				data: [65, 59, 70, 70, 56]
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
	ctx?.canvas.width = 400
	ctx?.canvas.height = 400
	if ctx
		new Chart(ctx).Radar(data, options)

Template.pqiTemplate.onRendered () ->
	Deps.autorun ->
		drawPQIChart()