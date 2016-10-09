##########################################
Meteor.methods
	create_pip:(pid, data, isDelete=false)->
		if isDelete
			db.pips.remove({_id: pid})
		else 
			db.pips.update({_id: pid}, {$set: data}, {upsert: true})

	create_test_report:(tid, data, isDelete=false)->
		if isDelete
			db.testReports.remove({_id: tid})
		else 
			db.testReports.update({_id: tid}, {$set: data}, {upsert: true})

##########################################