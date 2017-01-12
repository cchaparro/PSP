##########################################
@sys = {}
##########################################
##########- General Functions -###########

sys.isEmail = (email) ->
	filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/
	return filter.test(email)

sys.isValidPassword = (password) ->
	if password.length < 6
		return false
	return true

sys.isNumber = (number) ->
	filter = /^\d*(?:\.\d{1,2})?$/
	return filter.test(number)

##########################################
###############- Page Name -##############
sys.getPageName = (title) ->
	if title == 'privateRoute.general' or title == "privateRoute.iterations" or title == "privateRoute.projectGeneral" or title == "privateRoute.timeLog" or title == "privateRoute.projectDefectLog" or title == "privateRoute.summary" or title == "privateRoute.scripts" or title =="privateRoute.estimating" or title=="privateRoute.pqi" or title == "privateRoute.forms"
		return "Proyectos"
	else if title == "privateRoute.overview"
		return "Resumen"
	else if title == "privateRoute.settings"
		return "Ajustes"
	else if title == "privateRoute.help"
		return "Ayuda"
	else if title == "privateRoute.community"
		return "Comunidad"
	else if title == "privateRoute.communityQuestion"
		return "Pregunta Comunidad"
	else
		return "No Disponible"

##########################################
##############- Time Display-#############
IntegerTwoDigits =(number) ->
	if number < 10
		return "0#{number}"
	else
		return number

sys.displayTime = (time) ->
	horas = Math.floor(time / 3600000)
	time = time % 3600000
	minutos = Math.floor(time / 60000)
	time = time % 60000
	segundos = Math.floor(time / 1000)
	return horas + " hrs, " + minutos + " mins, " + segundos + " segs"

sys.displayShortTime = (time) ->
	horas = Math.floor(time / 3600000)
	time = time % 3600000
	minutos = Math.floor(time / 60000)
	time = time % 60000
	segundos = Math.floor(time / 1000)
	return IntegerTwoDigits(horas) + " : " + IntegerTwoDigits(minutos) + " : " + IntegerTwoDigits(segundos)

sys.timeToHours = (time) ->
	return Math.floor(time / 3600000)

sys.timeToMinutes = (time) ->
	time %= 3600000
	return Math.floor(time / 60000)

sys.timeToSeconds = (time) ->
	time %= 3600000
	time %= 60000
	return Math.floor(time / 1000)

# This is used in the plansummary
sys.hoursToTime = (time) ->
	return time * 3600000

sys.minutesToTime = (time) ->
	return time * 60000

sys.secondsToTime = (time) ->
	return time * 1000

# This brings the timeValue to amount of minutes, the difference
# from this to the sys.timeToMinutes() is that this takes in account
# the hours
sys.timeInOnlyMinutes = (time) ->
	return Math.floor(time / 60000)

sys.timeInOnlyHours = (time) ->
	return Math.floor(time / 3600000)

sys.planSummaryTime = (time) ->
	minutos = Math.floor(time / 60000)
	time %= 60000
	segundos = Math.floor(time / 1000)
	return minutos + " : " + segundos

##########################################
#############- Date Display -#############
sys.dateDisplay = (time) ->
	month = time.getMonth()
	day = time.getDate()
	year = time.getFullYear()

	Months = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]

	month = Months[month]
	return month + " " + day + ", " + year

##########################################
############- Status Messages -###########

sys.removeMessage = () ->
	$('.status-message').animate { opacity: 0 }, 500, ->
		Session.set "statusMessage", false

