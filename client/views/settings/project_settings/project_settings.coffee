##################################################
juan = new ReactiveVar(true)
##################################################
Template.projectSettingsTemplate.helpers
	checked: () ->
		return juan.get()

	settings: () ->
		return [
			{
				title: "Proyecto con Probe C"
				subject: "Cuando un proyecto utiliza probe C este no tiene que escribir una estimacion de cuanto cree que le va a tomar terminar un proyecto. EL Plan Summary directamente hara la estimacion. Esta opcion solo se habilita despues de completar tres proyectos (AUN NO ESTA IMPLEMENTADO)."
				value: true
			},
			{
				title: "Proyecto con Probe D"
				subject: "El metodo probe D hace que el usuario tenga que ingresar siempre en un proyecto/iteración nuevo el tiempo que piensa que le tomara completar el proyecto. Este valor sera guardado y usado en un futuro."
				value: false
			}
		]

Template.projectSettingsTemplate.events
	'change #settings-checkbox': (e,t) ->
		console.log "aqui", document.getElementById('settings-checkbox').checked

	'click .switch': (e,t) ->
		console.log "di click"


##################################################