#######################################
Meteor.methods
	# # This is used for the Plan Summary Total Amount
	update_user_plan_summary: (pid) ->
		user = db.users.findOne({_id: Meteor.userId()}).profile
		planSummary = db.plan_summary.findOne({"summaryOwner": Meteor.userId(), "projectId": pid})

		userTime = user?.summaryAmount
		planSummaryFinalTime = planSummary?.timeEstimated

		finalTime = _.filter userTime, (time) ->
			planTime = _.findWhere planSummaryFinalTime, {name: time.name}
			time.time += planTime.time
			return time

		data = {
			"profile.total.time": user.total.time + planSummary.total.totalTime
			"profile.summaryAmount": finalTime
		}

		db.users.update({_id: Meteor.userId()}, {$set: data})

#######################################