sys.flashStatus = (type) ->
	# CSS field can get success, warning and danger
	switch type
		when 'create-project-successful'
			title = "Proyecto creado"
			subject = "El proyecto que acabas de ingresar se ha creado correctamente."
			css = "success"

		when 'create-project-error'
			title = "Error"
			subject = "No pudimos crear el proyecto correctamente. Por favor inténtelo nuevamente."
			css = "danger"

		when "delete-project-successful"
			title = "Proyecto eliminado"
			subject = "El projecto seleccionado se ha eliminado correctamente."
			css = "success"

		when "delete-project-error"
			title = "Error"
			subject = "No pudimos eliminar el proyecto que seleccionaste. Por favor inténtelo nuevamente."
			css = "danger"

		when 'change-project-sorting-successful'
			title = "Proyectos reordenados"
			subject = "El orden de los proyectos se ha cambiado correctamente."
			css = "success"

		when 'change-project-sorting-error'
			title = "Error"
			subject = "No se pudo cambiar el orden de los proyectos. Por favor inténtelo nuevamente."
			css = "success"

		when 'create-iteration-successful'
			title = "Iteración creada"
			subject = "Se ha creado correctamente la nueva iteración del proyecto."
			css = "success"

		when 'create-iteration-error'
			title = "Error"
			subject = "No pudimos crear la nueva iteración del proyecto. Por favor inténtelo nuevamente."
			css = "danger"

		when 'delete-iteration-successful'
			title = "Iteración eliminada"
			subject = "La iteración que has seleccionado se ha eliminado correctamente."
			css = "success"

		when 'delete-iteration-error'
			title = "Error"
			subject = "No pudimos eliminar la iteración que seleccionaste. Por favor inténtelo nuevamente."
			css = "danger"

		when "delete-defect-successful"
			title = "Defecto eliminado"
			subject = "El defecto seleccionado se ha eliminado correctamente."
			css = "success"

		when "delete-defect-error"
			title = "Error"
			subject = "No pudimos eliminar el defecto que seleccionaste. Por favor inténtelo nuevamente."
			css = "danger"

		when 'project-title-save-successful'
			title = "Titulo guardado"
			subject = "El titulo que ingresaste para el proyecto se ha cambiado correctamente."
			css = "success"

		when 'project-title-save-error'
			title = "Error"
			subject = "No pudimos cambiar el titulo del proyecto por el que acabas de ingresar. Por favor inténtelo nuevamente."
			css = "danger"

		when 'project-description-save-successful'
			title = "Descripción guardada"
			subject = "La descripción que ingresaste para el proyecto se ha guardado correctamente."
			css = "success"

		when 'project-description-save-error'
			title = "Error"
			subject = "No pudimos cambiar la descripción del proyecto que acabas de ingresar. Por favor inténtelo nuevamente."
			css = "danger"

		when 'project-finish-successful'
			title = "Proyecto finalizado"
			subject = "El proyecto se ha finalizado correctamente."
			css = "success"

		when 'project-finish-error'
			title = "Error"
			subject = "No hemos podido finalizar proyecto. Por favor inténtelo nuevamente."
			css = "danger"

		when "delete-pip-successful"
			title = "PIP eliminado"
			subject = "se ha eliminado correctamente la propuesta de mejora seleccionada."
			css = "success"

		when "delete-pip-error"
			title = "Error"
			subject = "No pudimos eliminar la propuesta de mejora seleccionada. Por favor inténtelo nuevamente."
			css = "danger"

		when "delete-test-successful"
			title = "Reporte eliminado"
			subject = "El reporte de prueba se ha eliminado correctamente."
			css = "success"

		when "delete-test-error"
			title = "Error"
			subject = "No pudimos eliminar el reporte de prueba seleccionado. Por favor inténtelo nuevamente."
			css = "danger"

		when 'create-test-successful'
			title = "Reporte creado"
			subject = "El reporte de prueba que acabas de ingresar se ha creado correctamente."
			css = "success"

		when 'create-test-error'
			title = "Error"
			subject = "No pudimos crear el reporte de prueba correctamente. Por favor inténtelo nuevamente."
			css = "danger"

		when 'create-pip-successful'
			title = "Reporte creado"
			subject = "La propuesta de mejora que acabas de ingresar se ha creado correctamente."
			css = "success"

		when 'create-pip-error'
			title = "Error"
			subject = "No pudimos crear la propuesta de mejora correctamente. Por favor inténtelo nuevamente."
			css = "danger"

		when "create-question-successful"
			title = "Pregunta creada"
			subject = "La pregunta que acabas de ingresar se ha creado correctamente."
			css = "success"

		when "create-question-error"
			title = "Error"
			subject = "No pudimos crear la nueva pregunta correctamente. Por favor inténtelo nuevamente."
			css = "danger"

		when "question-close-successful"
			title = "Pregunta finalizada"
			subject = "La pregunta que acabas de seleccionar se ha finalizado correctamente."
			css = "success"

		when "question-close-error"
			title = "Error"
			subject = "No pudimos cerrar la pregunta que seleccionaste. Por favor inténtelo nuevamente."
			css = "danger"

		when "question-answer-successful"
			title = "Respuesta creada"
			subject = "La respuesta que acabas de ingresar se ha creado correctamente."
			css = "success"

		when "question-answer-error"
			title = "Error"
			subject = "No pudimos crear la respuesta que ingresaste. Por favor inténtelo nuevamente."
			css = "danger"








		when 'create-contact-successful'
			title = "Mensaje enviado"
			subject = "El mensaje que acabas de escribir se ha enviado correctamente."
			css = "success"

		when 'create-contact-error'
			title = "Error"
			subject = "No pudimos enviar el mensaje correctamente. Por favor inténtelo nuevamente."
			css = "danger"













		# Time log from the projects view and editTime modal
		when 'new-time-project'
			title = "Guardado"
			subject = "Se registro el nuevo tiempo correctamente."
			css = "success"

		when 'error-new-time-project'
			title = "Error"
			subject = "No hemos podido registrar el nuevo tiempo."
			css = "danger"

		when "summary-missing"
			title = "Error"
			subject = "Debes ingresar un tiempo estimado en el Plan Summary para continuar."
			css = "danger"

		when "actual-size-missing"
			title = "Error"
			subject = "Debes ingresar tamaño actual en el Plan Summary para continuar."
			css = "danger"

		when 'submit-stage-project'
			title = "Guardado"
			subject = "Has finalizado la etapa del proyecto correctamente."
			css = "success"

		when 'error-submit-stage-project'
			title = "Error"
			subject = "No hemos podido finalizar la etapa del proyecto."
			css = "danger"

		when 'submit-stage-project'
			title = "Guardado"
			subject = "Has actualizado las etapas del proyecto correctamente."
			css = "success"

		when 'error-change-stage-time'
			title = "Error"
			subject = "No hemos podido actualizar las etapa del proyecto."
			css = "danger"

		when "postmortem-psp0"
			title = "Nuevos Campos"
			subject = "Revisa el Plan Summary y los scripts para más información"
			css = "warning"

		# Defects log from the projects view and New defect modal

		when "save-defect"
			title = "Guardado"
			subject = "Los datos del defecto se han actualizado correctamente."
			css = "success"

		when "error-save-defect"
			title = "Error"
			subject = "No hemos logrado actualizar los nuevos datos del defecto."
			css = "danger"

		when "create-defect"
			title = "Creado"
			subject = "El defecto se ha creado correctamente."
			css = "success"

		when "error-create-defect"
			title = "Error"
			subject = "No hemos podido crear el nuevo defecto."
			css = "danger"


		# Settings view
		when "change-probe"
				title = "Guardado"
				subject = "Has cambiado la configuracion PROBE correctamente."
				css = "success"

		when "change-project-sorting"
			title = "Guardado"
			subject = "Has cambiado el orden de los proyectos."
			css = "success"

		when "update-defect-types"
			title = "Guardado"
			subject = "Se han actualizado los tipos de defectos correctamente."
			css = "success"

		when "add-defect-dype"
			title = "Exito"
			subject = "El nuevo tipo de defecto se agregó al final de la lista."
			css = "success"

		#User profile modal
		when "update-profile-image"
			title = "Guardado"
			subject = "La imagen de perfil ha sido cambiada correctamente."
			css = "success"

		when "profile-update"
			title = "Guardado"
			subject = "Cambiaste tus datos personales correctamente."
			css = "success"

		when "error-profile-update"
			title = "Guardado"
			subject = "No se logro actualizar sus datos personales."
			css = "danger"


		# Plan summary view
		when "save-summary-estimated"
			title = "Guardado"
			subject = "Se ha cambiado el tiempo estimado para completar el proyecto."
			css = "success"

		when "error-save-summary-estimated"
			title = "Guardado"
			subject = "Se ha cambiado el tiempo estimado para completar el proyecto."
			css = "success"

		when "size-delete-error"
			title = "Error"
			subject = "Debe haber como mínimo una fila de datos."
			css = "danger"

		when "save-size-summary"
			title = "Guardado"
			subject = "Cambiaste los datos de tamaño del proyecto correctamente."
			css = "success"

		when "error-save-size-summary"
			title = "Guardado"
			subject = "No hemos podido cambiar los datos de tamaño del proyecto."
			css = "danger"

		when "base-deleted-error"
			title = "Error"
			subject = "Las líneas eliminadas no pueden ser mayores que las líneas base."
			css = "danger"

		when "base-modified-error"
			title = "Error"
			subject = "Las líneas modificadas no pueden ser mayores que las líneas base."
			css = "danger"

		#Estimating template view
		when "size-missing"
			title = "Error"
			subject = "Debes ingresar los tamaños planeados en el Plan Summary."
			css = "danger"

		when "error-save-time-estimated"
			title = "Error"
			subject = "No hemos podido actualizar el tiempo estimado."
			css = "danger"

		when "save-size-estimated"
			title = "Guardado"
			subject = "Se ha cambiado el tamaño estimado del proyecto."
			css = "success"

		when "error-save-size-estimated"
			title = "Error"
			subject = "No hemos podido actualizar el tamaño estimado."
			css = "danger"

		when "time-missing"
			title = "Error"
			subject = "El tiempo estimado no puede ser 0"
			css = "danger"


	Session.set "statusMessage", {title: title, subject: subject, css: css}
	window.setTimeout sys.removeMessage, 5300


