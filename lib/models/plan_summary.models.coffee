##########################################
if Meteor.isServer
	syssrv.createPlanSummary = (userId, projectId, levelPSP) ->
		timePlanSummary = Meteor.settings.public.timeEstimated
		Injected = Meteor.settings.public.InjectedEstimated
		Removed = Meteor.settings.public.RemovedEstimated

		# Definition of a empty baseLOC data for a new project
		baseSize = [{
			"Estimated": { name: "", base: 0, add: 0, modified: 0, deleted: 0 }
			"Actual": { base: 0, add: 0, modified: 0, deleted: 0 }
		}]
		addSize = [{
			"Estimated": { name: "", type: "Elegir", items: 0, relSize: "Elegir", size: 0, nr: false }
			"Actual": { items: 0, size: 0, nr: false }
		}]
		reusedSize = [{
			"Estimated": { name: "", size: 0 }
			"Actual": { size: 0 }
		}]

		#If the project is PSP 2 it will add the 2 missing stages
		if levelPSP == 'PSP 2'
			timePlanSummary.splice(2, 0, {"name":"Revisión Diseño", "finished":false, "time":0})
			timePlanSummary.splice(4, 0, {"name":"Revisión Código", "finished":false, "time":0})

			Injected.splice(2, 0, {"name":"Revisión Diseño", "injected":0, "estimated": 0})
			Injected.splice(4, 0, {"name":"Revisión Código", "injected":0, "estimated": 0})

			Removed.splice(2, 0, {"name":"Revisión Diseño", "removed":0, "estimated": 0})
			Removed.splice(4, 0, {"name":"Revisión Código", "removed":0, "estimated": 0})

		user = db.users.findOne({_id: Meteor.userId()}).profile
		historyTotalTime = user.total.time
		historyTotalInjected = user.total.injected
		historyTotalRemoved = user.total.removed

		finishedProjects = db.projects.find({"projectOwner": Meteor.userId()}, "completed": true).count()

		# This will add to the time the toDate and toDate% fields for the Plan Summary
		finalTime = _.filter timePlanSummary, (time) ->
			onDate = _.findWhere user.summaryAmount, {name: time.name}
			time.toDate = onDate.time
			if (onDate.time == 0) or (historyTotalTime == 0)
				time.percentage = 0
				time.average = 0
			else
				time.percentage = ((onDate.time * 100) / historyTotalTime).toFixed(2)
				time.average = (onDate.time/finishedProjects).toFixed(2)

			return time
		#console.log finalTime

		finalInjected = _.filter Injected, (injected) ->
			onDate = _.findWhere user.summaryAmount, {name: injected.name}
			injected.toDate = onDate.injected
			if (onDate.injected == 0) or (historyTotalInjected == 0)
				injected.percentage = 0
			else
				injected.percentage = ((onDate.injected * 100) / historyTotalInjected).toFixed(2)
			return injected

		finalRemoved = _.filter Removed, (removed) ->
			onDate = _.findWhere user.summaryAmount, {name: removed.name}
			removed.toDate = onDate.removed
			if (onDate.removed == 0) or (historyTotalRemoved == 0)
				removed.percentage = 0
			else
				removed.percentage = ((onDate.removed * 100) / historyTotalRemoved).toFixed(2)
			return removed


		data = {
			summaryOwner: userId
			projectId: projectId
			createdAt: new Date()
			timeEstimated: finalTime
			injectedEstimated: finalInjected
			removedEstimated: finalRemoved
			baseLOC: baseSize
			addLOC: addSize
			reusedLOC: reusedSize
			total:
				totalTime: 0
				estimatedTime: 0,
				estimatedBase: 0,
				actualBase: 0,
				estimatedAdd: 0,
				actualAdd: 0,
				estimatedModified: 0,
				actualModified: 0,
				estimatedDeleted: 0,
				actualDeleted: 0,
				estimatedReused: 0,
				actualReused: 0
		}

		db.plan_summary.insert(data)


	syssrv.modifyTime = (projectId, stage_name, time, add_time) ->
		planSummary = db.plan_summary.findOne({"projectId": projectId})
		timeEstimated = planSummary?.timeEstimated
		currentStage = _.findWhere timeEstimated, {name: stage_name}

		if add_time
			currentStage.time += time
			planSummary.total.totalTime += time
		else
			if time >= currentStage.time
				planSummary.total.totalTime -= currentStage.time
				currentStage.time = 0
			else
				currentStage.time -= time
				planSummary.total.totalTime -= time

		data = {
			"timeEstimated": timeEstimated
			"total.totalTime": planSummary.total.totalTime
		}

		db.plan_summary.update({"projectId": projectId}, {$set: data})


##########################################