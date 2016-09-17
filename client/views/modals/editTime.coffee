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
	@disableAddOption = new ReactiveVar(false)
	timeData.set({})
	@inputValues = new ReactiveVar({"hours": 0, "minutes": 0, "seconds": 0})

	if @data?.type
		timeData.set(@data)
		Template.instance().inputValues.set({"hours": sys.timeToHours(@data.data.time), "minutes": sys.timeToMinutes(@data.data.time), "seconds": sys.timeToSeconds(@data.data.time)})
		Template.instance().selectedOption.set('delete-time')
		Template.instance().disableAddOption.set(true)
	else
		timeData.set(@data)
		Template.instance().selectedOption.set('add-time')


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

	addDisabled: () ->
		return Template.instance().disableAddOption.get()

	currentStage: () ->
		currentData = timeData.get()
		if currentData?.name?
			return currentData.name
		else
			return currentData?.data?.stage

	currentTime: () ->
		currentData = timeData.get()
		if currentData?.time?
			return sys.displayTime(currentData.time)
		else
			planSummary = db.plan_summary.findOne({_id: currentData?.data?.id}).timeEstimated
			summaryTime = _.findWhere planSummary, {name: currentData?.data?.stage}
			return sys.displayTime(summaryTime.time)

	newTime: () ->
		currentData = timeData.get()

		if currentData?.time?
			currentTime = currentData.time
		else
			planSummary = db.plan_summary.findOne({_id: currentData?.data?.id}).timeEstimated
			summaryTime = _.findWhere planSummary, {name: currentData?.data?.stage}
			currentTime = summaryTime.time

		option = Template.instance().selectedOption.get()
		input = Template.instance().inputValues.get()

		hours = sys.hoursToTime(input.hours)
		minutes = sys.minutesToTime(input.minutes)
		seconds = sys.secondsToTime(input.seconds)
		editValue = parseInt(hours) + parseInt(minutes) + parseInt(seconds)

		if option == 'delete-time'
			newValue = currentTime - editValue
		else
			newValue = currentTime + editValue

		if newValue < 0
			return sys.displayTime(0)
		else
			return sys.displayTime(newValue)


Template.editTime.events
	'click .time-option': (e,t) ->
		data = timeData.get()
		unless data?.type?
			option = $(e.target).closest(".time-option").data('value')
			t.selectedOption.set(option)

	'click .fa-caret-up': (e,t) ->
		value = $(e.target).data('value')
		data = timeData.get()

		switch value
			when "hours-selector"
				current = $(".edit-time-hours").val()
				unless parseInt(current) == sys.timeToHours(data?.data?.time)
					newValue = parseInt(current) + 1
					$(".edit-time-hours").val(newValue)

					data = t.inputValues.get()
					data.hours = newValue
					t.inputValues.set(data)

			when "minutes-selector"
				current = $(".edit-time-minutes").val()
				unless parseInt(current) == sys.timeToMinutes(data?.data?.time)
					newValue = parseInt(current) + 1
					$(".edit-time-minutes").val(newValue)

					data = t.inputValues.get()
					data.minutes = newValue
					t.inputValues.set(data)

			when "seconds-selector"
				current = $(".edit-time-seconds").val()
				unless parseInt(current) == sys.timeToSeconds(data?.data?.time)
					newValue = parseInt(current) + 1
					$(".edit-time-seconds").val(newValue)

					data = t.inputValues.get()
					data.seconds = newValue
					t.inputValues.set(data)

	'click .fa-caret-down': (e,t) ->
		value = $(e.target).data('value')
		switch value
			when "hours-selector"
				current = $(".edit-time-hours").val()
				if current > 0
					newValue = parseInt(current) - 1
					$(".edit-time-hours").val(newValue)

					data = t.inputValues.get()
					data.hours = newValue
					t.inputValues.set(data)

			when "minutes-selector"
				current = $(".edit-time-minutes").val()
				if current > 0
					newValue = parseInt(current) - 1
					$(".edit-time-minutes").val(newValue)

					data = t.inputValues.get()
					data.minutes = newValue
					t.inputValues.set(data)

			when "seconds-selector"
				current = $(".edit-time-seconds").val()
				if current > 0
					newValue = parseInt(current) - 1
					$(".edit-time-seconds").val(newValue)

					data = t.inputValues.get()
					data.seconds = newValue
					t.inputValues.set(data)

	'change input': (e,t) ->
		data = t.inputValues.get()
		value = $(e.target).val()

		if $(e.target).hasClass("edit-time-hours")
			data.hours = value
			t.inputValues.set(data)

		if $(e.target).hasClass("edit-time-minutes")
			data.minutes = value
			t.inputValues.set(data)

		if $(e.target).hasClass("edit-time-seconds")
			data.seconds = value
			t.inputValues.set(data)

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
					sys.flashStatus("new-time-project")
					Modal.hide('editTimeModal')

		else
			Meteor.call "delete_time_stage", FlowRouter.getParam("id"), stageName, totalTime, (error) ->
				if error
					console.warn(error)
				else
					if data?.type
						Meteor.call "disable_notification", data._id

					sys.flashStatus("new-time-project")
					Modal.hide('editTimeModal')

# ##########################################