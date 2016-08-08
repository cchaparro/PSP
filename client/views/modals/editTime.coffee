###########################################
Template.editTimeModal.helpers
	stageName: () ->
		return @name

###########################################
Template.editTime.onCreated () ->
	@isMenuView = new ReactiveVar(true)
	@actionField = new ReactiveVar(false)


Template.editTime.helpers
	isMenuView: () ->
		return Template.instance().isMenuView.get()


Template.editTime.events
	'click .time-option': (e,t) ->
		value = $(e.target).closest(".time-option").data('value')
		t.actionField.set(value)
		t.isMenuView.set(false)

	'click .time-back': (e,t) ->
		t.isMenuView.set(true)
		t.actionField.set(false)

	'click .fa-chevron-up': (e,t) ->
		value = $(e.target).data('value')
		switch value
			when "hours-selector"
				current = $(".edit-time-hours").val()
				newValue = parseInt(current) + 1
				$(".edit-time-hours").val(newValue)

			when "minutes-selector"
				current = $(".edit-time-minutes").val()
				newValue = parseInt(current) + 1
				$(".edit-time-minutes").val(newValue)

			when "seconds-selector"
				current = $(".edit-time-seconds").val()
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

		if totalTime == 0
			Modal.hide('editTimeModal')

		else if t.actionField.get() == "add-time"
			Meteor.call "add_time_stage", FlowRouter.getParam("id"), @name, totalTime, (error) ->
				if error
					console.warn(error)
				else
					sys.flashStatus("save-project")
					Modal.hide('editTimeModal')

		else
			Meteor.call "delete_time_stage", FlowRouter.getParam("id"), @name, totalTime, (error) ->
				if error
					console.warn(error)
				else
					sys.flashStatus("save-project")
					Modal.hide('editTimeModal')

# ##########################################