##################################################
Meteor.users.after.insert (userId, doc) ->
	console.log userId
	console.log "----------------->"
	console.log doc


##################################################
# Meteor.users.after.insert (userId, doc) ->
# 	if @_id and @_id != "stevieserver"
# 		console.log("Doing after Insert on "+@_id)
# 		user = Meteor.users.findOne(@_id)
# 		unless user?
# 			console.log("No such user")
# 			return false

# 		if user.isDefault
# 			console.log("Default user at first system startup")
# 			return false

# 		email = user.email

# 		if user.communityId
# 			console.log "Got Specific Community"
# 			comm = Model.Community.getCommunity(user.communityId);
# 		else
# 			console.warn "User had no Community"
# 			if user.global
# 				comm = Model.Community.getCommunity("defaultcommunity");

# 		if user.passwordNotSet
# 			console.log("Sending Passwort Set E-Mail")
# 			text = 		comm?.email?.messages?.user_set_initial_password?.text || "";
# 			subject = 	comm?.email?.messages?.user_set_initial_password?.subject || "";

# 			linkurl = Model.Token.createNewToken("pwdset", {}, {mail: email, fname: user.profile.fname, lname: user.profile.lname}, {communityId: user.communityId})
# 			linkname = linkurl

# 			merge = [
# 				name: 		"fname"
# 				content: 	user.profile.fname
# 			,
# 				name: 		"lname"
# 				content: 	user.profile.lname
# 			,
# 				name: 		"name"
# 				content: 	user.profile.name
# 			,
# 				name: 		"linkname"
# 				content:	linkname
# 			,
# 				name:		"linkurl"
# 				content:	linkurl
# 			,
# 				name:		"unsublink"
# 				content:	Model.Token.createNewToken("unsub-all", {}, {mail: email, fname: user.profile.fname, lname: user.profile.lname}, {communityId: user.communityId})

# 			]

# 			to = [
# 				email: email
# 				name: user.profile.name
# 				type: "to"
# 			]

# 		else
# 			text = 		comm?.email?.messages?.user_welcome?.text || "";
# 			subject = 	comm?.email?.messages?.user_welcome?.subject || "";

# 			merge = [
# 				name: 		"fname"
# 				content: 	user.profile.fname
# 			,
# 				name: 		"lname"
# 				content: 	user.profile.lname
# 			,
# 				name: 		"name"
# 				content: 	user.profile.name
# 			]

# 			to = [
# 				email: email
# 				name: user.profile.name
# 				type: "to"
# 			]


# 		syssrv.email.sendSingle(comm, to, subject, text, merge)

# 		# Add user to courses where user is member of.
# 		memberOfCourse = db.members.update {email: email, userId: {$exists: false}}, {$set: {userId: @_id}}, {multi: true}
# 		memberListEntries = db.members.find {userId: @_id};
# 		userId = @_id
# 		memberListEntries.forEach (member) ->
# 			db.courses.update({_id: member.courseId}, {$addToSet: {memberlist: userId}});




# Accounts.onCreateUser (options, user) ->
# 	role = "user"

# 	if user.services.google
# 		uname 	= user.services.google.name
# 		fname 	= user.services.google.given_name
# 		lname 	= user.services.google.family_name
# 		gender 	= user.services.google.gender
# 		picture = user.services.google.picture + "?sz=50"
# 		email 	= user.services.google.email
# 	else if user.services.facebook
# 		uname 	= user.services.facebook.name
# 		fname 	= user.services.facebook.first_name
# 		lname 	= user.services.facebook.last_name
# 		gender 	= user.services.facebook.gender
# 		picture = "http://graph.facebook.com/" + user.services.facebook.id + "/picture/?type=square"
# 		email 	= user.services.facebook.email
# 	else
# 		fname 	= options.profile.fname
# 		lname 	= options.profile.lname

# 		uname 	= fname + " " + lname
# 		email 	= options.email
# 		picture = null

# 	if Meteor.settings and Meteor.settings.loginRestrictToDomain
# 		maildomain = email.replace(/.*@/, "");

# 		if ! _.contains(Meteor.settings.loginRestrictToDomain, maildomain)
# 			throw new Meteor.Error(403, "Error 403: Mail Domain not Allowed");

# 	roles = {};
# 	isGlobal = false
# 	if Meteor.users.find().count() < 2
# 		roles[Roles.GLOBAL_GROUP] = ['root']
# 		isGlobal = true
# 		email = options.emailOrig
# 	else
# 		roles[Roles.GLOBAL_GROUP] = ['user']

# 	data =
# 		profile:
# 			name: 				uname
# 			fname: 				fname
# 			lname: 				lname
# 			profileImageUrl: 	picture
# 		emails: [
# 			address: 			email
# 			verified: 			true
# 		]
# 		email: 					options.emailOrig
# 		communityId: 			options.communityId unless isGlobal
# 		global: 				isGlobal
# 		roles: 					roles


# 	if options.profile?.language
# 		data["profile"]["language"] = options.profile.language
# 	if options.passwordNotSet
# 		data["passwordNotSet"] = true



# 	ret = _.extend(user,data)
# 	console.log ret, user
# 	return ret;
