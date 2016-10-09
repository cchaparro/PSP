##########################################
Template.formTemplate.onCreated () ->
	@selectedOption = new ReactiveVar("pipTemplate")


Template.formTemplate.helpers
	template: () ->
		return Template.instance().selectedOption.get()

	isPip: () ->
		Template.instance().selectedOption.get() == "pipTemplate"

	isTest: () ->
		Template.instance().selectedOption.get() == "testTemplate"

	projectIsCompleted: () ->
		return db.projects.findOne({ _id: FlowRouter.getParam("id") })?.completed

	noPipsAvailable: () ->
		return db.pips.find({"pipOwner": Meteor.userId(), "projectId": FlowRouter.getParam("id")})?.count() == 0

	noTestAvailable: () ->
		return db.testReports.find({"TestOwner": Meteor.userId(), "projectId": FlowRouter.getParam("id")})?.count() == 0

Template.formTemplate.events
	'click .pip-option': (e,t) ->
		e.stopPropagation()
		e.preventDefault()
		t.selectedOption.set("pipTemplate")

	'click .test-option': (e,t) ->
		e.stopPropagation()
		e.preventDefault()
		t.selectedOption.set("testTemplate")

	'click .create-pip': (e,t) ->
		e.stopPropagation()
		e.preventDefault()
		Modal.show('createPipModal')

	'click .create-test': (e,t) ->
		e.stopPropagation()
		e.preventDefault()
		Modal.show('createTestModal')		

##########################################