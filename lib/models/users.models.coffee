##########################################
if Meteor.isServer
	syssrv.projectDataToUserHistory = (projectId) ->
		userId = Meteor.userId()
		user = db.users.findOne({ _id: userId }).profile
		planSummary = db.plan_summary.findOne({ projectId: projectId, summaryOwner: userId })
		amountDefects = db.defects.find({projectId: projectId}).count()

		#newTime is the new user time history data that will be in the user db file
		currentUserTime = user.summaryAmount
		projectTime = planSummary.timeEstimated
		projectInjected = planSummary.injectedEstimated
		projectRemoved = planSummary.removedEstimated

		#This gets the new user profile values after completing a project
		newTime = _.filter currentUserTime, (stageTime) ->
			plannedTime = _.findWhere projectTime, {name: stageTime.name}
			planInjected = _.findWhere projectInjected, {name: stageTime.name}
			planRemoved = _.findWhere projectRemoved, {name: stageTime.name}

			#This adds from the current user history time the project just completed time data
			if plannedTime
				stageTime.time += plannedTime.time
				stageTime.injected += planInjected.injected
				stageTime.removed += planRemoved.removed

			#In the case that plannedTime doesnt get the "PSP 2" stages then this values will just be the ones that are already in the user histtory
			return stageTime

		#This adds yo the user profile values the new size amount from the completed project
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
			"profile.summaryAmount": newTime
			"profile.sizeAmount": finalSizeAmount
		}

		db.users.update({_id: userId}, {$set: data})

		#This disables all the completed project opened time notifications
		syssrv.disableTimeNotifications(planSummary._id)

##########################################