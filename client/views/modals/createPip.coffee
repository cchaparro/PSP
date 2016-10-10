##################################
# titleStatus true is Create title and false is Modify title
titleStatus = new ReactiveVar(true)
pipData = new ReactiveVar({})
pipId = new ReactiveVar('')

###########################################
Template.createPipModal.helpers
	displayTitle: () ->
		if titleStatus.get()
			return "Crear nuevo PIP"
		else
			return "Modificar PIP Existente"

###########################################
Template.createPip.onCreated () ->
	#Error for missing fields
	@problemError = new ReactiveVar(false)
	@solutionError = new ReactiveVar(false)
	@titleError = new ReactiveVar(false)
	# Start data clean when you open a defect modal
	titleStatus.set(true)
	pipId.set('')
	pipData.set({})

	if @data
		pipId.set(@data._id)
		pipData.set(@data)
		titleStatus.set(false)
	else
		pipData.set({
			"title":""
			"problemDescription":""
			"proposalDescription":""			
		})


Template.createPip.helpers
	pipData: () ->
		return pipData.get()

	problemError: () ->
		return Template.instance().problemError.get()

	solutionError: () ->
		return Template.instance().solutionError.get()

	titleError: () ->
		return Template.instance().titleError.get()

	ifLoadsData: () ->
		return titleStatus.get()

	projectIsCompleted: () ->
		return db.projects.findOne({ _id: FlowRouter.getParam("id") })?.completed

	userDefects:()->
		#Users Type of defects
		#userDefects=db.defect_types.findOne({"defectTypeOwner": Meteor.userId()})?.defects
		defectTypes = []
		#_.each userDefects,(defect)->
		#	defectTypes.push(defect?.name)
		#################################################################################
		#Types of the created defects in this project
		projectDefects=db.defects.find({"defectOwner": Meteor.userId(), "projectId": FlowRouter.getParam("id")}).fetch()		
		_.each projectDefects,(defect) ->
			defectTypes.push(defect?.typeDefect)
		return defectTypes

Template.createPip.events
	'keypress .problem-pip': (e,t) ->
		if $(e.target).val().length > 0
			t.problemError.set(false)

	'keypress .solution-pip': (e,t) ->
		if $(e.target).val().length > 0
			t.solutionError.set(false)
		

	'keypress .pip-new-title': (e,t) ->
		if $(e.target).val().length > 0
			t.titleError.set(false)
		
	'click .pry-modal-create': (e,t) ->
		PipId = pipId.get()
		PipModalData = pipData.get()
		PipModalData.title = $('.pip-new-title').val()
		PipModalData.problemDescription = $('.problem-pip').val()
		PipModalData.proposalDescription = $('.solution-pip').val()

		data = {
			"pipOwner": Meteor.userId()
			"projectId": FlowRouter.getParam("id")
			"createdAt": new Date()
		}
		data = _.extend PipModalData, data

		solutionErrorField = Template.instance().solutionError.get()
		problemErrorField = Template.instance().problemError.get()
		titleError = Template.instance().titleError.get()

		if (!(solutionErrorField and problemErrorField and titleError) and data.problemDescription.trim().length != 0 and data.proposalDescription.trim().length != 0 and data.title.trim().length != 0)
			Meteor.call "create_pip",PipId, data, false, (error) ->
				if error
					console.warn(error)
					sys.flashStatus("error-create-defect")
				else
					Modal.hide('createPipModal')
					sys.flashStatus("create-defect")
		else
			Template.instance().solutionError.set(data.proposalDescription.trim().length == 0)
			Template.instance().problemError.set(data.problemDescription.trim().length == 0)
			Template.instance().titleError.set(data.title.trim().length == 0)
# #################################