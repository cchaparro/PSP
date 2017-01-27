selectedOption = new ReactiveVar("pipsTemplate")


Template.formTemplate.helpers
	template: () ->
		return selectedOption.get()


Template.pipsTemplate.onCreated () ->
	@hoveredPip = new ReactiveVar(false)


Template.pipsTemplate.helpers
	pips: () ->
		userId = Meteor.userId()
		projectId = FlowRouter.getParam("id")
		return db.pips.find({pipOwner: userId, projectId: projectId})

	amountPips: () ->
		userId = Meteor.userId()
		projectId = FlowRouter.getParam("id")
		return db.pips.find({pipOwner: userId, projectId: projectId})?.count() != 0

	projectColor: () ->
		projectId = FlowRouter.getParam("id")
		return db.projects.findOne({_id: projectId})?.color

	hoverIcon: () ->
		t = Template.instance()
		hoverStatus = t.hoveredPip.get()
		pipId = @_id

		if hoverStatus == pipId
			return 'arrow_back'
		else
			return 'clear'

	projectCompleted: () ->
		projectId = FlowRouter.getParam("id")
		return db.projects.findOne({ _id: projectId})?.completed

Template.pipsTemplate.events
	'click .clear': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		pipId = @_id

		t.hoveredPip.set(pipId)
		$(".project-box").removeClass("project-box-hover")
		t.$(e.target).closest(".project-box").addClass("project-box-hover")

	'click .arrow_back': (e,t) ->
		e.preventDefault()
		e.stopPropagation()

		t.hoveredPip.set(false)
		$(".project-box").removeClass("project-box-hover")

	'click .pip-content': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		Modal.show('createPipModal', @)

	'click .confirm-delete-project': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		pipId = @_id

		Meteor.call "create_pip", pipId, null, true, (error) ->		
			if error
				sys.flashStatus("delete-pip-error")
			else
				sys.flashStatus("delete-pip-successful")


Template.testTemplate.onCreated () ->
	@hoveredTest = new ReactiveVar(false)


Template.testTemplate.helpers
	amountTests: () ->
		userId = Meteor.userId()
		projectId = FlowRouter.getParam("id")
		return db.testReports.find({TestOwner: userId, projectId: projectId})?.count() != 0

	tests: () ->
		userId = Meteor.userId()
		projectId = FlowRouter.getParam("id")
		return db.testReports.find({TestOwner: userId, projectId: projectId})

	projectColor: () ->
		projectId = FlowRouter.getParam("id")
		return db.projects.findOne({_id: projectId})?.color

	hoverIcon: () ->
		t = Template.instance()
		hoverStatus = t.hoveredTest.get()
		testId = @_id

		if hoverStatus == testId
			return 'arrow_back'
		else
			return 'clear'

	projectCompleted: () ->
		projectId = FlowRouter.getParam("id")
		return db.projects.findOne({ _id: projectId})?.completed


Template.testTemplate.events
	'click .clear': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		testId = @_id

		t.hoveredTest.set(testId)
		$(".project-box").removeClass("project-box-hover")
		t.$(e.target).closest(".project-box").addClass("project-box-hover")

	'click .arrow_back': (e,t) ->
		e.preventDefault()
		e.stopPropagation()

		t.hoveredTest.set(false)
		$(".project-box").removeClass("project-box-hover")

	'click .pip-content': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		Modal.show('createTestModal', @)

	'click .confirm-delete-project': (e,t) ->
		e.preventDefault()
		e.stopPropagation()
		testId = @_id

		Meteor.call "create_test_report", testId, null, true, (error) ->		
			if error
				sys.flashStatus("delete-test-error")
			else
				sys.flashStatus("delete-test-successful")


Template.createFormAction.helpers
	isPip: () ->
		selectedOption.get() == "pipsTemplate"

	isTest: () ->
		selectedOption.get() == "testTemplate"

	projectIsCompleted: () ->
		projectId = FlowRouter.getParam("id")
		return db.projects.findOne({ _id: projectId})?.completed


Template.createFormAction.events
	'click .create-pip': (e,t) ->
		e.stopPropagation()
		e.preventDefault()
		Modal.show('createPipModal')

	'click .create-report': (e,t) ->
		e.stopPropagation()
		e.preventDefault()
		Modal.show('createTestModal')

	'click .change-to-pip': (e,t) ->
		e.stopPropagation()
		e.preventDefault()
		selectedOption.set("pipsTemplate")

	'click .change-to-test': (e,t) ->
		e.stopPropagation()
		e.preventDefault()
		selectedOption.set("testTemplate")
		