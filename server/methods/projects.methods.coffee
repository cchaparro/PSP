##########################################
Meteor.methods
	create_project: (data) ->
		data = _.extend data, {projectOwner: Meteor.userId()}

		db.projects.insert(data)

	delete_project: (pid) ->
		db.projects.remove({ _id: pid })
		db.defects.remove({ "projectId": pid })

	#This function update the values of a project like its title and description
	update_project: (pid, value) ->
		db.projects.update({ _id: pid }, {$set: value})

##########################################