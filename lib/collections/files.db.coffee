##########################################
db.files = new FS.Collection "Files", {
	stores: [new FS.Store.FileSystem("Files", {path: "~/uploads"})]
}
##########################################
