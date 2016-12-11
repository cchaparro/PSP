##########################################
Meteor.methods
	create_project: (data) ->
		check(data, Object)
		syssrv.createProject(data)

	delete_project: (projectId, delete_iterations=false) ->
		check(projectId, String)
		check(delete_iterations, Boolean)

		if delete_iterations
			projectIterations = db.projects.find({"parentId": projectId})

			# This deletes each iteration of the deleted project
			projectIterations.forEach (iteration) ->
				syssrv.deleteProject(iteration._id)

		# This deletes the master project
		syssrv.deleteProject(projectId)


	update_project: (projectId, value) ->
		#This function update the values of a project like its title, description and completed field
		db.projects.update({ _id: projectId }, {$set: value})


	#This is used to finish a project and store his data in the users history
	finish_project: (projectId) ->
		check(projectId, String)

		currentDate = new Date()

		#Sets the project to completed
		db.projects.update({ _id: projectId }, {$set: {completed: true, completedAt: currentDate}})
		#Stores the projects data with the users history values
		syssrv.projectDataToUserHistory(projectId)

##########################################