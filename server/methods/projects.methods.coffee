##########################################
Meteor.methods
	create_project: (data) ->
		amountProjects = db.projects.find({"projectOwner": Meteor.userId()}).count()
		data.color = sys.selectColor(amountProjects)

		# The _.extend adds to data the projectOwner value.
		data = _.extend data, {projectOwner: Meteor.userId()}
		db.projects.insert(data)


	delete_project: (pid, delete_iterations=false) ->
		if delete_iterations
			iterations = db.projects.find({"parentId": pid})

			iterations.forEach (project) ->
				syssrv.deleteProject(project._id)

		# This deletes the master project
		syssrv.deleteProject(pid)



	#This function update the values of a project like its title and description
	update_project: (pid, value) ->
		db.projects.update({ _id: pid }, {$set: value})

##########################################