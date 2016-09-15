##################################################
Template.projectSettingsTemplate.onCreated ()->
	@displayWarning = new ReactiveVar(false)


Template.projectSettingsTemplate.helpers
	settings: () ->
		user = db.users.findOne({_id: Meteor.userId()})
		return [
			{
				title: "Método PROBE C. Cuando un proyecto utiliza el método PROBE C este propirciona en el plan summary un valor promedio de estimacion para el tiempo que toma cada etapa."
				value: user?.settings?.probeC
			},
			{
				title: "Método PROBE D. El metodo probe D hace que el usuario tenga que ingresar siempre en un proyecto/iteración nuevo el tiempo que piensa que le tomara completar el proyecto. Este valor sera guardado y usado en un futuro."
				value: user?.settings?.probeD
			}
		]

	orderSettings: () ->
		user = db.users.findOne({_id: Meteor.userId()})
		return [
			{
				title: "Ordenar los proyectos por su fecha de creacion"
				value: user?.settings?.projectSort == "date"
				field: "date"
			},
			{
				title: "Ordenar los proyectos en orden alfabetico."
				value: user?.settings?.projectSort == "title"
				field: "title"
			},
			{
				title: "Ordenar todos los proyectos por el color que tienen definido."
				value: user?.settings?.projectSort == "color"
				field: "color"
			}
		]

	displayWarning: () ->
		return Template.instance().displayWarning.get()

Template.projectSettingsTemplate.events
	'click .general-switch': (e,t) ->
		completedProjects = db.projects.find({"projectOwner": Meteor.userId(), "completed": true}).count()

		if completedProjects > 2
			Meteor.call "change_project_settings", (error) ->
				unless error
					t.displayWarning.set(true)
					sys.flashStatus("change-probe")

		#console.log "aqui", document.getElementById('settings-checkbox').checked

	'click .order-switch': (e,t) ->
		value = $(e.target).closest(".project-settings-option").data('value')
		Meteor.call "change_project_sorting_settings", value, (error) ->
			if error
				console.warn(error)
			else
				sys.flashStatus("change-project-sorting")

##################################################