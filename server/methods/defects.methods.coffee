##########################################
Meteor.methods
	create_defect: (uid, pid, date, Defect, time, create) ->
		if date?
			date = new Date()

		db.defects.insert({
			"defectOwner": uid
			"projectId": pid
			"createdAt": date
			"typeDefect": Defect.typeDefect
			"injected": Defect.injected
			"removed": Defect.removed
			"fixCount": Defect.fixCount
			"description": Defect.description
			"time": time
			"parentId": Defect.parentId
			"created": create
		})


	update_defect: (did, uid, pid, date, Defect, time, create) ->

		defect = db.defects.findOne({_id: did}).time
		time = defect + time

		if date?
			date = new Date()

		db.defects.update({_id: did}, {$set: {
			"defectOwner": uid
			"projectId": pid
			"date": date
			"typeDefect": Defect.typeDefect
			"injected": Defect.injected
			"removed": Defect.removed
			"fixCount": Defect.fixCount
			"description": Defect.description
			"lastModified": new Date()
			"time": time
			"parentId": Defect.parentId
			"created": create
		}})


	delete_defect: (defectId) ->
		db.defects.remove({_id: defectId})
		#Falta eliminar los datos del summary con esto y poner opcion de si dejar hijos como independientes si los tiene o si eliminarlos tambien

##########################################