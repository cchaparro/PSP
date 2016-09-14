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
	if title == "projects" or title == "iterations" or title == "projectGeneral" or title == "projectTimeLog" or title == "projectDefectLog" or title == "projectSummary" or title == "projectScripts"
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
	switch type
		when 'error-project'
			title = "Error"
			subject = "No hemos logrado actualizar los nuevos datos del proyecto."
			css = "danger"
		when "create-project"
			title = "Creado"
			subject = "El proyecto se ha creado correctamente."
			css = "success"
		when "save-project"
			title = "Guardado"
			subject = "Los datos del proyecto se han actualizado correctamente."
			css = "success"
		when "delete-project"
			title = "Eliminado"
			subject = "El projecto ha sido removido correctamente."
			css = "success"

		when "create-defect"
			title = "Creado"
			subject = "El defecto se ha creado correctamente."
			css = "success"
		when "save-defect"
			title = "Guardado"
			subject = "Los datos del defecto se han actualizado correctamente."
			css = "success"
		when "error-defect"
			title = "Error"
			subject = "No hemos logrado actualizar los nuevos datos del defecto."
			css = "danger"
		when "delete-defect"
			title = "Eliminado"
			subject = "El defecto ha sido removido del proyecto."
			css = "success"
		when "update-defect-types"
			title = "Guardado"
			subject = "Los nuevos tipos de defectos han sido actualizados correctamente."
			css = "success"

		when "update-profile-image"
			title = "Guardado"
			subject = "La imagen de perfil ha sido cambiada correctamente."
			css = "success"

		when "change-probe"
			title = "Guardado"
			subject = "Has cambiado la configuracion PROBE correctamente."
			css = "success"
		when "profile-update"
			title = "Guardado"
			subject = "Cambiaste tus datos personales correctamente."
			css = "success"
		when "profile-update-error"
			title = "Guardado"
			subject = "No se logro actualizar sus datos personales."
			css = "danger"

		when "summary-missing"
			title = "Error"
			subject = "Debes ingresar un tiempo estimado en el Plan Summary para continuar."
			css = "danger"

		when "size-delete-error"
			title = "Error"
			subject = "Como mínimo debe haber una fila de datos."
			css = "danger"

		when "base-deleted-error"
			title = "Error"
			subject = "Las líneas eliminadas no pueden ser mayores que las líneas base."
			css = "danger"

		when "base-modified-error"
			title = "Error"
			subject = "Las líneas modificadas no pueden ser mayores que las líneas base."
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
	title = "Toma de Tiempo"
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
