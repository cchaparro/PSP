##########################################
projectFields = new ReactiveVar([])
##########################################
drawProjectInfoChart = () ->
	projectStages = db.plan_summary.findOne("projectId": FlowRouter.getParam("id"), "summaryOwner": Meteor.userId())?.timeEstimated
	colors = Meteor.settings.public.chartColors

	data = []
	chartFields = []
	color_position = 0
	_.each projectStages, (stage) ->
		chartFields.push({"name": stage.name, "color": colors[color_position]})
		data.push({"value": stage.time, "label": stage.name, "color": colors[color_position]})
		color_position += 1

	projectFields.set(chartFields)

	options = {
		animation : false
		showTooltips: false
	}

	ctx = $('#projectInformationChart').get(0).getContext('2d')
	ctx.canvas.width = 200
	ctx.canvas.height = 200
	# myNewChart = new Chart(ctx)
	new Chart(ctx).Doughnut(data, options)

##########################################
Template.projectInformationChart.onRendered () ->
	drawProjectInfoChart()
	#Tracker.autorun () ->
	#	if FlowRouter.current().route.name == 'projectView'
	#		console.log "Just Rendered drawProjectInfoChart()"
	#		drawProjectInfoChart()

Template.projectInformationChart.helpers
	chartFields: () ->
		console.log projectFields.get()
		return projectFields.get()

##########################################
Template.projectInformationTemplate.onCreated () ->
	@informationState = new ReactiveVar(false)
	Meteor.subscribe "projectView", FlowRouter.getParam("id")
	document.title = "Proyecto"

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
				sys.flashStatus("error-project")
				console.log ("Error updating the projects title")
				console.warn(error)
			else
				sys.flashStatus("save-project")

	'blur .prj-info-description': (e,t) ->
		set = {
			"description": $('.prj-info-description').text()
		}

		Meteor.call "update_project", FlowRouter.getParam("id"), set, (error)->
			if error
				sys.flashStatus("error-project")
				console.log ("Error updating the projects description")
				console.warn(error)
			else
				sys.flashStatus("save-project")

	'click .project-active': (e,t) ->
		Meteor.call "update_project", @_id, { completed: !@completed }, (error) ->
			if error
				sys.flashStatus("error-project")
				console.warn(error)
			else
				Meteor.call "update_user_plan_summary", FlowRouter.getParam("id"), (error) ->
					if error
						console.warn(error)
					else
						sys.flashStatus("save-project")

	'click svg': (e,t) ->
		t.informationState.set(!t.informationState.get())

	'click .information-box-header span': (e,t) ->
		t.informationState.set(false)

##########################################