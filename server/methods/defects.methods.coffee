##########################################
Meteor.methods
	create_defect: (data) ->
		db.defects.insert(data)
		#if delete_values
		#	console.log data.projectId
		#	db.defects.remove({_id: "diKYSG8EQ5fJkjsWu"})


	update_defect: (did, data, delete_values=false) ->
		defect = db.defects.findOne({_id: did}).time
		data.time = defect + data.time

		db.defects.update({_id: did}, {$set: data})


	delete_defect: (defectId) ->
		db.defects.remove({_id: defectId})
		#Falta eliminar los datos del summary con esto y poner opcion de si dejar hijos como independientes si los tiene o si eliminarlos tambien

##########################################