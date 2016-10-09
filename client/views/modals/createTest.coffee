###########################################
# titleStatus true is Create title and false is Modify title
titleStatus = new ReactiveVar(true)
testData = new ReactiveVar({})
testId = new ReactiveVar('')

###########################################
Template.createTestModal.helpers
	displayTitle: () ->
		if titleStatus.get()
			return "Crear nuevo Reporte"
		else
			return "Modificar Reporte"

###########################################
Template.createTest.onCreated () ->
	#Error for missing fields
	@expectedError = new ReactiveVar(false)
	@actualError = new ReactiveVar(false)
	@titleError = new ReactiveVar(false)
	# Start data clean when you open a defect modal
	titleStatus.set(true)
	testId.set('')
	testData.set({})

	if @data
		testId.set(@data._id)
		testData.set(@data)
		titleStatus.set(false)
	else
		testData.set({
			"purpose":""
			"expectedResults":""
			"actualResults":""			
		})


Template.createTest.helpers
	testData: () ->
		return testData.get()

	expectedError: () ->
		return Template.instance().expectedError.get()

	actualError: () ->
		return Template.instance().actualError.get()

	titleError: () ->
		return Template.instance().titleError.get()

	ifLoadsData: () ->
		return titleStatus.get()

	projectIsCompleted: () ->
		return db.projects.findOne({ _id: FlowRouter.getParam("id") })?.completed

Template.createTest.events
	'keypress .expected-test': (e,t) ->
		if $(e.target).val().length > 0
			t.expectedError.set(false)

	'keypress .actual-test': (e,t) ->
		if $(e.target).val().length > 0
			t.actualError.set(false)

	'keypress .test-new-title': (e,t) ->
		if $(e.target).val().length > 0
			t.titleError.set(false)

	'click .pry-modal-create': (e,t) ->
		TestId = testId.get()
		TestModalData = testData.get()
		TestModalData.purpose = $('.test-new-title').val()
		TestModalData.expectedResults = $('.expected-test').val()
		TestModalData.actualResults = $('.actual-test').val()

		data = {
			"TestOwner": Meteor.userId()
			"projectId": FlowRouter.getParam("id")
			"createdAt": new Date()
		}
		data = _.extend TestModalData, data

		expectedErrorField = Template.instance().expectedError.get()
		actualErrorField = Template.instance().actualError.get()
		titleError = Template.instance().titleError.get()

		if (!(expectedErrorField and actualErrorField and titleError) and data.expectedResults.trim().length != 0 and data.actualResults.trim().length != 0 and data.purpose.trim().length != 0)
			Meteor.call "create_test_report",TestId, data, false, (error) ->
				if error
					console.warn(error)
					sys.flashStatus("error-create-defect")
				else
					Modal.hide('createTestModal')
					sys.flashStatus("create-defect")
		else
			Template.instance().expectedError.set(data.expectedResults.trim().length == 0)
			Template.instance().actualError.set(data.actualResults.trim().length == 0)
			Template.instance().titleError.set(data.purpose.trim().length == 0)

##########################################