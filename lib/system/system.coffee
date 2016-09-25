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

##########################################
###############- Page Name -##############
sys.getPageName = (title) ->
	if title == "projects" or title == "iterations" or title == "projectGeneral" or title == "projectTimeLog" or title == "projectDefectLog" or title == "projectSummary" or title == "projectScripts" or title =="estimatingtemplate"
		return "Proyectos"
	else if title == "overview"
		return "Resumen"
	else if title == "projectSettings" or title == "accountSettings" or title == "defectTypeSettings"
		return "Ajustes"
	else if title == "help"
		return "Ayuda"
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
	return (time/3600000)

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
		# AllProjects and AllIterations view
		when "create-project"
			title = "Creado"
			subject = "El proyecto se ha creado correctamente."
			css = "success"

		when "error-create-project"
			title = "Error"
			subject = "No hemos podido crear el proyecto nuevo."
			css = "danger"

		when "project-delete"
			title = "Eliminado"
			subject = "El projecto ha sido removido correctamente."
			css = "success"

		when "error-project-delete"
			title = "Error"
			subject = "No hemos podido remover el proyecto seleccionado."
			css = "danger"

		when "create-iteration"
			title = "Creado"
			subject = "La iteración se ha creado correctamente."
			css = "success"

		when "error-create-iteration"
			title = "Error"
			subject = "No hemos podido crear la nueva iteración."
			css = "danger"

		when "iteration-delete"
			title = "Eliminado"
			subject = "El projecto ha sido removido correctamente."
			css = "success"

		when "error-iteration-delete"
			title = "Error"
			subject = "No hemos podido remover la iteración seleccionada."
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

		when 'error-submit-stage-project'
			title = "Error"
			subject = "No hemos podido actualizar las etapa del proyecto."
			css = "danger"


		# Defects log from the projects view and New defect modal
		when "delete-defect"
			title = "Eliminado"
			subject = "El defecto ha sido removido correctamente."
			css = "success"

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


		# Project information from the projects view
		when 'save-title-project'
			title = "Guardado"
			subject = "El titulo del proyecto se ha cambiado correctamente."
			css = "success"

		when 'error-save-title-project'
			title = "Error"
			subject = "No hemos podido cambiar el titulo del proyecto."
			css = "danger"

		when 'save-description-project'
			title = "Guardado"
			subject = "Se ha cambiado la descripción del proyecto correctamente."
			css = "success"

		when 'error-save-description-project'
			title = "Error"
			subject = "No hemos podido cambiar la descripción del proyecto."
			css = "danger"

		when 'finish-project'
			title = "Guardado"
			subject = "El proyecto se ha finalizado correctamente."
			css = "success"

		when 'error-finish-project'
			title = "Error"
			subject = "No hemos podido finalizar proyecto."
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
		when "size-missing"
			title = "Error"
			subject = "Debes ingresar los tamaños planeados en el Plan Summary"
			css = "danger"

	Session.set "statusMessage", {title: title, subject: subject, css: css}
	window.setTimeout sys.removeMessage, 3800

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
		when "projects"
			return "Proyectos"
		when "iterations"
			return "Iteraciones"
		when "general"
			return "Proyecto"
		when "timeLog"
			return "Log de tiempos"
		when "defectLog"
			return "Log de defectos"
		when "planSummary"
			return "Plan Summary"
		when "scripts"
			return "Scripts"
		when "settings"
			return "Ajustes"
		when "defectTypes"
			return "Tipos de defecto"
		when "help"
			return "Ayuda"
		when "estimatingTemplate"
			return "Estimación"

##########################################
########- Project Color Selector -########

sys.selectColor = (last_color) ->
	position = last_color % 8
	colors = ["#587291", "#00c1ed", "#00d5b6", "#ff8052", "#ffb427", "#F1E8B8", "#799e9c", "#91cda5"]
	return colors[position]

##########################################
###########- Global Variables -###########

# This global variable is made to active the flashTime status
# message when a project is taking a time recorder
# sys.runningTimeProject = new ReactiveVar(false)

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
	
	correlation = ((n*sumxy)-(x*y))/(Math.sqrt(((n*sumsquarex)-Math.pow(x,2))*((n*sumsquarey)-Math.pow(y,2))))
	b1 = (sumxy-(n*xavg*yavg))/(sumsquarex-(n*Math.pow(xavg,2)))
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
	
	correlation = ((n*sumxy)-(x*y))/(Math.sqrt(((n*sumsquarex)-Math.pow(x,2))*((n*sumsquarey)-Math.pow(y,2))))
	console.log "Avgx", xavg, "Avgy", yavg, PROBE
	b1 = (sumxy-(n*xavg*yavg))/(sumsquarex-(n*Math.pow(xavg,2)))
	b0 = yavg - (b1*xavg)
	return {"Beta0":b0,"Beta1":b1,"Correlation":correlation}