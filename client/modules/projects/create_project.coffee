colors = ["#587291", "#00c1ed", "#00d5b6", "#ff8052", "#ffb427", "#F1E8B8", "#799e9c", "#91cda5"]

colorSelector = () ->
	userId = Meteor.userId()
	amountProjects = db.projects.find({projectOwner: userId}).count() % 8
	return colors[amountProjects]

Template.createProjectModal.onCreated () ->
	@levelPSP = new ReactiveVar("PSP 0")
	@selectedColor = new ReactiveVar(colorSelector())
	@hasError = new ReactiveVar({title: false, description: false})


Template.createProjectModal.helpers
	currentPSPLevel: () ->
		t = Template.instance()
		return t.levelPSP.get()

	titleError: () ->
		t = Template.instance()
		error = t.hasError.get()
		return error.title

	descriptionError: () ->
		t = Template.instance()
		error = t.hasError.get()
		return error.description


	projectColors: () ->
		t = Template.instance()
		colorOption = t.selectedColor.get()

		data = _.map colors, (color, index) ->
			return {
				selected: color is colorOption
				color: color
			}

		return data


Template.createProjectModal.events
	'click .project-color-option': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		t.selectedColor.set(@color)

	'click .project-level-option': (e,t) ->
		e.preventDefault()
		level = $(e.target).data('value')
		t.levelPSP.set(level)

	'keypress .project-title': (e,t) ->
		title = t.$(e.target).val()
		error = t.hasError.get()
		unless title
			error.title = false
		t.hasError.set(error)

	'keypress .project-description': (e,t) ->
		title = t.$(e.target).val()
		error = t.hasError.get()
		unless title
			error.description = false
		t.hasError.set(error)

	'click .project-create': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		error = t.hasError.get()

		title = $('.project-title').val()
		description = $('.project-description').val()
		levelPSP = t.levelPSP.get()
		selectedColor = t.selectedColor.get()

		data = {
			title: title
			description: description
			levelPSP: levelPSP
			color: selectedColor
			parentId: null
		}

		unless title
			error.title = true
		unless description
			error.description = true

		t.hasError.set(error)

		unless error.title or error.description
			Meteor.call "create_project", data, (error)->
				if error
					console.warn(error)
					sys.flashStatus("create-project-error")
				else
					Modal.hide('createProject')
					sys.flashStatus("create-project-successful")
