##########################################
db.plan_summary = new Meteor.Collection "PlanSummary"
##########################################
############## Main Schema ###############
schemas.summarytimeEstimated = new SimpleSchema
	"name":
		type: String
		label: "Stage timeEstimated name"

	"finished":
		type: Boolean
		label: "Stage timeEstimated finished"

	"time":
		type: Number
		label: "Stage timeEstimated time"

	"toDate":
		type: Number
		optional: true
		label: "Value for recolected data until the current date"

	"percentage":
		type: Number
		decimal: true
		optional: true
		label: "Value for percentage of recolected data until the current date"

##########################################
schemas.summaryInjectedEstimated = new SimpleSchema
	"name":
		type: String
		label: "Stage InjectedEstimated name"

	"injected":
		type: Number
		label: "Stage InjectedEstimated injected"

##########################################
schemas.summaryRemovedEstimated = new SimpleSchema
	"name":
		type: String
		label: "Stage RemovedEstimated name"

	"removed":
		type: Number
		label: "Stage RemovedEstimated removed"

##########################################
schemas.totalValues = new SimpleSchema
	"totalTime":
		type: Number
		label: "Plan Summary total time consumed"

	"estimatedTime":
		type: Number
		label: "Estimated time the user gave for the project completion"

##########################################
schemas.plan_summary = new SimpleSchema
	"projectId":
		type: String
		optional: false
		label: "Id of the Project"

	"createdAt":
		type: Date
		label: "Date when the project was created"
		autoValue: (doc) ->
			if @isInsert
				return new Date()

	"summaryOwner":
		type: String
		optional: false
		label: "Id of the Project owner"

	"timeEstimated":
		type: Array
		label: "Time estimation of Plan Summary"

	"timeEstimated.$":
		type: schemas.summarytimeEstimated
		label: "One time estimation of Plan Summary"

	"injectedEstimated":
		type: Array
		label: "Injected estimation of Plan Summary"

	"injectedEstimated.$":
		type: schemas.summaryInjectedEstimated
		label: "One injected estimation of Plan Summary"

	"removedEstimated":
		type: Array
		label: "Removed estimation of Plan Summary"

	"removedEstimated.$":
		type: schemas.summaryRemovedEstimated
		label: "One removed estimation of Plan Summary"

	"total":
		type: schemas.totalValues
		label: "Total estimation values for the project"


##########################################
db.plan_summary.attachSchema(schemas.plan_summary)
##########################################