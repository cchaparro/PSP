Template.pspTwoTemplate.helpers
	codeReviewRate: ()->
		planSummary = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})
		userInfo = db.users.findOne({_id: Meteor.userId()})

		timeStages = planSummary?.timeEstimated
		defectStages = planSummary?.injectedEstimated

		totalTimeStages= userInfo?.profile?.summaryAmount

		actualTimeCodification=0
		planTimeCodification=0
		actualTimeCodeRevision=0
		toDateTimeCodification=0
		toDateTimeCodeRevision=0
		actualCRC=0
		planCRC=0
		toDateCRC=0

		planTimeCodeRevision=1
		_.each timeStages, (stage)->
			switch stage.name
				when 'Código'
					actualTimeCodification=sys.timeToHours(stage.time)
					planTimeCodification=sys.timeToHours(stage.estimated)
				when 'Revisión Código'
					actualTimeCodeRevision=sys.timeToHours(stage.time)
					planTimeCodeRevision=sys.timeToHours(stage.estimated)
		_.each totalTimeStages,(stage)->
			switch stage.name
					when 'Código'
						toDateTimeCodification=sys.timeToHours(stage.time)
					when 'Revisión Código'
						toDateTimeCodeRevision=sys.timeToHours(stage.time)
		#Code review rate actual
		if actualTimeCodification>0
			actualCRC = 2*(actualTimeCodeRevision/actualTimeCodification)
		#Code review rate plan
		if planTimeCodification>0
			planCRC = 2* (planTimeCodeRevision/planTimeCodification)
		#Code review rate toDate
		if toDateTimeCodification>0
			toDateCRC= 2*(toDateTimeCodeRevision/toDateTimeCodification)

		return {"plan":planCRC, "actual":actualCRC, "toDate":toDateCRC}

	yieldValue:()->
		planSummary = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})
		userInfo = db.users.findOne({_id: Meteor.userId()})
		userAmount= userInfo?.profile?.summaryAmount
		injectedDefectStages = planSummary?.injectedEstimated
		removedDefectStages = planSummary?.removedEstimated

		
		actualRemovedDefectsBeforeCompile=0
		actualInjectedDefectsBeforeCompile=0
		
		toDateRemovedDefectsBeforeCompile=0
		toDateInjectedDefectsBeforeCompile=0

		actualYield=0
		toDateYield=0
		toDateData=userInfo?.profile?.total

		_.each userAmount,(stage)->
			if(stage.name!="Compilación" and stage.name!="Pruebas" and stage.name!="Postmortem")
				toDateRemovedDefectsBeforeCompile+=stage.removed
				toDateInjectedDefectsBeforeCompile+=stage.injected

		_.each injectedDefectStages,(stage)->
			if(stage.name!="Compilación" and stage.name!="Pruebas" and stage.name!="Postmortem")
				actualInjectedDefectsBeforeCompile+=stage.injected

		_.each removedDefectStages,(stage)->
			if(stage.name!="Compilación" and stage.name!="Pruebas" and stage.name!="Postmortem")
				actualRemovedDefectsBeforeCompile+=stage.removed

		if actualInjectedDefectsBeforeCompile>0
			actualYield=(actualRemovedDefectsBeforeCompile/actualInjectedDefectsBeforeCompile)*100

		if toDateInjectedDefectsBeforeCompile>0
			toDateYield=(toDateRemovedDefectsBeforeCompile/toDateInjectedDefectsBeforeCompile)*100

		return {"actual":actualYield, "toDate":toDateYield}

	productivity:()->
		userInfo = db.users.findOne({_id: Meteor.userId()})?.profile
		planSummary = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})?.total
		
		plan=0
		actual=0
		toDate=0

		planAddMod=planSummary?.estimatedAdd+planSummary?.estimatedModified
		planTime=sys.timeToHours(planSummary?.estimatedTime)

		actualAddMod=planSummary?.actualAdd+planSummary?.actualModified
		actualTime=sys.timeToHours(planSummary?.totalTime)

		toDateAddMod=userInfo?.sizeAmount?.add+userInfo?.sizeAmount?.modified
		toDateTime=sys.timeToHours(userInfo?.total?.time)
		if planTime>0
			plan=planAddMod/planTime

		if actualTime>0
			actual=actualAddMod/actualTime

		if toDateTime>0
			toDate=toDateAddMod/toDateTime

		return {"plan":plan.toFixed(2),"actual":actual.toFixed(2),"toDate":toDate.toFixed(2)}

	testDefects:()->
		planSummary = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})
		userInfo = db.users.findOne({_id: Meteor.userId()})?.profile

		defectStages = planSummary?.removedEstimated
		toDateDefectStages=userInfo?.summaryAmount

		actualTestDefects=0
		toDateTestDefects=0

		actualLOC=planSummary?.total?.actualAdd+planSummary?.total?.actualModified
		toDateLOC=userInfo?.sizeAmount?.add+userInfo?.sizeAmount?.modified

		actual=0
		toDate=0

		_.each defectStages,(stage)->
			if stage.name=="Pruebas"
				actualTestDefects=stage.removed

		_.each toDateDefectStages, (stage)->
			if stage.name=="Pruebas"
				toDateTestDefects=stage.removed


		if actualLOC>0
			actual=(actualTestDefects/actualLOC)*1000

		if toDateLOC>0
			toDate=(toDateTestDefects/toDateLOC)*1000

		return {"actual":actual.toFixed(2),"toDate":toDate.toFixed(2)}

	totalDefects:()->
		planSummary = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})
		userInfo = db.users.findOne({_id: Meteor.userId()})?.profile

		actualTestDefects=planSummary?.total?.totalRemoved
		toDateTestDefects=userInfo?.total?.removed

		actualLOC=planSummary?.total?.actualAdd+planSummary?.total?.actualModified
		toDateLOC=userInfo?.sizeAmount?.add+userInfo?.sizeAmount?.modified

		actual=0
		toDate=0

		if actualLOC>0
			actual=(actualTestDefects/actualLOC)*1000

		if toDateLOC>0
			toDate=(toDateTestDefects/toDateLOC)*1000

		return {"actual":actual.toFixed(2),"toDate":toDate.toFixed(2)}
