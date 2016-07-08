##########################################
Meteor.methods
	create_defect: (data, delete_values=false, update_user=false) ->
		if delete_values
			db.defects.remove({"projectId": data.projectId, "created": false})

		if update_user
			userStages = db.users.findOne({_id: Meteor.userId()})?.profile.summaryAmount
			injectedValues = []
			removedValues = []
			_.each userStages, (stage) ->
				injected = db.defects.find({"injected": stage.name}).count()
				removed = db.defects.find({"removed": stage.name}).count()
				if data.injected == stage.name
					injected += 1

				if data.removed == stage.name
					removed += 1

				injectedValues.push({'name': stage.name, 'injected': injected})
				removedValues.push({'name': stage.name, 'removed': removed})

			#db.users.update({_id: Meteor.userId()}, {$set: {'profile.summaryAmount': finalValues}})
			db.plan_summary.update({'projectId': data.projectId}, {$set: {'injectedEstimated': injectedValues, 'removedEstimated': removedValues}})

		db.defects.insert(data)


	update_defect: (did, data, delete_values=false, update_user=false) ->
		defect = db.defects.findOne({_id: did}).time
		data.time = defect + data.time

		db.defects.update({_id: did}, {$set: data})

		if delete_values
			# This removes all the unused projects with created = false
			db.defects.remove({"projectId": data.projectId, "created": false})

		if update_user
			userStages = db.users.findOne({_id: Meteor.userId()})?.profile.summaryAmount
			injectedValues = []
			removedValues = []
			_.each userStages, (stage) ->
				injected = db.defects.find({"injected": stage.name}).count()
				removed = db.defects.find({"removed": stage.name}).count()
				injectedValues.push({'name': stage.name, 'injected': injected})
				removedValues.push({'name': stage.name, 'removed': removed})

			db.plan_summary.update({'projectId': data.projectId}, {$set: {'injectedEstimated': injectedValues, 'removedEstimated': removedValues}})


	delete_defect: (defectId, pid) ->
		defect = db.defects.findOne({_id: defectId})

		#This part deletes the defect injected and removed values
		planSummary = db.plan_summary.findOne({'projectId': pid})
		injectedValues = planSummary.injectedEstimated
		removedValues = planSummary.removedEstimated

		(_.findWhere injectedValues, {'name': defect.injected}).injected -= 1
		(_.findWhere removedValues, {'name': defect.removed}).removed -= 1
		db.plan_summary.update({'projectId': pid}, {$set: {'injectedEstimated': injectedValues, 'removedEstimated': removedValues}})

		# Elimina completamente el defecto
		db.defects.remove({_id: defectId})

		#Falta eliminar los datos del summary con esto y poner opcion de si dejar hijos como independientes si los tiene o si eliminarlos tambien

##########################################