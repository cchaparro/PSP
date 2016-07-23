##########################################
Meteor.methods
	create_project: (data) ->
		syssrv.createProject(data)

	delete_project: (projectId, delete_iterations=false) ->
		if delete_iterations
			projectIterations = db.projects.find({"parentId": projectId})

			# This deletes each iteration of the deleted project
			projectIterations.forEach (iteration) ->
				syssrv.deleteProject(iteration._id)

		# This deletes the master project
		syssrv.deleteProject(projectId)


	update_project: (projectId, value) ->
		#This function update the values of a project like its title and description
		db.projects.update({ _id: projectId }, {$set: value})

##########################################