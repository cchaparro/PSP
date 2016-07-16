##################################################
juan = new ReactiveVar(true)

##################################################
Template.projectSettingsTemplate.helpers
	checked: () ->
		return juan.get()

Template.projectSettingsTemplate.events
	'change #settings-checkbox': (e,t) ->
		console.log "aqui", document.getElementById('settings-checkbox').checked

	'click .switch': (e,t) ->
		console.log "di click"
		#$(e.target).closest(".settings-checkbox").val(0)


##################################################