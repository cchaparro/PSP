##########################################
Template.pipTemplate.helpers
	userPips: () ->		
		return db.pips.find({"pipOwner": Meteor.userId(), "projectId": FlowRouter.getParam("id")}).fetch()

	projectIsCompleted: () ->
		return db.projects.findOne({ _id: FlowRouter.getParam("id") })?.completed


Template.pipTemplate.events
	'click .edit-pip': (e,t) ->
		Modal.show('createPipModal', @)

	'click .delete-pip': (e,t) ->
		Meteor.call "create_pip", @_id, null, true, (error) ->		
			if error
				console.log "Error deleting a defect"
			else
				sys.flashStatus("delete-defect")

##########################################