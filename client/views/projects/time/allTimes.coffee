##########################################
Template.timeTemplate.onCreated () ->
	Meteor.subscribe "projectView", FlowRouter.getParam("id")
	document.title = "Time Log"

Template.timeTemplate.helpers
	projectStages:() ->
		pid = FlowRouter.getParam("id")
		planSummary = db.plan_summary.findOne({"projectId": pid, "summaryOwner": Meteor.userId()})

		if planSummary
			return planSummary.timeEstimated

##########################################
Template.timesBar.onCreated () ->
	@projectStages = new ReactiveVar([])
	@timeStatus = new ReactiveVar(false)
	@timeStarted = new ReactiveVar(0)


Template.timesBar.helpers
	dropdownStages:() ->
		pid = FlowRouter.getParam("id")
		planSummary = db.plan_summary.findOne({"projectId": pid, "summaryOwner": Meteor.userId()})
		if planSummary
			ProjectStages = _.filter planSummary.timeEstimated, (stage) ->
				if !stage.finished
					stage
			Template.instance().projectStages.set(ProjectStages)

		return Template.instance().projectStages.get()

	timeStatus:() ->
		return Template.instance().timeStatus.get()

	currentStage: () ->
		return _.first Template.instance().projectStages.get()

	EmptyStage: () ->
		Stages = Template.instance().projectStages.get()
		return Stages.length == 0


Template.timesBar.events
	'click .fa-play': (e,t) ->
		t.timeStarted.set(new Date())
		t.timeStatus.set(true)

	'click .fa-pause': (e,t) ->
		TimeStarted = t.timeStarted.get()
		projectStages = t.projectStages.get()

		unless TimeStarted == 0
			totalTime = new Date() - TimeStarted
			currentStage = _.first projectStages
			currentStage.time = parseInt(totalTime)

			Meteor.call "update_time_stage", FlowRouter.getParam("id"), currentStage, (err) ->
				if err
					sys.flashStatus("error-project")
					console.log "Error updating project phase"
					console.warn(error)
				else
					t.timeStarted.set(0)
					t.timeStatus.set(false)


	'click .time-submit': (e,t) ->
		TimeStarted = Template.instance().timeStarted.get()
		projectStages = Template.instance().projectStages.get()

		if TimeStarted != 0
			totalTime = new Date() - TimeStarted
		else
			totalTime = 0

		currentStage = _.first projectStages
		currentStage.time = parseInt(totalTime)
		Meteor.call "update_time_stage", FlowRouter.getParam("id"), currentStage, true, (error) ->
			if error
				sys.flashStatus("error-project")
				console.log "Error submitting phase time inside project"
				console.warn(error)
			else
				t.projectStages.set( _.without projectStages, currentStage)
				t.timeStarted.set(0)
				t.timeStatus.set(false)

##########################################