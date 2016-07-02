##################################################
################- Global Helpers -################

# This is used to bring the users Avatar or if he
# doesn't have one it brings the default image.
Template.registerHelper "getUserAvatarUrl", () ->
	data = undefined

	if @profile?
		data = @

	unless data?.profile?.profileImageUrl
		return "/defaultAvatar.png"
	else
		return data.profile.profileImageUrl


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
Template.registerHelper "timeInMinutes", (time) ->
	return sys.timeToMinutes(time)


# This helper is used to make a contenteditable html
Template.registerHelper "contentEditable", (hash) ->
	return '<div class="' + hash?.hash?.class + '"' + 'contentEditable="true">' + hash?.hash?.value + '</div>';
##################################################