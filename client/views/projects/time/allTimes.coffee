##########################################
Template.timeTemplate.onCreated () ->
	document.title = "Time Log"

Template.timeTemplate.helpers
	projectStages:() ->
		return db.plan_summary.findOne({projectId: FlowRouter.getParam("id")})?.timeEstimated

##########################################
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

		return _.first(projectStages).name


Template.timesBar.events
	'click .fa-play': (e,t) ->
		date = new Date()
		projectTitle = db.projects.findOne({_id: FlowRouter.getParam("id")}).title
		Meteor.call "update_timeStarted", FlowRouter.getParam("id"), date, (error) ->
			if error
				console.log "Error changing timeStarted in plan Summary"
			else
				sys.flashTime(projectTitle)


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
		projectStages = _.filter planSummary?.timeEstimated, (stage) ->
			unless stage.finished
				return stage

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
				sys.flashStatus("save-project")
				sys.removeTimeMessage()

##################################################
Template.timeTableRow.events
	'click .edit-time': (e,t) ->
		Modal.show('editTimeModal', @)

##########################################