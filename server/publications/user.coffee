####################################
Meteor.publish "UserMenu", () ->
	return [
		db.notifications.find({"notificationOwner": @userId})
		db.plan_summary.find({"summaryOwner": @userId})
		db.users.find({_id: @userId})
		db.Images.find({userId: @userId}).cursor
	]

Meteor.publish "projectSettings", () ->
	return [
		db.users.find({_id: @userId})
		db.projects.find({"projectOwner": @userId})
		db.defect_types.find({"defectTypeOwner": @userId})
		db.plan_summary.find({"summaryOwner": @userId})
	]

Meteor.publish "accountSettings", () ->
	return [
		db.users.find({_id: @userId})
		db.Images.find({userId: @userId}).cursor
		db.plan_summary.find({"summaryOwner": @userId})
		#db.files.find({ "metadata.fileOwner": @userId})
	]

####################################