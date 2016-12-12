##########################################
Meteor.methods
	create_defect: (data, delete_values=false, update_user=false) ->
		if delete_values
			db.defects.remove({"projectId": data.projectId, "created": false})

		if update_user
			userStages = db.users.findOne({_id: Meteor.userId()})?.profile.summaryAmount
			planSummary = db.plan_summary.findOne({"projectId": data.projectId})

			injectedValues = []
			removedValues = []
			_.each userStages, (stage) ->
				injected = db.defects.find({"injected": stage.name}).count()
				removed = db.defects.find({"removed": stage.name}).count()

				unless stage.name == "Revisión Diseño" or stage.name == "Revisión Código"
					injectedStage = _.findWhere planSummary.injectedEstimated, {name: stage.name}
					if data.injected == injectedStage.name
						injectedStage.injected += 1

					removedStage = _.findWhere planSummary.removedEstimated, {name: stage.name}
					if data.removed == removedStage.name
						removedStage.removed += 1

					injectedValues.push({'name': stage.name, 'injected': injectedStage.injected, "toDate": injectedStage.toDate, "percentage": injectedStage.percentage})
					removedValues.push({'name': stage.name, 'removed': removedStage.removed, "toDate": removedStage.toDate, "percentage": removedStage.percentage})


			db.plan_summary.update({'projectId': data.projectId}, {$set: {'injectedEstimated': injectedValues, 'removedEstimated': removedValues}})

		db.defects.insert(data)


	update_defect: (did, data, delete_values=false, update_user=false) ->
		defect = db.defects.findOne({_id: did}).time
		data.time = defect + data.time

		db.defects.update({_id: did}, {$set: data})

		if delete_values
			db.defects.remove({"projectId": data.projectId, "created": false})

		if update_user
			userStages = db.users.findOne({_id: Meteor.userId()})?.profile.summaryAmount
			planSummary = db.plan_summary.findOne({"projectId": data.projectId})

			injectedValues = []
			removedValues = []
			_.each userStages, (stage) ->
				unless stage.name == "Revisión Diseño" or stage.name == "Revisión Código"
					removedStage = _.findWhere planSummary.removedEstimated, {name: stage.name}
					injectedStage = _.findWhere planSummary.injectedEstimated, {name: stage.name}

					injected = db.defects.find({"projectId": data.projectId, "injected": stage.name}).count()
					removed = db.defects.find({"projectId": data.projectId, "removed": stage.name}).count()

					injectedValues.push({'name': stage.name, 'injected': injected, "toDate": injectedStage.toDate, "percentage": injectedStage.percentage})
					removedValues.push({'name': stage.name, 'removed': removed, "toDate": removedStage.toDate, "percentage": removedStage.percentage})

			db.plan_summary.update({'projectId': data.projectId}, {$set: {'injectedEstimated': injectedValues, 'removedEstimated': removedValues}})


	delete_defect: (defectId, pid) ->
		syssrv.deleteDefect(defectId, pid)

##########################################