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
##############- Time Display-#############

sys.displayTime = (time) ->
	horas = Math.floor(time / 3600000)
	time = time % 3600000
	minutos = Math.floor(time / 60000)
	time = time % 60000
	segundos = Math.floor(time / 1000)
	return horas + " hrs, " + minutos + " mins, " + segundos + " sec"

##########################################
###############- Page Name -##############

sys.getPageName = (title) ->
	if title == "main" or title == "iterationView" or title == "projectView"
		return "Proyectos"
	else if title == "notifications"
		return "Notificaciones"
	else if title == "settings"
		return "Ajustes"
	else if title == "help"
		return "Ayuda"
	else
		return "No Disponible"

##########################################
############- Status Messages -###########

sys.removeMessage = () ->
	$('.status-message').animate { opacity: 0 }, 500, ->
		Session.set "statusMessage", false

sys.flashSuccess = () ->
	Session.set "statusMessage", {text: "Guardado", css:"success"}
	window.setTimeout sys.removeMessage, 1500

sys.flashError = () ->
	Session.set "statusMessage", {text: "Error", css:"danger"}
	window.setTimeout sys.removeMessage, 1500

##########################################

##########################################

##########################################

##########################################