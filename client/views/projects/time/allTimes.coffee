##########################################
Template.timeTemplate.helpers
	projectStages:() ->
		return db.plan_summary.findOne({projectId: FlowRouter.getParam("id")})?.timeEstimated

##########################################
Template.timesBar.onCreated () ->
	@disablePlayButton = new ReactiveVar(false)


Template.timesBar.helpers
	planSummary: () ->
		return db.plan_summary.findOne({projectId: FlowRouter.getParam("id")})

	isRecordingTime:() ->
		planSummary = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id"), "summaryOwner": Meteor.userId()})
		return planSummary?.timeStarted != "false"

	currentStage: () ->
		planSummary = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})
		projectStages = _.filter planSummary?.timeEstimated, (stage) ->
			unless stage.finished
				return stage

		currentPos = _.first(projectStages)?.name

		unless currentPos
			Template.instance().disablePlayButton.set(true)

		return currentPos

	disabledPlayButton: () ->
		return Template.instance().disablePlayButton.get()


Template.timesBar.events
	'click .fa-play': (e,t) ->
		unless t.disablePlayButton.get()
			date = new Date()
			projectTitle = db.projects.findOne({_id: FlowRouter.getParam("id")}).title
			Meteor.call "update_timeStarted", FlowRouter.getParam("id"), date, (error) ->
				if error
					console.log "Error changing timeStarted in plan Summary"
				else
					projectId = FlowRouter.getParam("fid")
					iterationId = FlowRouter.getParam("id")
					sys.flashTime(projectTitle, projectId, iterationId)


	'click .fa-pause': (e,t) ->
		planSummary = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})
		projectStages = _.filter planSummary?.timeEstimated, (stage) ->
			unless stage.finished
				return stage

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
					sys.removeTimeMessage()


	'click .time-submit': (e,t) ->
		planSummary = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})
		project = db.projects.findOne({ _id: FlowRouter.getParam("id") })
		currentStage = _.findWhere projectStages, {finished: false}

		projectProbe = db.projects.findOne({_id: FlowRouter.getParam("id")})?.projectProbe

		projectStages = _.filter planSummary?.timeEstimated, (stage) ->
			unless stage.finished
				return stage

		currentStage = _.first projectStages

		# If the user has the probeD option and has not entered a value in the Plan Summary estimation,
		# This will give it a error and not let the user finish the stage "Planeación"
		if currentStage.name == "Planeación" and @total.estimatedTime == 0 and projectProbe == "probeD" and project.levelPSP == "PSP 0"
			sys.flashStatus("summary-missing")

		else
			if @timeStarted != "false"
				totalTime = new Date() - new Date(@timeStarted)
			else
				totalTime = 0

			currentStage.time = parseInt(totalTime)

			Meteor.call "update_time_stage", FlowRouter.getParam("id"), currentStage, true, true, (error) ->
				if error
					sys.flashStatus("error-project")
					console.log "Error submitting phase time inside project"
					console.warn(error)
				else
					sys.flashStatus("save-project")
					sys.removeTimeMessage()

##################################################
Template.timeTableRow.helpers
	editAvailable: () ->
		return true if @finished

		planSummary = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})
		projectStages = _.filter planSummary?.timeEstimated, (stage) ->
			unless stage.finished
				return stage

		return true if @name == _.first(projectStages)?.name
		return false


Template.timeTableRow.events
	'click .edit-time': (e,t) ->
		Modal.show('editTimeModal', @)

##########################################