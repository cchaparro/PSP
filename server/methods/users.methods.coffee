#######################################
Meteor.methods
	# This is used for the Plan Summary Total Amount
	update_user_plan_summary: (pid) ->
		user = db.users.findOne({_id: Meteor.userId()}).profile
		planSummary = db.plan_summary.findOne({"summaryOwner": Meteor.userId(), "projectId": pid})
		amountDefects = db.defects.find({'projectId': pid}).count()

		finalTime = _.filter user.summaryAmount, (time) ->
			planTime = _.findWhere planSummary.timeEstimated, {name: time.name}
			planInjected = _.findWhere planSummary.injectedEstimated, {name: time.name}
			planRemoved = _.findWhere planSummary.removedEstimated, {name: time.name}

			if planTime
				time.time += planTime.time
				time.injected += planInjected.injected
				time.removed += planRemoved.removed
				return time
		finalSizeAmount = {
			"base": user.sizeAmount.base + planSummary.total.actualBase
			"add": user.sizeAmount.add + planSummary.total.actualAdd
			"modified": user.sizeAmount.modified + planSummary.total.actualModified
			"deleted": user.sizeAmount.deleted + planSummary.total.actualDeleted
			"reused": user.sizeAmount.reused + planSummary.total.actualReused
		}
		data = {
			"profile.total.time": user.total.time + planSummary.total.totalTime
			"profile.total.injected": user.total.injected + amountDefects
			"profile.total.removed": user.total.removed + amountDefects
			"profile.total.size": user.total.size + planSummary.total.totalSize
			"profile.summaryAmount": finalTime
			"profile.sizeAmount": finalSizeAmount
		}

		db.users.update({_id: Meteor.userId()}, {$set: data})

	change_project_settings: () ->
		userSettings = db.users.findOne({_id: Meteor.userId()}).settings

		data = {
			"settings.probeC": !userSettings.probeC
			"settings.probeD": !userSettings.probeD
		}
		db.users.update({_id: Meteor.userId()}, {$set: data})


	update_user_public_info: (userId, data, fileId) ->
		db.Images.remove({_id: {$ne: fileId}, userId: userId})
		db.users.update({_id: userId}, {$set: data})

#######################################