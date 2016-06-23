##########################################
Template.projectInformationTemplate.helpers
	projectInfo: () ->
		return db.projects.findOne({_id: FlowRouter.getParam("id"), "projectOwner": Meteor.userId()})


Template.projectInformationTemplate.events
	'blur .prj-info-title': (e,t) ->
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

	'click .prj-information-box': (e,t) ->
		data = {
			completed: !@completed
		}

		Meteor.call "update_project", @_id, data, (error) ->
			if error
				sys.flashError()
				console.log ("Error changing the project completion value")
				console.warn(error)
			else
				sys.flashSuccess()

##########################################