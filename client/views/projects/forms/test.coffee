##########################################
Template.testTemplate.helpers
	userTests: () ->		
		return db.testReports.find({"TestOwner": Meteor.userId(), "projectId": FlowRouter.getParam("id")}).fetch()

	projectIsCompleted: () ->
		return db.projects.findOne({ _id: FlowRouter.getParam("id") })?.completed


Template.testTemplate.events
	'click .edit-test': (e,t) ->
		Modal.show('createTestModal', @)

	'click .delete-test': (e,t) ->
		Meteor.call "create_test_report", @_id, null, true, (error) ->		
			if error
				console.log "Error deleting a defect"
			else
				sys.flashStatus("delete-defect")

##########################################