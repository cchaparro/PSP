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

	"estimated":
		type: Number
		label: "Stage timeEstimated estimated"

##########################################
schemas.summaryInjectedEstimated = new SimpleSchema
	"name":
		type: String
		label: "Stage InjectedEstimated name"

	"injected":
		type: Number
		label: "Stage InjectedEstimated injected"

	"estimated":
		type: Number
		label: "Stage timeEstimated estimated"
		optional: true

##########################################
schemas.summaryRemovedEstimated = new SimpleSchema
	"name":
		type: String
		label: "Stage RemovedEstimated name"

	"removed":
		type: Number
		label: "Stage RemovedEstimated removed"

	"estimated":
		type: Number
		label: "Stage RemovedEstimated estimated"
		optional: true

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

	"InjectedEstimated":
		type: Array
		label: "Injected estimation of Plan Summary"

	"InjectedEstimated.$":
		type: schemas.summaryInjectedEstimated
		label: "One injected estimation of Plan Summary"

	"RemovedEstimated":
		type: Array
		label: "Removed estimation of Plan Summary"

	"RemovedEstimated.$":
		type: schemas.summaryRemovedEstimated
		label: "One removed estimation of Plan Summary"


##########################################
db.plan_summary.attachSchema(schemas.plan_summary)
##########################################