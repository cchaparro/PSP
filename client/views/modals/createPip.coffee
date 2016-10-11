#########################
# titleStatus true is Create title and false is Modify title
titleStatus = new ReactiveVar(true)
pipData = new ReactiveVar({})
pipDefects = new ReactiveVar([])
pipId = new ReactiveVar('')
###########################################
Template.createPipModal.helpers
	displayTitle: () ->
		if titleStatus.get()
			return "Crear nuevo PIP"
		else
			return "Modificar PIP"

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
	pipDefects.set([])
	#Open existing PIP
	if @data
		pipId.set(@data._id)
		pipData.set(@data)
		titleStatus.set(false)
		data = @data.defectsSolved
		defectTypes = []
		_.each data, (value,index) ->
			defectTypes.push({
				"position":index,
				"type":value.DefectType,
				"selected": value.Solved})
		pipDefects.set(defectTypes)
	#New PIP
	else
		defectTypes = []		
		actualProjectDefects = db.projects.findOne({_id:FlowRouter.getParam("id")})?.defectTypesId
		projectDefects=db.defect_types.findOne({_id:actualProjectDefects,"defectTypeOwner": Meteor.userId()})?.defects
		index = 0
		_.each projectDefects,(defect) ->
			if _.findWhere(defectTypes, {"type":defect?.name}) == undefined
				defectTypes.push({
					"position":index,
					"type":defect?.name,
					"selected":false
					})
				index+=1
		pipDefects.set(defectTypes)
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

	isChecked: (checked) ->
		# Used to return to the input type="checked" if its checked or not
		return "checked" or "" if checked

	hasDefects: ()->
		defects = pipDefects.get()
		return defects.length>0

	userDefects:()->
		return pipDefects.get()


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

	'click .add-checkbox':(e,t)->
		data = pipDefects.get()
		value = $(e.target).is(":checked")		
		data[@position].selected = value
		pipDefects.set(data)		
		
	'click .pry-modal-create': (e,t) ->
		PipId = pipId.get()
		PipModalData = pipData.get()
		PipModalData.title = $('.pip-new-title').val()
		PipModalData.problemDescription = $('.problem-pip').val()
		PipModalData.proposalDescription = $('.solution-pip').val()
		defectTypes = pipDefects.get()
		finalDefects = _.map defectTypes, (value) ->
			return {"DefectType": value.type, "Solved": value.selected}
		data = {
			"pipOwner": Meteor.userId()
			"projectId": FlowRouter.getParam("id")
			"createdAt": new Date()
			"defectsSolved": finalDefects
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
# ##############################