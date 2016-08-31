##################################################
Meteor.users.after.insert (userId, doc) ->
	# Creates the default defect type template for the user
	defectTypeId = syssrv.create_defect_type(@_id)

	data = {
		settings:
			probeC: false
			probeD: true

		defectTypes:
			default: defectTypeId
			current: defectTypeId

		profile: doc.profile
	}

	if doc.services?.facebook
		data.profile["email"] = doc.services?.facebook?.email
		data.profile["service"] = "facebook"
		data.profile["fname"] = doc.services?.facebook?.first_name
		data.profile["lname"] = doc.services?.facebook?.last_name
		data.profile["profileImageUrl"] = "http://graph.facebook.com/"+doc.services?.facebook?.id+"/picture/?type=large"
		data.profile["summaryAmount"] = Meteor.settings.public.userAmount
		data.profile["total"] = {
			time: 0
			injected: 0
			removed: 0
		}

	if doc.services?.google
		data.profile["email"] = doc.services?.google?.email
		data.profile["service"] = "google"
		data.profile["fname"] = doc.services?.google?.given_name
		data.profile["lname"] = doc.services?.google?.family_name
		data.profile["profileImageUrl"] = doc.services?.google?.picture
		data.profile["summaryAmount"] = Meteor.settings.public.userAmount
		data.profile["total"] = {
			time: 0
			injected: 0
			removed: 0
		}


	db.users.update({_id: @_id}, {$set: data})

	# This creates the welcome notification for the new user
	notificationData = {
		sender: @_id
	}
	syssrv.newNotification("new-user", @_id, notificationData)

##################################################