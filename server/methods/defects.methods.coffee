##########################################
Meteor.methods
	create_defect: (data, delete_values=false, update_user=false) ->
		check(data, Object)
		check(delete_values, Boolean)
		check(update_user, Boolean)

		projectId = data.projectId

		result = syssrv.createDefect(data, delete_values, update_user)
		#This updates all the project stages injected and removed defect percentages
		syssrv.updateDefectsPercentage(projectId)
		return result


	update_defect: (did, data, delete_values=false, update_user=false) ->
		defect = db.defects.findOne({_id: did})?.time
		data.time = defect + data.time

		db.defects.update({_id: did}, {$set: data})

		if delete_values
			db.defects.remove({"projectId": data.projectId, "created": false})

		if update_user
			userStages = db.users.findOne({_id: Meteor.userId()})?.profile.summaryAmount
			planSummary = db.plan_summary.findOne({"projectId": data.projectId})

			amountStages = planSummary.injectedEstimated.length

			injectedValues = []
			removedValues = []
			_.each userStages, (stage) ->
				if amountStages < 8
					unless stage.name == "Revisión Diseño" or stage.name == "Revisión Código"
						removedStage = _.findWhere planSummary.removedEstimated, {name: stage.name}
						injectedStage = _.findWhere planSummary.injectedEstimated, {name: stage.name}

						injected = db.defects.find({"projectId": data.projectId, "injected": stage.name}).count()
						removed = db.defects.find({"projectId": data.projectId, "removed": stage.name}).count()

						injectedValues.push({'name': stage.name, 'injected': injected, "toDate": injectedStage.toDate, "percentage": injectedStage.percentage})
						removedValues.push({'name': stage.name, 'removed': removed, "toDate": removedStage.toDate, "percentage": removedStage.percentage})
				else
					removedStage = _.findWhere planSummary.removedEstimated, {name: stage.name}
					injectedStage = _.findWhere planSummary.injectedEstimated, {name: stage.name}

					injected = db.defects.find({"projectId": data.projectId, "injected": stage.name}).count()
					removed = db.defects.find({"projectId": data.projectId, "removed": stage.name}).count()

					injectedValues.push({'name': stage.name, 'injected': injected, "toDate": injectedStage.toDate, "percentage": injectedStage.percentage})
					removedValues.push({'name': stage.name, 'removed': removed, "toDate": removedStage.toDate, "percentage": removedStage.percentage})

			db.plan_summary.update({'projectId': data.projectId}, {$set: {'injectedEstimated': injectedValues, 'removedEstimated': removedValues}})


	delete_defect: (defectId, projectId) ->
		check(defectId, String)
		check(projectId, String)

		syssrv.deleteDefect(defectId, projectId)
		syssrv.updateDefectsPercentage(projectId)

##########################################