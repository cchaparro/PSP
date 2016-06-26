##########################################
Meteor.methods
	create_project: (data) ->
		data = _.extend data, {projectOwner: Meteor.userId()}
		db.projects.insert(data)


	delete_project: (pid) ->
		# This removes the time information of this project from
		# The users complete data recolection
		user = db.users.findOne({_id: Meteor.userId()}).profile
		planSummary = db.plan_summary.findOne({"summaryOwner": Meteor.userId(), "projectId": pid})
		userTime = user?.summaryAmount
		planSummaryFinalTime = planSummary?.timeEstimated

		finalTime = _.filter userTime, (time) ->
			planTime = _.findWhere planSummaryFinalTime, {name: time.name}
			time.time -= planTime.time
			return time

		data = {
			"profile.total.time": user.total.time - planSummary.total.totalTime
			"profile.summaryAmount": finalTime
		}

		db.users.update({_id: Meteor.userId()}, {$set: data})
		db.projects.remove({ _id: pid })
		db.defects.remove({ "projectId": pid })
		db.plan_summary.remove({ "projectId": pid })


	#This function update the values of a project like its title and description
	update_project: (pid, value) ->
		db.projects.update({ _id: pid }, {$set: value})

##########################################