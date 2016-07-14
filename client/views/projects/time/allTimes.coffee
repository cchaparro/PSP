##########################################
Template.timeTemplate.onCreated () ->
	Meteor.subscribe "projectView", FlowRouter.getParam("id")
	document.title = "Time Log"

Template.timeTemplate.helpers
	projectStages:() ->
		return db.plan_summary.findOne({"projectId": FlowRouter.getParam("id"), "summaryOwner": Meteor.userId()})?.timeEstimated

##########################################
Template.timesBar.onCreated () ->
	@projectStages = new ReactiveVar([])


Template.timesBar.helpers
	planSummary: () ->
		return db.plan_summary.findOne({"projectId": FlowRouter.getParam("id"), "summaryOwner": Meteor.userId()})

	dropdownStages:() ->
		planSummary = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id"), "summaryOwner": Meteor.userId()})
		if planSummary
			ProjectStages = _.filter planSummary.timeEstimated, (stage) ->
				if !stage.finished
					return stage
			Template.instance().projectStages.set(ProjectStages)

		return Template.instance().projectStages.get()

	timeStatus:() ->
		planSummary = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id"), "summaryOwner": Meteor.userId()})
		return planSummary.timeStarted != "false"

	currentStage: () ->
		return _.first Template.instance().projectStages.get()

	isEmptyStage: () ->
		Stages = Template.instance().projectStages.get()
		return Stages.length == 0


Template.timesBar.events
	'click .fa-play': (e,t) ->
		date = new Date()
		Meteor.call "update_timeStarted", FlowRouter.getParam("id"), date, (error) ->
			if error
				console.log "Error changing timeStarted in plan Summary"


	'click .fa-pause': (e,t) ->
		projectStages = t.projectStages.get()

		unless @timeStarted == "false"
			totalTime = new Date() - new Date(@timeStarted)
			currentStage = _.first projectStages
			currentStage.time = parseInt(totalTime)

			Meteor.call "update_time_stage", FlowRouter.getParam("id"), currentStage, false, true, (error) ->
				if error
					sys.flashStatus("error-project")
					console.log "Error updating project phase"
					console.warn(error)
				else
					sys.flashStatus("save-project")


	'click .time-submit': (e,t) ->
		projectStages = Template.instance().projectStages.get()

		if @timeStarted != "false"
			totalTime = new Date() - new Date(@timeStarted)
		else
			totalTime = 0

		currentStage = _.first projectStages
		currentStage.time = parseInt(totalTime)

		Meteor.call "update_time_stage", FlowRouter.getParam("id"), currentStage, true, true, (error) ->
			if error
				sys.flashStatus("error-project")
				console.log "Error submitting phase time inside project"
				console.warn(error)
			else
				t.projectStages.set( _.without projectStages, currentStage)
				sys.flashStatus("save-project")

##########################################