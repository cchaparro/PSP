##########################################
drawProjectInfoChart = () ->
	projectStages = db.plan_summary.findOne("projectId": FlowRouter.getParam("id"), "summaryOwner": Meteor.userId())?.timeEstimated
	colors = Meteor.settings.public.chartColors

	data = []
	color_position = 0
	_.each projectStages, (stage) ->
		juan = {}
		juan['value']= stage.time
		juan['label']= stage.name
		juan['color']= colors[color_position]
		data.push(juan)
		color_position += 1

	# {
	# 	value: 10
	# 	color: '#094074'
	# 	highlight: '#094074'
	# 	label: 'Planeación'
	# }

	ctx = $('#projectInformationChart').get(0).getContext('2d')
	myNewChart = new Chart(ctx)
	new Chart(ctx).Pie(data)

##########################################
Template.projectInformationChart.onRendered () ->
	drawProjectInfoChart()

##########################################
Template.projectInformationTemplate.onCreated () ->
	@informationState = new ReactiveVar(false)


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

	displayInformation: () ->
		return Template.instance().informationState.get()


Template.projectInformationTemplate.events
	'blur .prj-info-title': (e,t) ->
		data = {
			"title": $('.prj-info-title').text()
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
			"description": $('.prj-info-description').text()
		}

		Meteor.call "update_project", FlowRouter.getParam("id"), set, (error)->
			if error
				sys.flashError()
				console.log ("Error updating the projects description")
				console.warn(error)
			else
				sys.flashSuccess()

	'click .project-active': (e,t) ->
		Meteor.call "update_project", @_id, { completed: !@completed }, (error) ->
			if error
				sys.flashError()
				console.warn(error)
			else
				Meteor.call "update_user_plan_summary", FlowRouter.getParam("id"), (error) ->
					if error
						console.warn(error)
					else
						sys.flashSuccess()

	'click svg': (e,t) ->
		t.informationState.set(!t.informationState.get())

	'click .information-box-header span': (e,t) ->
		t.informationState.set(false)

##########################################