CHAT P2P CON SERVIDOR PARA INFORMACION DE CONTROL USANDO DRB
============================================================

* Daniel Múnera Sánchez
* Ernesto Javier Quintero

REQUERIMIENTOS PARA EJECUTAR
----------------------------

* Ruby 1.9.2 

COMO EJECUTAR
-------------

* Se debe iniciar el servidor de directorio:

<code>
ruby startDir.rb <host> <port> ** Example** ruby startDir.rb localhost 2626
<code>
	
* Iniciar un Cliente para chatear:

<code>
 ruby startClient.rb <nickname> <dirhost> <dirport> <status> **Example** ruby startClient.rb dmuneras localhost 2626 online
<code>


COMANDOS DISPONIBLES
--------------------

* Para comunicarse con el servidor:

**to_s:** <commando> <parametro> 
	
**comandos:** users, status, help

Para status se tiene como parametro el nuevo status que puede ser: online, offline,away

* Para interaccion del usuario:

**help:** Muestra los comandos disponibles.

**resolved_users:** Son los usuarios con los cuales se ha interactuado y ahora no es necesario ir al servidor a preguntarle por su 
direccion para hablar con ellos.

**quit:** Para salir. 