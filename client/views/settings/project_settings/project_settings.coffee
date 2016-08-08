##################################################
Template.projectSettingsTemplate.onCreated ()->
	Meteor.subscribe "projectSettings"


Template.projectSettingsTemplate.helpers
	settings: () ->
		user = db.users.findOne({_id: Meteor.userId()})
		return [
			{
				title: "Método PROBE C"
				subject: "Cuando un proyecto utiliza el método PROBE C este propirciona en el plan summary un valor promedio de estimacion para el tiempo que toma cada etapa."
				value: user?.settings?.probeC
			},
			{
				title: "Método PROBE D"
				subject: "El metodo probe D hace que el usuario tenga que ingresar siempre en un proyecto/iteración nuevo el tiempo que piensa que le tomara completar el proyecto. Este valor sera guardado y usado en un futuro."
				value: user?.settings?.probeD
			}
		]

Template.projectSettingsTemplate.events
	'click .switch': (e,t) ->
		completedProjects = db.projects.find({"projectOwner": Meteor.userId(), "completed": true}).count()

		if completedProjects > 2
			Meteor.call("change_project_settings")

		#console.log "aqui", document.getElementById('settings-checkbox').checked

##################################################