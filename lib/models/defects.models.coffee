##########################################
if Meteor.isServer
	syssrv.createDefect = (data, delete_values, update_user) ->
		if delete_values
			db.defects.remove({"projectId": data.projectId, "created": false})

		if update_user
			userStages = db.users.findOne({_id: Meteor.userId()})?.profile.summaryAmount
			planSummary = db.plan_summary.findOne({"projectId": data.projectId})

			newInjected = planSummary.total.totalInjected + 1
			newRemoved = planSummary.total.totalRemoved + 1
			injectedValues = []
			removedValues = []

			amountStages = planSummary.injectedEstimated.length

			_.each userStages, (stage) ->
				injected = db.defects.find({"injected": stage.name}).count()
				removed = db.defects.find({"removed": stage.name}).count()

				if amountStages < 8
					unless stage.name == "Revisión Diseño" or stage.name == "Revisión Código"
						injectedStage = _.findWhere planSummary.injectedEstimated, {name: stage.name}
						if data.injected == injectedStage.name
							injectedStage.injected += 1

						removedStage = _.findWhere planSummary.removedEstimated, {name: stage.name}
						if data.removed == removedStage.name
							removedStage.removed += 1

						injectedValues.push({'name': stage.name, 'injected': injectedStage.injected, "toDate": injectedStage.toDate, "percentage": injectedStage.percentage})
						removedValues.push({'name': stage.name, 'removed': removedStage.removed, "toDate": removedStage.toDate, "percentage": removedStage.percentage})

				else
					injectedStage = _.findWhere planSummary.injectedEstimated, {name: stage.name}
					if data.injected == injectedStage.name
						injectedStage.injected += 1

					removedStage = _.findWhere planSummary.removedEstimated, {name: stage.name}
					if data.removed == removedStage.name
						removedStage.removed += 1

					injectedValues.push({'name': stage.name, 'injected': injectedStage.injected, "toDate": injectedStage.toDate, "percentage": injectedStage.percentage})
					removedValues.push({'name': stage.name, 'removed': removedStage.removed, "toDate": removedStage.toDate, "percentage": removedStage.percentage})


			summaryData = {
				'injectedEstimated': injectedValues
				'removedEstimated': removedValues
				'total.totalInjected':newInjected
				'total.totalRemoved':newRemoved
			}

			db.plan_summary.update({'projectId': data.projectId}, {$set: summaryData})

		#Creates the defect
		db.defects.insert(data)


	syssrv.deleteDefect = (defectId, projectId) ->
		defect = db.defects.findOne({_id: defectId})
		planSummary = db.plan_summary.findOne({'projectId': projectId})

		newInjected = planSummary.total.totalInjected - 1
		newRemoved = planSummary.total.totalRemoved - 1

		#This part deletes the defect injected and removed values
		injectedValues = planSummary.injectedEstimated
		removedValues = planSummary.removedEstimated

		(_.findWhere injectedValues, {'name': defect.injected}).injected -= 1
		(_.findWhere removedValues, {'name': defect.removed}).removed -= 1

		data = {
			'injectedEstimated': injectedValues
			'removedEstimated': removedValues
			'total.totalInjected': newInjected
			'total.totalRemoved': newRemoved
		}
		db.plan_summary.update({'projectId': projectId}, {$set: data})

		# Deletes the defect completely
		db.defects.remove({_id: defectId})

		# This changes the parentId value of all the defects that had this deleted defect as parent
		db.defects.update({parentId: defectId}, {$set: {parentId: null}},{multi:true})


##########################################