projectFields = new ReactiveVar([])


drawProjectInfoChart = (chart_width) ->
	projectStages = db.plan_summary.findOne("projectId": FlowRouter.getParam("id"), "summaryOwner": Meteor.userId())
	colors = Meteor.settings.public.chartColors

	data = []
	chartFields = []
	color_position = 0
	_.each projectStages?.timeEstimated, (stage) ->
		chartFields.push({"name": stage.name, "color": colors[color_position]})
		data.push({"value": stage.time, "label": stage.name, "color": colors[color_position]})
		color_position += 1

	projectFields.set(chartFields)


	if projectStages?.total?.totalTime == 0
		# This point is only reached when the project has no time registered,
		# In that case it will show a full bar for the stage "Planeación"
		data = [{"value": 100, "label": "Planeación", "color": colors[0]}]

	options = {
		animation : false
		showTooltips: false
	}

	ctx = $('#projectInformationChart')?.get(0)?.getContext('2d')
	ctx?.canvas.width = chart_width
	ctx?.canvas.height = chart_width
	if ctx
		new Chart(ctx).Doughnut(data, options)



Template.projectInformationChart.onRendered () ->
	containerWidth = document.getElementById("project-general-chart").offsetWidth
	chartWidth = (containerWidth/2) - 20
	Deps.autorun ->
		drawProjectInfoChart(chartWidth)


Template.projectInformationChart.helpers
	chartFields: () ->
		return projectFields.get()


Template.projectInformationTemplate.onCreated () ->
	Meteor.subscribe "projectView", FlowRouter.getParam("id")


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

	projectClosed: () ->
		projectId = FlowRouter.getParam("id")
		return db.projects.findOne({ _id: projectId })?.completed

	colorProjectStatus: () ->
		projectId = FlowRouter.getParam("id")
		return 'background-danger' if db.projects.findOne({ _id: projectId })?.completed
		return 'background-success'


Template.projectInformationTemplate.events
	'blur .project-title': (e,t) ->
		unless @completed
			data = {
				"title": $('.project-title').text()
			}

			Meteor.call "update_project", FlowRouter.getParam("id"), data, (error)->
				if error
					console.warn(error)
					sys.flashStatus("project-title-save-error")
				else
					sys.flashStatus("project-title-save-successful")

	'blur .project-description': (e,t) ->
		unless @completed
			set = {
				"description": $('.project-description').text()
			}

			Meteor.call "update_project", FlowRouter.getParam("id"), set, (error)->
				if error
					console.warn(error)
					sys.flashStatus("project-description-save-error")
				else
					sys.flashStatus("project-description-save-successful")


Template.projectInformation.helpers
	isPostmortem: () ->
		planSummary = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})
		projectStages = _.filter planSummary?.timeEstimated, (stage) ->
			unless stage.finished
				return stage
		currentPos = _.first(projectStages)?.name

		return currentPos == "Postmortem" or projectStages.length == 0

	isPSP0: () ->
		return db.projects.findOne({"_id":FlowRouter.getParam("id")})?.levelPSP == "PSP 0"


Template.finishProjectAction.helpers
	projectClosed: () ->
		projectId = FlowRouter.getParam("id")
		return db.projects.findOne({ _id: projectId })?.completed

	actionTitle: () ->
		projectId = FlowRouter.getParam("id")
		parentId = db.projects.findOne({ _id: projectId })?.parentId
		if parentId
			return 'Finalizar Iteración'
		else
			return 'Finalizar Proyecto'


Template.finishProjectAction.events
	'click .close-project': (e,t) ->
		e.stopPropagation()
		e.preventDefault()
		projectId = FlowRouter.getParam("id")

		Meteor.call "finish_project", projectId, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("project-finish-error")
			else
				sys.flashStatus("project-finish-successful")
