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
		label: "Stage time"

	"estimated":
		type: Number
		decimal: true
		optional: true
		label: "Stage estimated time"
		
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
		autoValue: (doc) ->
			if @isInsert
				return 0
	"totalSize":
		type: Number
		label: "Plan Summary total size of the project"
		autoValue: (doc) ->
			if @isInsert
				return 0
	
	"estimatedTotalSize":
		type: Number
		label: "Plan Summary estimated total size of the project"
		autoValue: (doc) ->
			if @isInsert
				return 0

	"estimatedTime":
		type: Number
		label: "Estimated time the user gave for the project completion"
		autoValue: (doc) ->
			if @isInsert
				return 0

	"estimatedBase":
		type: Number
		label: "Estimated base LOC"
		autoValue: (doc) ->
			if @isInsert
				return 0

	"actualBase":
		type: Number
		label: "Actual base LOC"
		autoValue: (doc) ->
			if @isInsert
				return 0

	"estimatedAdd":
		type: Number
		label: "Estimated added LOC"
		autoValue: (doc) ->
			if @isInsert
				return 0

	"actualAdd":
		type: Number
		label: "Actual added LOC"
		autoValue: (doc) ->
			if @isInsert
				return 0

	"estimatedModified":
		type: Number
		label: "Estimated modified LOC"
		autoValue: (doc) ->
			if @isInsert
				return 0

	"actualModified":
		type: Number
		label: "Actual modified LOC"
		autoValue: (doc) ->
			if @isInsert
				return 0

	"estimatedDeleted":
		type: Number
		label: "Estimated deleted LOC"
		autoValue: (doc) ->
			if @isInsert
				return 0

	"actualDeleted":
		type: Number
		label: "Actual deleted LOC"
		autoValue: (doc) ->
			if @isInsert
				return 0

	"estimatedReused":
		type: Number
		label: "Estimated reused LOC"
		autoValue: (doc) ->
			if @isInsert
				return 0

	"actualReused":
		type: Number
		label: "Actual reused LOC"
		autoValue: (doc) ->
			if @isInsert
				return 0

	"estimatedAddedSize":
		type: Number
		label: "Estimated added and modified size using PROBE"
		autoValue: (doc) ->
			if @isInsert
				return 0

	"proxyEstimated":
		type: Number
		label: "Estimated proxy size"
		autoValue: (doc) ->
			if @isInsert
				return 0

	"productivityPlan": 
		type: Number
		label: "Planned productivity of the project (A&M/totalTime)*60"
		autoValue: (doc) ->
			if @isInsert
				return 0

	"productivityActual":
		type: Number
		label: "Actual productivity of the project (A&M/totalTime)*60"
		autoValue: (doc) ->
			if @isInsert
				return 0

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
