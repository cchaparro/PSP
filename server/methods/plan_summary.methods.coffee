#######################################
Meteor.methods
	create_plan_summary: (uid, pid, psplevel) ->
		timePlanSummary = Meteor.settings.public.timeEstimated
		Injected = Meteor.settings.public.InjectedEstimated
		Removed = Meteor.settings.public.RemovedEstimated

		if psplevel == 'PSP 2'
			timePlanSummary.splice(2, 0, {"name":"Revisión Diseño", "finished":false, "time":0})
			timePlanSummary.splice(4, 0, {"name":"Revisión Código", "finished":false, "time":0})

			Injected.splice(2, 0, {"name":"Revisión Diseño", "injected":0, "estimated": 0})
			Injected.splice(4, 0, {"name":"Revisión Código", "injected":0, "estimated": 0})

			Removed.splice(2, 0, {"name":"Revisión Diseño", "removed":0, "estimated": 0})
			Removed.splice(4, 0, {"name":"Revisión Código", "removed":0, "estimated": 0})

		user = db.users.findOne({_id: Meteor.userId()}).profile
		historyTotalTime = user.total.time

		# This will add to the time the toDate and toDate% fields for the Plan Summary
		finalTime = _.filter timePlanSummary, (time) ->
			onDate = _.findWhere user.summaryAmount, {name: time.name}
			time.toDate = onDate.time
			if (onDate.time == 0) or (historyTotalTime == 0)
				time.percentage = 0
			else
				time.percentage = ((onDate.time * 100) / historyTotalTime).toFixed(2)
			return time

		data = {
			summaryOwner: uid
			projectId: pid
			createdAt: new Date()
			timeEstimated: finalTime
			injectedEstimated: Injected
			removedEstimated: Removed
			total:
				totalTime: 0
				estimatedTime: 0
		}

		db.plan_summary.insert(data)

	update_plan_summary: (pid, data) ->
		db.plan_summary.update({"projectId": pid, "summaryOwner": Meteor.userId()}, {$set: data})


	#This is for completing a stage or updating the time of the current stage
	update_time_stage: (pid, stage, finishStage=false) ->
		planSummary = db.plan_summary.findOne({"projectId": pid, "summaryOwner": Meteor.userId()})

		# the input stage is the stage that just had a new amount of time registered
		currentStage = _.findWhere planSummary.timeEstimated, {name: stage.name}
		currentStage.time = stage.time + currentStage.time

		if finishStage
			currentStage.finished = true

		data = {
			"timeEstimated": planSummary.timeEstimated
			"total.totalTime": planSummary.total.totalTime + stage.time
		}

		db.plan_summary.update({"projectId": pid}, {$set: data})
#######################################