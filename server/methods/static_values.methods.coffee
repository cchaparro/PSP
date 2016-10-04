##########################################
Meteor.methods
	create_static_project: () ->
		titles = ["Proyecto Blink.it","Inteligencia Artificial","Sistemas Operativos","Servicios Web","Tesis Javeriana Cali"]

		titles.forEach (title) ->
			data = {
				title: title
				description: "Esta es la descripción para un proyecto que nadie va a leer. Solo son datos fantasmas y nadie quiere ver lo que esto dice."
				levelPSP: "PSP 0"
				parentId: null
			}
			syssrv.createProject(data)

		titlesPSP1 = ["Pruebas Segunda Fase","Nuevos Datos Referencia",]

		titlesPSP1.forEach (title) ->
			data = {
				title: title
				description: "Estos proyectos usan personal software process 1. Aqui voy a probar nuevos datos en la plataforma."
				levelPSP: "PSP 1"
				parentId: null
			}
			syssrv.createProject(data)

##########################################