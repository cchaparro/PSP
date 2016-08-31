#######################################
Template.profileView.onCreated () ->
	Meteor.subscribe "UserMenu"
	@currentUpload = new ReactiveVar(false)


Template.profileView.helpers
	userData: () ->
		return db.users.findOne({_id: Meteor.userId()})

	currentUpload: () ->
		return Template.instance().currentUpload.get()

	registeredService: () ->
		if @profile?.service?
			switch @profile?.service
				when "email"
					return "fa-envelope"
				when "google"
					return "fa-google"
				when "facebook"
					return "fa-facebook-official"
		else
			return ""


Template.profileView.events
	'click .back-profile': (e,t) ->
		activeTab = $(e.target).closest(".profile-slide")
		activeTab.removeClass("activate")

	'click .general-view-avatar': (e,t) ->
		activeTab = $(e.target).closest(".profile-slide")
		activeTab.addClass("activate")

	'click .profile-upload-box': (e,t) ->
		$fileUploader = t.$(".image-upload")
		$fileUploader.click()

	'change .image-upload': (e,t) ->
		userId = Meteor.userId()
		hostPath = window.location.host

		if e.currentTarget.files and e.currentTarget.files[0]
			# We upload only one file, in case there was multiple files selected
			file = e.currentTarget.files[0]
			if file
				uploadInstance = db.Images.insert({
					file: file
					streams: 'dynamic'
					chunkSize: 'dynamic'
				}, false)

				uploadInstance.on 'start', ->
					t.currentUpload.set(@)

				#uploadInstance.on 'progress', (value) ->
				#	console.log "progreso nuevo " + value

				uploadInstance.on 'end', (error, fileObj) ->
					if error
						console.log 'Error during upload: ' + error.reason
					else
						switch fileObj.type
							when "image/jpeg"
								type = "jpeg"
							when "image/jpg"
								type = "jpg"
							when "image/png"
								type = "png"

						data = {
							"profile.profileImageUrl": "http://#{hostPath}/cdn/storage/Images/#{fileObj._id}/original/#{fileObj._id}.#{type}"
						}
						Meteor.call "update_user_public_info", userId, data, fileObj._id, (error) ->
							unless error
								sys.flashStatus("update-profile-image")
								t.currentUpload.set(false)

				uploadInstance.start()

	'click .profile-default-image': (e,t) ->
		data = {
			"profile.profileImageUrl": null
		}
		Meteor.call "update_user_public_info", Meteor.userId(), data, (error) ->
			unless error
				sys.flashStatus("update-profile-image")

	'click .save-profile-settings': (e,t) ->
		data = {
			"profile.fname": $("#fname").val()
			"profile.lname": $("#lname").val()
		}
		Meteor.call "update_user_public_info", Meteor.userId(), data, (error) ->
			if error
				sys.flashStatus("profile-update-error")
			else
				sys.flashStatus("profile-update")

#######################################