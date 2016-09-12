##########################################
Template.addSummary.onCreated () ->
	@addData = new ReactiveVar([])
	@deleteActive = new ReactiveVar(false)


Template.addSummary.helpers
	createaddData: ()->
		addLOC = db.plan_summary.findOne({"projectId": FlowRouter.getParam("id")})?.addLOC

		data = _.map addLOC, (base, index) ->
			return {
				position: index
				Estimated: base.Estimated
				Actual: base.Actual
			}
		Template.instance().addData.set(data)

	addData: ()->
		return Template.instance().addData.get()

	activeDelete: ()->
		return Template.instance().deleteActive.get()

	isChecked: (checked) ->
		# Used to return to the input type="checked" if its checked or not
		return "checked" or "" if checked


Template.addSummary.events
	'click .add-row': (e,t) ->
		data = t.addData.get()
		estimatedAdd = { name: "", type: "Elegir", items: 0, relSize: "Elegir", size: 0, nr: false }
		actualAdd = { items: 0, size: 0, nr: false }

		data.push({
			position: data.length,
			Estimated: estimatedAdd,
			Actual:actualAdd
		})
		t.addData.set(data)

	'blur .input-box input': (e,t) ->
		data = t.addData.get()
		value = $(e.target).val()
		dataField = $(e.target).data('value')

		#This separated the "Estimated/Actual" form the field (e.g. base, name, modified)
		dataField = dataField.split(".")
		section = dataField[0]
		field = dataField[1]

		if field == "items"
			relSize = data[@position]["Estimated"]["relSize"]
			if relSize != "Elegir"
				switch relSize
					when "Muy pequeño"
						sizeValue = value * 5
					when "Pequeño"
						sizeValue = value * 10
					when "Mediano"
						sizeValue = value * 20
					when "Grande"
						sizeValue = value * 30
					when "Muy grande"
						sizeValue = value * 40

				data[@position]["Estimated"]["size"] = sizeValue

		data[@position][section][field] = value
		t.addData.set(data)

	'click .add-checkbox': (e,t) ->
		data = t.addData.get()
		value = $(e.target).is(":checked")
		dataField = $(e.target).data('value')

		#This separated the "Estimated/Actual" form the field (e.g. base, name, modified)
		dataField = dataField.split(".")
		section = dataField[0]
		field = dataField[1]

		data[@position][section][field] = value
		t.addData.set(data)

	'click .add-size-option': (e,t) ->
		data = t.addData.get()
		value = $(e.target).data('value')
		optionField = $(e.target).closest(".dropdown-menu").data('value')

		# This separated the "Estimated/Actual" form the field (e.g. base, name, modified)
		dataField = optionField.split(".")
		section = dataField[0]
		field = dataField[1]

		if field == "type"
			switch value
				when "calc"
					valueType = "Cálculos"
				when "data"
					valueType = "Datos"
				when "io"
					valueType = "I/0"
				when "logic"
					valueType = "Logica"
				when "configuration"
					valueType = "Configuracion"
				when "text"
					valueType = "Texto"

			data[@position]["Estimated"]["type"] = valueType

		if field == "relSize"
			itemValue = data[@position]["Estimated"]["items"]
			switch value
				when "vs"
					sizeValue = itemValue * 5
					selectionTitle = "Muy pequeño"
				when "s"
					sizeValue = itemValue * 10
					selectionTitle = "Pequeño"
				when "m"
					sizeValue = itemValue * 20
					selectionTitle = "Mediano"
				when "l"
					sizeValue = itemValue * 30
					selectionTitle = "Grande"
				when "vl"
					sizeValue = itemValue * 40
					selectionTitle = "Muy grande"

			data[@position]["Estimated"]["size"] = sizeValue
			data[@position]["Estimated"]["relSize"] = selectionTitle

		t.addData.set(data)

	'click .add-save-data': (e,t)->
		data = t.addData.get()

		finalData = _.map data, (value) ->
			return {"Actual": value.Actual, "Estimated": value.Estimated}

		Meteor.call "update_add_size", FlowRouter.getParam("id"), finalData, (error) ->
			if error
				console.warn(error)
				sys.flashStatus("error-project")
			else
				sys.flashStatus("save-project")
				t.deleteActive.set(false)

	'click .add-active-delete': (e,t) ->
		activeDelete = t.deleteActive.get()
		t.deleteActive.set(!activeDelete)

	'click .add-delete-row': (e,t) ->
		data = t.addData.get()
		if data.length > 1
			deletePos = @position
			finalData = []

			_.each data, (value, index) ->
				unless value.position == deletePos
					finalData.push({
						position: index
						Estimated: value.Estimated
						Actual: value.Actual
					})

			t.addData.set(finalData)
			Meteor.call "update_add_size", FlowRouter.getParam("id"), finalData, (error) ->
				if error
					console.warn(error)

		else
			sys.flashStatus("size-delete-error")

##########################################
