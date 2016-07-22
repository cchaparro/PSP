##########################################
Meteor.methods
	create_static_project: () ->
		titles = ["Proyecto Blink.it","Arqui II","Inteligencia Artificial","Sistemas Operativos","Redes","Servicios Web","Tesis Javeriana Cali"]

		titles.forEach (title) ->
			data = {
				title: title
				description: "Esta es la descripción para un proyecto que nadie va a leer. Solo son datos fantasmas y nadie quiere ver lo que esto dice."
				levelPSP: "PSP 0"
				parendId: null
			}
			syssrv.createProject(data)

##########################################