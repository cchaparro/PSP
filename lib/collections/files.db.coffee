##########################################
if Meteor.isServer
	baseUrl = process.env.PWD
	console.log baseUrl

db.files = new FS.Collection "Files", {
	stores: [new FS.Store.FileSystem("Files", {path: "~/uploads"})]
}
##########################################
