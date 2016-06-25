##########################################
Template.projectInformationTemplate.helpers
	projectInfo: () ->
		return db.projects.findOne({_id: FlowRouter.getParam("id"), "projectOwner": Meteor.userId()})

	projectTotalTime: () ->
		planSummary = db.plan_summary.findOne("projectId": FlowRouter.getParam("id"), "summaryOwner": Meteor.userId())?.timeEstimated

		time = 0
		_.each planSummary, (stage) ->
			time = time + stage.time

		return sys.displayTime(time)

	dateDisplay:(date) ->
		return sys.dateDisplay(date)


Template.projectInformationTemplate.events
	'blur .prj-info-title': (e,t) ->
		description = $('.prj-info-title').html()
		console.log description.text
		data = {
			"title": $('.prj-info-title').html()
		}

		Meteor.call "update_project", FlowRouter.getParam("id"), data, (error)->
			if error
				sys.flashError()
				console.log ("Error updating the projects title")
				console.warn(error)
			else
				sys.flashSuccess()

	'blur .prj-info-description': (e,t) ->
		set = {
			"description": $('.prj-info-description').html()
		}

		Meteor.call "update_project", FlowRouter.getParam("id"), set, (error)->
			if error
				sys.flashError()
				console.log ("Error updating the projects description")
				console.warn(error)
			else
				sys.flashSuccess()

	'click .project-status': (e,t) ->
		Meteor.call "update_project", @_id, { completed: !@completed }, (error) ->
			if error
				sys.flashError()
				console.log ("Error changing the project completion value")
				console.warn(error)
			else
				sys.flashSuccess()

##########################################