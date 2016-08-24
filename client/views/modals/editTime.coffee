###########################################
timeData = new ReactiveVar({})

###########################################
Template.editTimeModal.helpers
	modalTitle: () ->
		data = timeData.get()
		if data?.type?
			return "Modificar tiempo en #{data.data.stage}"
		else
			return "Tiempos de #{data.name}"

	modalHeader: () ->
		data = timeData.get()
		if data?.type?
			return "El siguiente tiempo fue recolectado en el proyecto '#{data.title.secondary}' y este solo puede ser eliminado del proyecto."
		else
			return "Luego de elegir una opcion podras ingresar un valor de tiempo y luego terminar el proceso."

###########################################
Template.editTime.onCreated () ->
	@selectedOption = new ReactiveVar(false)
	timeData.set({})

	if @data?.type
		timeData.set(@data)
		Template.instance().selectedOption.set('delete-time')
	else
		timeData.set(@data)
		Template.instance().selectedOption.set(false)


Template.editTime.helpers
	selectedOption: () ->
		return Template.instance().selectedOption.get()

	hoursValue: () ->
		data = timeData.get()
		if data?.type?
			return sys.timeToHours(data.data.time)
		else
			return "0"

	minutesValue: () ->
		data = timeData.get()
		if data?.type?
			return sys.timeToMinutes(data.data.time)
		else
			return "0"

	secondsValue: () ->
		data = timeData.get()
		if data?.type?
			return sys.timeToSeconds(data.data.time)
		else
			return "0"


Template.editTime.events
	'click .time-option': (e,t) ->
		data = timeData.get()
		unless data?.type?
			option = $(e.target).closest(".time-option").data('value')
			t.selectedOption.set(option)

	'click .fa-chevron-up': (e,t) ->
		value = $(e.target).data('value')
		data = timeData.get()

		switch value
			when "hours-selector"
				current = $(".edit-time-hours").val()
				unless parseInt(current) == sys.timeToHours(data?.data?.time)
					newValue = parseInt(current) + 1
					$(".edit-time-hours").val(newValue)

			when "minutes-selector"
				current = $(".edit-time-minutes").val()
				unless parseInt(current) == sys.timeToMinutes(data?.data?.time)
					newValue = parseInt(current) + 1
					$(".edit-time-minutes").val(newValue)

			when "seconds-selector"
				current = $(".edit-time-seconds").val()
				unless parseInt(current) == sys.timeToSeconds(data?.data?.time)
					newValue = parseInt(current) + 1
					$(".edit-time-seconds").val(newValue)

	'click .fa-chevron-down': (e,t) ->
		value = $(e.target).data('value')
		switch value
			when "hours-selector"
				current = $(".edit-time-hours").val()
				if current > 0
					newValue = parseInt(current) - 1
					$(".edit-time-hours").val(newValue)

			when "minutes-selector"
				current = $(".edit-time-minutes").val()
				if current > 0
					newValue = parseInt(current) - 1
					$(".edit-time-minutes").val(newValue)

			when "seconds-selector"
				current = $(".edit-time-seconds").val()
				if current > 0
					newValue = parseInt(current) - 1
					$(".edit-time-seconds").val(newValue)

	'click .finish-edit-time': (e,t) ->
		hours = $(".edit-time-hours").val()
		minutes = $(".edit-time-minutes").val()
		seconds = $(".edit-time-seconds").val()
		totalTime = (hours*3600000) + (minutes*60000) + (seconds*1000)

		data = timeData.get()
		if data?.type
			stageName = data.data.stage
		else
			stageName = data.name

		if totalTime == 0
			Modal.hide('editTimeModal')

		else if t.selectedOption.get() == "add-time"
			Meteor.call "add_time_stage", FlowRouter.getParam("id"), stageName, totalTime, (error) ->
				if error
					console.warn(error)
				else
					sys.flashStatus("save-project")
					Modal.hide('editTimeModal')

		else
			Meteor.call "delete_time_stage", FlowRouter.getParam("id"), stageName, totalTime, (error) ->
				if error
					console.warn(error)
				else
					if data?.type
						Meteor.call "disable_notification", data._id

					sys.flashStatus("save-project")
					Modal.hide('editTimeModal')

# ##########################################