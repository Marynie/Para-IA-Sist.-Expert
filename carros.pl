%declaracion de librerias

:-use_module(library(pce)).
:-use_module(library(pce_style_item)).

% metodo principal para iniciar la interfaz grafica, declaracion de
% botones, labels, y la pocicion en pantalla.
inicio:-
	new(Menu, dialog('Diagnostico de auto', size(1000,800))),
	new(L,label(nombre,'Diagnostico de auto')),
	new(@texto,label(nombre,'Responda con un Si o No a las siguientes preguntas')),
	new(@respl,label(nombre,'')),
	new(Salir,button('SALIR',and(message(Menu, destroy),message(Menu,free)))),
	new(@boton,button('realizar test',message(@prolog,botones))),


	send(Menu,append(L)),new(@btncarrera,button('Diagnostico?')),
	send(Menu,display,L,point(125,20)),
	send(Menu,display,@boton,point(100,150)),
	send(Menu,display,@texto,point(20,120)),
	send(Menu,display,Salir,point(20,400)),
	send(Menu,display,@respl,point(20,130)),
	send(Menu,open_centered).

%solucion a las fallas de acuerdo a las reglas de diagnostico

fallas(
	'HACER CAMBIO DE ACEITE:
	
	1- Primero abra el cofre y ubique la figura del carter,
	el motor debe estar tibio antes de proceder, 
	2- Despues ubicar la valvula de purgacion debajo del motor y
	colocar una cubeta debajo, a
	3- Abrir la valvula y drenar el aceite antiguo, 
	4- Vea su manual de usuario para saber
	cuantos litros de aceite necesita su coche despues de
	drenar el aceite cierre la valvula y abra el carter
	para rellenar con el nuevo aceite y tapar el carter.'):-aceite,!.

fallas('REALIZAR UNA ALINEACION Y BALANCEO:

        La solucion para esto es llevar el auto a un taller
        para que alinien y balancen las llantas del auto.'):-suspension,!.

fallas('VERIFICAR EL ESTADO ACTUAL DE LA BATERIA:

	1- Primero abra el cofre y ubique la bateria del coche
        verifique si estan bien conctados los cables, 
	2- Arranque el coche, si no arranca entonces la bateria 
	esta muerta para esto recarguela pase corriente con otro coche,
	en caso de no tener exito debera reemplazar la bateria.'):-electronico,!.

fallas('LLEGO LA HORA DE CAMBIAR TUS PASTILLAS DE FRENO:

	Si se escucha un chillido agudo al frenar es tiempo
        de cambiar las pastillas de los frenos, para ello hay
	que levantar con un gato hidraulico el lado del freno
	donde se va a cambiar, con una llave inglesa y una
	matraca aflojar los cubre pastillas y sacar las patillas
	antiguas y reponerlas con las nuevas, colocar todo en su
	lugar y bla bla bla. '):-frenos,!.

fallas('POSIBLEMENTE TU AUTO PASARA A MEJOR VIDA:

	Esta luz puede indicar varias fallas en el sistema de la ECU,
	las pricipales son fallas de sensores, servicio de motor,
	catalizador, etc. 
	Si se cuenta con un escaner automotriz puede
	borrarse la falla pero esto no arregla el problema, para ello
	acuda con su mecanico certificado por los aliens.'):-computadora,!.

fallas('SEGURO SUBES DEMASIADO EL VOLUMEN:

	1- Primero debes ubicar la bocina que no se escucha despues
        quitar o desatornillar el caparcete que protege la bocina
	y verificar que la bocina este bien conectado o tenga un cable
	quemado, 
	2- Dado uno de los casos deberas cambiar el cable
	o remplazar la bocina.
	3- Otro caso es verificar el estereo
	del auto si estan bien conectados los cables'):-sonido,!.


fallas('¡Sin resultados! 
	Si los problemas persisten utilice un dispositivo
	alienigena con mas ram y 12 nucleos cpu:/').

% preguntas para resolver las fallas con su respectivo identificador de
% falla
aceite:- cambio_aceite,
	pregunta('¿Tienes problemas de motor?'),
	pregunta('¿Su automovil gasta mas combustible de lo debido?'),
	pregunta('¿Su motor se escucha muy ruidoso? '),
	pregunta('¿Tiene problemas para arrancar el vehiculo en frio?'),
	pregunta('¿Siente que su motor tiene menos fuerza que antes? ').

suspension:- alineacion_direccion,
	pregunta('¿Tienes problemas de la suspencion?'),
	pregunta('¿Tiene su volante neutral y el auto gira?'),
	pregunta('¿Ha notado que alguna llanta se desgasta demas? '),
	pregunta('¿Su volante se mueve bastante y tiembla?').

electronico:- bateria_agotada,
	pregunta('¿Tienes problemas electricos?'),
	pregunta('¿Tus faros titilan o encienden con poca fuerza?'),
	pregunta('¿El estereo no enciende?'),
	pregunta('¿El auto emite un crack cuando lo enciende?'),
	pregunta('¿El auto no enciende de ninguna manera?'),
	pregunta('¿Su bateria es muy vieja?').

frenos:- cambio_frenos,
	pregunta('¿Tienes problemas con tus frenos?'),
	pregunta('¿Cuando frenas escuchas un ruido agudo?'),
	pregunta('¿Al frenar siente que tarda mas? ').

computadora:- check_egine,
	pregunta('¿La luz check engine se encendio en tu tablero?'),
	pregunta('¿La luz se mantiene encendida todo el tiempo?').

sonido:- cambio_bocina,
	pregunta('¿Tienes problemas con alguna bocina?'),
	pregunta('¿La bocina no se escucha nada?'),
	pregunta('¿Tu auto tiene suficiente bateria?').

%identificador de falla que dirige a las preguntas correspondientes

cambio_aceite:-pregunta('¿Tienes problemas de motor?'),!.
alineacion_direccion:-pregunta('¿Tienes problemas de la suspencion?'),!.
bateria_agotada:-pregunta('¿Tienes problemas electricos?'),!.
cambio_frenos:-pregunta('¿Tienes problemas con tus frenos?'),!.
cambio_bocina:-pregunta('¿Tienes problemas con alguna bocina?'),!.
check_egine:-pregunta('¿La luz check engine se encendio en tu tablero?'),!.

% proceso del diagnostico basado en preguntas de si y no, cuando el
% usuario dice si, se pasa a la siguiente pregunta del mismo ramo, si
% dice que no se pasa a la pregunta del siguiente ramo
% (motor,frenos,etc.)

:-dynamic si/1,no/1.
preguntar(Problema):- new(Di,dialog('Diagnostico mecanico')),
     new(L2,label(texto,'Responde las siguientes preguntas')),
     new(La,label(prob,Problema)),
     new(B1,button(si,and(message(Di,return,si)))),
     new(B2,button(no,and(message(Di,return,no)))),

         send(Di,append(L2)),
	 send(Di,append(La)),
	 send(Di,append(B1)),
	 send(Di,append(B2)),

	 send(Di,default_button,si),
	 send(Di,open_centered),get(Di,confirm,Answer),
	 write(Answer),send(Di,destroy),
	 ((Answer==si)->assert(si(Problema));
	 assert(no(Problema)),fail).

% cada vez que se conteste una pregunta la pantalla se limpia para
% volver a preguntar

pregunta(S):-(si(S)->true; (no(S)->false; preguntar(S))).
limpiar :- retract(si(_)),fail.
limpiar :- retract(no(_)),fail.
limpiar.

% proceso de eleccion de acuerdo al diagnostico basado en las preguntas
% anteriores

botones :- lim,
	send(@boton,free),
	send(@btncarrera,free),
	fallas(Falla),
	send(@texto,selection('la solucion es ')),
	send(@respl,selection(Falla)),
	new(@boton,button('inicia procedimiento mecanico',message(@prolog,botones))),
        send(Menu,display,@boton,point(40,50)),
        send(Menu,display,@btncarrera,point(20,50)),
limpiar.
lim :- send(@respl, selection('')).
