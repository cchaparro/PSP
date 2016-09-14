####################################
Meteor.publish "allProjects", () ->
	return [
		db.projects.find({"projectOwner": @userId})
		db.plan_summary.find({"summaryOwner": @userId})
	]

Meteor.publish "projectView", (pid) ->
	return [
		db.defects.find({"defectOwner": @userId, "projectId": pid}),
		db.projects.find({_id: pid}),
		db.defect_types.find({"defectTypeOwner": @userId})
		db.plan_summary.find({"projectId": pid, "summaryOwner": @userId})
		db.users.find({_id: @userId})
	]
####################################

Meteor.publish "chartStages", ()->
	return [
		db.projects.find({"projectOwner": @userId})
		db.plan_summary.find({"summaryOwner": @userId})
	]