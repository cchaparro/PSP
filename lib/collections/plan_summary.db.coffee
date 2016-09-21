##########################################
db.plan_summary = new Meteor.Collection "PlanSummary"
##########################################
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

	"average":
		type: Number
		decimal: true
		optional: true
		label: "Value for average of recolected data until the current date"

##########################################
schemas.summaryInjectedEstimated = new SimpleSchema
	"name":
		type: String
		label: "Stage InjectedEstimated name"

	"injected":
		type: Number
		label: "Stage InjectedEstimated injected"

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
schemas.summaryRemovedEstimated = new SimpleSchema
	"name":
		type: String
		label: "Stage RemovedEstimated name"

	"removed":
		type: Number
		label: "Stage RemovedEstimated removed"

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
schemas.summaryBaseSize = new SimpleSchema
	"name":
		type: String
		optional: true
		label: "Name of the base part"
	"base":
		type: Number
		label: "Number of base LOC"
	"add":
		type: Number
		label: "Number of added LOC"
	"modified":
		type: Number
		label: "Number of modified LOC"
	"deleted":
		type: Number
		label: "Number of deleted LOC"

##########################################
schemas.summaryBaseSizeActual = new SimpleSchema
	"base":
		type: Number
		label: "Number of base LOC"
	"add":
		type: Number
		label: "Number of added LOC"
	"modified":
		type: Number
		label: "Number of modified LOC"
	"deleted":
		type: Number
		label: "Number of deleted LOC"

##########################################
schemas.summaryBase = new SimpleSchema
	"Estimated":
		type: schemas.summaryBaseSize
		label: "Estimated values for base LOC"

	"Actual":
		type: schemas.summaryBaseSizeActual
		label: "Actual values for base LOC"

##########################################
schemas.summaryAddSize = new SimpleSchema
	"name":
		type: String
		optional: true
		label: "Name of the added part"
	"type":
		type: String
		optional: true
		label: "Part type"
	"items":
		type: Number
		label: "Number of added parts"
	"relSize":
		type: String
		optional: true
		label: "Relative size of the part"
	"size":
		type: Number
		label: "Part size"
	"nr":
		type: Boolean
		label: "New reusable part"

# ##########################################
schemas.summaryAddSizeActual = new SimpleSchema
	"items":
		type: Number
		label: "Number of added parts"
	"size":
		type: Number
		label: "Part size"
	"nr":
		type: Boolean
		label: "New reusable part"

##########################################
schemas.summaryAdd = new SimpleSchema
	"Estimated":
		type: schemas.summaryAddSize
		label: "Estimated values for added LOC"
	"Actual":
		type: schemas.summaryAddSizeActual
		label: "Estimated values for added LOC"

##########################################
schemas.summaryReuseSize = new SimpleSchema
	"name":
		type: String
		optional: true
		label: "Name of the added part"

	"size":
		type: Number
		label: "Part size"

##########################################
schemas.summaryReuseSizeActual = new SimpleSchema
	"size":
		type: Number
		label: "Part size"

##########################################
schemas.summaryReuse = new SimpleSchema
	"Estimated":
		type: schemas.summaryReuseSize
		label: "Estimated values for re used LOC"

	"Actual":
		type: schemas.summaryReuseSizeActual
		label: "Actual values for re used LOC"

##########################################
schemas.totalValues = new SimpleSchema
	"totalTime":
		type: Number
		label: "Plan Summary total time consumed"
	"totalSize":
		type: Number
		label: "Plan Summary total size of the project"
	"estimatedTime":
		type: Number
		label: "Estimated time the user gave for the project completion"

	"estimatedBase":
		type: Number
		label: "Estimated base LOC"

	"actualBase":
		type: Number
		label: "Actual base LOC"

	"estimatedAdd":
		type: Number
		label: "Estimated added LOC"

	"actualAdd":
		type: Number
		label: "Actual added LOC"

	"estimatedModified":
		type: Number
		label: "Estimated modified LOC"

	"actualModified":
		type: Number
		label: "Actual modified LOC"

	"estimatedDeleted":
		type: Number
		label: "Estimated deleted LOC"

	"actualDeleted":
		type: Number
		label: "Actual deleted LOC"

	"estimatedReused":
		type: Number
		label: "Estimated reused LOC"

	"actualReused":
		type: Number
		label: "Actual reused LOC"

	"estimatedAddedSize":
		type: Number
		label: "Estimated added and modified size using PROBE"

	"proxyEstimated":
		type: Number
		label: "Estimated proxy size"
	"productivityPlan": 
		type: Number
		label: "Planned productivity of the project (A&M/totalTime)*60"
	"productivityActual":
		type: Number
		label: "Actual productivity of the project (A&M/totalTime)*60"

##########################################
############## Main Schema ###############

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

	"probeTime":
		type: String
		optional: false
		defaultValue: "D"
		label: "Probe used for time estimation"

	"probeSize":
		type: String
		optional: false
		defaultValue: "D"
		label: "Probe used for time estimation"

	"timeStarted":
		type: String
		optional: false
		defaultValue: "false"
		label: "TimeStarted for the time logs"

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

	"baseLOC":
		type: Array
		optional: true
		label: "Base Size data"

	"baseLOC.$":
		type: schemas.summaryBase
		label: "Base Size data"

	"addLOC":
		type: Array
		label: "Added Size data"

	"addLOC.$":
		type: schemas.summaryAdd
		label: "Added Size data"

	#Re used
	"reusedLOC":
		type: Array
		label: "Re Used LOC data"

	"reusedLOC.$":
		type: schemas.summaryReuse
		label: "Re Used LOC data"

	"total":
		type: schemas.totalValues
		label: "Total estimation values for the project"

##########################################
db.plan_summary.attachSchema(schemas.plan_summary)
##########################################
