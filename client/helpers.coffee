##################################################
################- Global Helpers -################

# This is used to bring the users Avatar or if he
# doesn't have one it brings the default image.
Template.registerHelper "getUserAvatarUrl", () ->
	data = undefined

	if @profile?
		data = @

	unless data?.profile?.profileImageUrl
		return "images/defaultAvatar.png"
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

##################################################