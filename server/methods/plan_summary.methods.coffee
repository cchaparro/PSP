#######################################
Meteor.methods
	create_plan_summary: (uid, pid, psplevel) ->
		time = Meteor.settings.public.timeEstimated
		Injected = Meteor.settings.public.InjectedEstimated
		Removed = Meteor.settings.public.RemovedEstimated

		if psplevel == 'PSP 2'
			time.splice(2, 0, {"name":"Revisión Diseño", "finished":false, "time":0, "estimated": 0})
			time.splice(4, 0, {"name":"Revisión Código", "finished":false, "time":0, "estimated": 0})

			Injected.splice(2, 0, {"name":"Revisión Diseño", "injected":0, "estimated": 0})
			Injected.splice(4, 0, {"name":"Revisión Código", "injected":0, "estimated": 0})

			Removed.splice(2, 0, {"name":"Revisión Diseño", "removed":0, "estimated": 0})
			Removed.splice(4, 0, {"name":"Revisión Código", "removed":0, "estimated": 0})

		data = {
			summaryOwner: uid
			projectId: pid
			createdAt: new Date()
			timeEstimated: time
			InjectedEstimated: Injected
			RemovedEstimated: Removed
		}

		db.plan_summary.insert(data)

	#delete_plan_summary: (pid) ->
	#	PlanSummary.remove({ "projectId": pid })


	#update_plan_summary: (pid, uid, field, value) ->
	#	if field == "timeEstimated"
	#		PlanSummary.update({"projectId": pid, "summaryOwner": uid}, {$set: {"timeEstimated": value}})
	#	if field == "InjectedEstimated"
	#		PlanSummary.update({"projectId": pid, "summaryOwner": uid}, {$set: {"InjectedEstimated": value}})
	#	if field == "RemovedEstimated"
	#		PlanSummary.update({"projectId": pid, "summaryOwner": uid}, {$set: {"RemovedEstimated": value}})

	#This is for completing a stage or updating the time of the current stage
	update_time_stage: (pid, stage, finishStage=false) ->
		finalStages = db.plan_summary.findOne({"projectId": pid, "summaryOwner": Meteor.userId()}).timeEstimated
		currentStage = _.findWhere finalStages, {name: stage.name}
		currentStage.time = stage.time + currentStage.time

		if finishStage
			currentStage.finished = true

		db.plan_summary.update({"projectId": pid}, {$set: {"timeEstimated": finalStages}})
#######################################