# This is used to fade-out the notification
sys.removeTimeMessage = () ->
	$('.status-time-message').animate { opacity: 0 }, 800, ->
		Session.set "statusTimeMessage", false

# This is a special flashStatus notification used for the time execution
# (it appears allways until the time was paused)
sys.flashTime = (projectName, projectId, iterationId) ->
	title = "Registro de Tiempo"
	subject = 'Iniciaste la toma de tiempo en el proyecto "' + projectName + '".'
	css = "warning"

	Session.setPersistent "statusTimeMessage", {title: title, subject: subject, css: css, projectId: projectId, iterationId: iterationId}

##########################################
###############- Cut Text -###############

sys.cutText = (text, limit, closing) ->
	text = text.replace(/ +(?= )/g,'');

	if text.length < limit
		return text

	cutat = text.lastIndexOf(' ', limit)

	unless cutat == -1
		text = text.substring(0, cutat) + closing

	if text.length > limit + closing.length
		text = text.substring(0, limit) + closing

	return text

##########################################
#########- Document Title Route -#########
sys.getSessionRoute = (value) ->
	switch value
		when 'privateRoute.general'
			return "Proyectos"
		when 'privateRoute.iterations'
			return "Iteraciones"
		when 'privateRoute.projectGeneral'
			return "Proyecto"
		when 'privateRoute.timeLog'
			return "Log de tiempos"
		when 'privateRoute.defectLog'
			return "Log de defectos"
		when 'privateRoute.summary'
			return "Plan Summary"
		when 'privateRoute.scripts'
			return "Scripts"
		when 'privateRoute.forms'
			return 'Formularios'
		when 'privateRoute.estimating'
			return "Estimación"
		when 'privateRoute.pqi'
			return "PQI"
		when "privateRoute.settings"
			return "Configuración"
		when "privateRoute.overview"
			return "Resumen"
		when "privateRoute.help"
			return "Ayuda"
		when "privateRoute.community"
			return "Comunidad"
		when "privateRoute.communityQuestion"
			return "Pregunta Comunidad"
		when "privateRoute.tutorial"
			return "Tutorial"

