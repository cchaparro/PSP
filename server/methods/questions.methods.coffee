##########################################
Meteor.methods
	create_question: (data) ->
		syssrv.createQuestion(data)

	delete_question: (projectId, delete_iterations=false) ->
		# if delete_iterations
		# 	projectIterations = db.projects.find({"parentId": projectId})

		# 	# This deletes each iteration of the deleted project
		# 	projectIterations.forEach (iteration) ->
		# 		syssrv.deleteProject(iteration._id)

##########################################