# This is a helper to show the data that passes through a html section, you call it by {{printthis}}
Template.registerHelper "printthis", () ->
	console.log @
	return ''


Template.registerHelper "dateFormat", (context) ->
	if window.moment
		format = context.hash.format or "MMM Do, YYYY"
		date = context.hash.date or new Date().getTime()
		if typeof date.getTime == 'function'
			date = date.getTime()
		return moment(date).format(format)
	else
		#moment plugin is not available
		return context


Template.registerHelper "momentToNow", (createdAt) ->
	return moment(createdAt).fromNow()


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

	return user?.fname + " " + user?.lname


Template.registerHelper "cutText", (text, amount) ->
	return sys.cutText(text, amount, " ...")

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