##########################################
########- Project Color Selector -########

sys.selectColor = (last_color) ->
	position = last_color % 8
	colors = ["#587291", "#00c1ed", "#00d5b6", "#ff8052", "#ffb427", "#F1E8B8", "#799e9c", "#91cda5"]
	return colors[position]

##########################################
############- Chart Overview -############

sys.overviewChart = (chartName, data, chart_width) ->
	chartElement = document.getElementById(chartName).getContext('2d')
	chartElement?.canvas.width = chart_width
	chartElement?.canvas.height = chart_width/2

	return new Chart(chartElement).Scatter(data,
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

#Data for Size linear Regression
sys.regressionDataSize = (Data,PROBE,x,y)->
	#Size Planned Added & Modified Size - Actual Added & Modified Size for PROBE B
	#Estimated Proxy Size actual - Added and modified lines for PROBE A
	n = Data.length
	sumsquarex = 0
	xavg = x/n
	yavg = y/n
	sumsquarey = 0 
	sumxy = 0
	switch PROBE
		when "B"
			_.each Data,(d)->
				sumsquarex += Math.pow(d.EstimatedLOC,2)
				sumsquarey += Math.pow(d.ActualAddedModified,2)
				sumxy+= d.EstimatedLOC * d.ActualAddedModified
		when "A"
			_.each Data,(d)->
				sumsquarex += Math.pow(d.ProxyE,2)
				sumsquarey += Math.pow(d.ActualLOC,2)
				sumxy+= d.ProxyE * d.ActualLOC

	correlationNumerator = (n*sumxy)-(x*y)
	correlationDenominator = Math.sqrt(((n*sumsquarex)-Math.pow(x,2))*((n*sumsquarey)-Math.pow(y,2)))
	correlation = 0
	if correlationDenominator != 0
		correlation = correlationNumerator/correlationDenominator
	#console.log "Avgx", xavg, "Avgy", yavg, PROBE
	betaNumerator = sumxy-(n*xavg*yavg)
	betaDenominator = sumsquarex-(n*Math.pow(xavg,2))
	b1 = 0
	if betaDenominator != 0
		b1 = betaNumerator/betaDenominator	
	b0 = yavg - (b1*xavg)
	return {"Beta0":b0,"Beta1":b1,"Correlation":correlation}

sys.regressionDataTime = (Data,PROBE,x,y)->
	#Size Planned Added & Modified Size - Actual Added & Modified Size for PROBE B
	#Estimated Proxy Size actual - Added and modified lines for PROBE A
	n = Data.length
	sumsquarex = 0
	xavg = x/n
	yavg = y/n
	sumsquarey = 0
	sumxy = 0
	switch PROBE
		when "B"
			_.each Data,(d)->
				sumsquarex += Math.pow(d.EstimatedLOC,2)
				sumsquarey += Math.pow(d.ActualTime,2)
				sumxy+= d.EstimatedLOC * d.ActualTime
		when "A"
			_.each Data,(d)->
				sumsquarex += Math.pow(d.ProxyE,2)
				sumsquarey += Math.pow(d.ActualTime,2)
				sumxy+= d.ProxyE * d.ActualTime

	correlationNumerator = (n*sumxy)-(x*y)
	correlationDenominator = Math.sqrt(((n*sumsquarex)-Math.pow(x,2))*((n*sumsquarey)-Math.pow(y,2)))
	correlation = 0
	if correlationDenominator != 0
		correlation = correlationNumerator/correlationDenominator
	#console.log "Avgx", xavg, "Avgy", yavg, PROBE
	betaNumerator = sumxy-(n*xavg*yavg)
	betaDenominator = sumsquarex-(n*Math.pow(xavg,2))
	b1 = 0
	if betaDenominator != 0
		b1 = betaNumerator/betaDenominator
	b0 = yavg - (b1*xavg)
	return {"Beta0":b0,"Beta1":b1,"Correlation":correlation}