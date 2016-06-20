# PSP Connect - Web Platform
This repository contains all the content of the thesis named "Design and Implementation of a web plataform that supports the Personal Software Process Methodology".


## Using and Working in the Software

### Initial Installation:
To be able to run the web application "PSP Connect" in your computer you need to install the Meteor Framework.
For more information of how to install Meteor, go to the [Meteor Installation Guide](https://www.meteor.com/install)


### Starting the Application in your Computer:
Start the application locally (inside the root directory of the git repository):

	$ meteor

After running the application locally, open this address in the browser:

	http://localhost:3000


### Compiling the TeX Document in your Computer:
Inside of the Document folder there should be a rerunlatex file. This file compiles al the project automatically. To run this you should run the next command (It can be run inside the Anteproyecto folder and the Final Document folder):

	$ ./rerunlatex

### Main Folder Structure:

* Document - Document of the Thesis.
* Project - All the web platform.
* Others - Images, logos, wireframes, etc.

###Web Platform Folder Structure:
* client - Here are all the files that the user will have access to.
* lib - This are the files compiled and rendered both in the server and in the client view.
* public - This are public files that can be accessed by the client and the server.
* server - Here is all the main funcionality with the platform database and all the functions that gives the client access to the data.

### How we use Git:

* If you start developing a new feature or a fix for the web platform, you should create a new branch using the name (PDG<*Vivify-Scrum-Number*>) where the *Vivify-Scrum-Number* is the id of the item you will work on from VivifyScrum. When you finish your development, make a pull request so it can be merged to master.
* Master Branch contains the actual development of the platform.

## Credits
This software and document is a development for the assigment "Thesis" in the Pontifical Xaverian University in Cali, Colombia.

This project is developed by the students Juan Pablo Mejía Duque and Sebastian Lozano Herrera with the full guidance of our thesis director Luisa Fernanda Rincón Pérez.
