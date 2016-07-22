##########################################
Meteor.methods
	create_project: (data) ->
		syssrv.createProject(data)

	delete_project: (pid, delete_iterations=false) ->
		if delete_iterations
			iterations = db.projects.find({"parentId": pid})

			iterations.forEach (project) ->
				syssrv.deleteProject(project._id)

		# This deletes the master project
		syssrv.deleteProject(pid)


	update_project: (projectId, value) ->
		#This function update the values of a project like its title and description
		db.projects.update({ _id: projectId }, {$set: value})

##########################################