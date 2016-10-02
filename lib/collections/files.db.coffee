##########################################
db.Images = new (Meteor.Files)(
	collectionName: 'Images'
	storagePath: '~/',
	allowClientCode: false
	onBeforeUpload: (file) ->
		# Allow upload files under 5MB, and only in png/jpg/jpeg formats
		if file.size <= 5242880 and /png|jpg|jpeg/i.test(file.extension)
			return true
		else
			return 'Please upload image, with size equal or less than 10MB'
)

##########################################