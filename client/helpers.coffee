##################################################
################- Global Helpers -################

# This is used to bring the users Avatar or if he
# doesn't have one it brings the default image.
Template.registerHelper "getUserAvatarUrl", (userId=false) ->
	data = undefined

	if userId?
		data = db.users.findOne({_id: userId})
	if @profile?
		data = @

	unless data?.profile?.profileImageUrl
		return "/defaultAvatar.png"
	else
		return data.profile.profileImageUrl


# This is used to bring the users complete name
Template.registerHelper "userName", (userId) ->
	user = db.users.findOne({_id: userId})?.profile

	return user.fname + " " + user.lname


# This is a helper to show the data that passes through
# a html section, you call it by {{printthis}}
Template.registerHelper "printthis", () ->
	console.log @
	return ''


# This helper is used to display the time format used
# in the platform
Template.registerHelper "timeFormat", (time) ->
	return sys.displayTime(time)


# This helper is used to display the ISO time in minutes
Template.registerHelper "timeInOnlyMinutes", (time) ->
	return sys.timeInOnlyMinutes(time)

Template.registerHelper "timeInOnlyHours", (time) ->
	return sys.timeInOnlyHours(time)

# This helper is used to make a contenteditable html
Template.registerHelper "contentEditable", (hash) ->
	return '<div class="' + hash?.hash?.class + '"' + 'contentEditable="true">' + hash?.hash?.value + '</div>';
##################################################