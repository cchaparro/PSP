##########################################
# db.files = new FS.Collection "Files", {
# 	stores: [new FS.Store.FileSystem("Files", {path: "~/uploads"})]
# }
##########################################
db.Images = new (Meteor.Files)(
	collectionName: 'Images'
	allowClientCode: false
	onBeforeUpload: (file) ->
		# Allow upload files under 10MB, and only in png/jpg/jpeg formats
		if file.size <= 10485760 and /png|jpg|jpeg/i.test(file.extension)
			true
		else
			'Please upload image, with size equal or less than 10MB'
)
# if Meteor.isServer
#   Images.denyClient()
#   Meteor.publish 'files.images.all', ->
#     Images.find().cursor
# else
#   Meteor.subscribe 'files.images.all'
