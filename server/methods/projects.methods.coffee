##########################################
Meteor.methods
	create_project: (data) ->
		amountProjects = db.projects.find({"projectOwner": Meteor.userId()}).count()
		data.color = sys.selectColor(amountProjects)

		# The _.extend adds to data the projectOwner value.
		data = _.extend data, {projectOwner: Meteor.userId()}
		db.projects.insert(data)


	delete_project: (pid, delete_iterations=false) ->
		# This removes the time information of this project from
		# The users complete data recolection.
		user = db.users.findOne({_id: Meteor.userId()}).profile
		planSummary = db.plan_summary.findOne({"summaryOwner": Meteor.userId(), "projectId": pid})
		amountDefects = db.defects.find({'projectId': pid}).count()






		if delete_iterations
			# It enteres here if the project has iterations
			console.log "I will delete a iteration"
			iterations = db.projects.find({"parentId": pid})

			iterations.forEach (project) ->
				if project.completed
					#Hacer que el plansummary usado sea el del foreach y no el de arriba
					console.log "soy una iteracion completada: " + project._id
					iterationTime = _.filter user.summaryAmount, (time) ->
						planTime = _.findWhere planSummary.timeEstimated, {name: time.name}
						planInjected = _.findWhere planSummary.injectedEstimated, {name: time.name}
						planRemoved = _.findWhere planSummary.removedEstimated, {name: time.name}

						time.time -= planTime.time
						time.injected -= planInjected.injected
						time.removed -= planRemoved.removed
						return time

					data = {
						"profile.total.time": user.total.time - planSummary.total.totalTime
						"profile.total.injected": user.total.injected - amountDefects
						"profile.total.removed": user.total.removed - amountDefects
						"profile.summaryAmount": iterationTime
					}
					db.users.update({_id: Meteor.userId()}, {$set: data})


					console.log "llegue aqui a eliminar a " + project.projectId
					db.defects.remove({ "projectId": project.projectId })
					db.plan_summary.remove({ "projectId": project.projectId })







		if db.projects.findOne({_id: pid})?.completed
			console.log "soy un proyect completado"

			# This takes The user general data and removes this projects
			# time recolected information.
			finalTime = _.filter user.summaryAmount, (time) ->
				planTime = _.findWhere planSummary.timeEstimated, {name: time.name}
				planInjected = _.findWhere planSummary.injectedEstimated, {name: time.name}
				planRemoved = _.findWhere planSummary.removedEstimated, {name: time.name}

				time.time -= planTime.time
				time.injected -= planInjected.injected
				time.removed -= planRemoved.removed
				return time

			data = {
				"profile.total.time": user.total.time - planSummary.total.totalTime
				"profile.total.injected": user.total.injected - amountDefects
				"profile.total.removed": user.total.removed - amountDefects
				"profile.summaryAmount": finalTime
			}
			db.users.update({_id: Meteor.userId()}, {$set: data})

		console.log "llegue a eliminar el proyecto master"
		db.projects.remove({ _id: pid })
		db.defects.remove({ "projectId": pid })
		db.plan_summary.remove({ "projectId": pid })


	#This function update the values of a project like its title and description
	update_project: (pid, value) ->
		db.projects.update({ _id: pid }, {$set: value})

##########################################