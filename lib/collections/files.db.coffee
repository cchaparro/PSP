##########################################
db.Images = new (Meteor.Files)(
	collectionName: 'Images'
	storagePath: '~/data',
	allowClientCode: false
	onBeforeUpload: (file) ->
		# Allow upload files under 10MB, and only in png/jpg/jpeg formats
		if file.size <= 10485760 and /png|jpg|jpeg/i.test(file.extension)
			return true
		else
			return 'Please upload image, with size equal or less than 10MB'
)

##########################################