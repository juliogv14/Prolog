/*****************************************************************************

		Copyright (c) My Company

 Project:  ALMACEN
 FileName: ALMACEN.PRO
 Purpose: No description
 Written by: David Flores Barbero and Julio Garc�a Valdunciel
 Comments:
******************************************************************************/

include "almacen.inc"


domains

	estanteriaID=symbol
	posicion=symbol
	
	producto=symbol
	cantidad=integer
	
	distancia=integer

	lineapedido=linea(producto,cantidad)
	listaPedido=lineapedido*
	
	listaPosiciones=posicion*
	
	
predicates

	/*establecer posiciones de las estanterias*/
	estanteria(estanteriaID,posicion).
	
	/*establecer objetos de las estanterias*/
	ubicacion(producto,estanteriaID,cantidad)
	
	/*establecer las posiciones de los objetos*/
	conectado(posicion,posicion,distancia)

	/*predicado para introducir un pedido*/
	
	realizarPedido(listaPedido)
	resuelveLineas(listaPedido, posicion, distancia).
	busquedaEstanteria(posicion, posicion, listaPosiciones, distancia).	

	buscaFinal(posicion, distancia, distancia).
	
	escribeLista(listaPosiciones).

	escribeProductos(listaPedido).
	
	miembro(posicion, listaPosiciones).
	
	buscaConectados(posicion, posicion, distancia).

	
clauses 

	/*establecer posiciones de las estanterias*/
	estanteria(s1,ps1).
	estanteria(s2,ps2).
	estanteria(s3,ps3).
	estanteria(s4,ps4).
	estanteria(s5,ps5).
	estanteria(s6,ps6).
	estanteria(s7,ps7).
	estanteria(s8,ps8).

	/*distancia estanterias pasillo central*/
	conectado(ps1,pc1,5).
	conectado(ps2,pc2,5).
	conectado(ps3,pc3,5).
	conectado(ps4,pc4,5).
	conectado(ps5,pc1,5).
	conectado(ps6,pc2,5).
	conectado(ps7,pc3,5).
	conectado(ps8,pc4,5).
	
	/*distnacia pasillo central*/
	conectado(pcs,pc1,10).
	conectado(pc1,pc2,10).
	conectado(pc2,pc3,10).
	conectado(pc3,pc4,10).
	conectado(pct,pc4,10).

	/* Contenido del almacen */
	ubicacion(patatas,s1,200).
	ubicacion(melones,s1,100).
	ubicacion(boligrafos,s2,500).
	ubicacion(boligrafos,s3,400).
	ubicacion(melocotones,s4,200).
	ubicacion(berzas,s4,100).
	ubicacion(papeles,s5,500).
	ubicacion(boligrafos,s6,400).
	ubicacion(plumas,s7,500).
	ubicacion(plumas,s8,400).
	ubicacion(colonias,s3,150).
	ubicacion(ratones,s4,210).
	
	escribeLista([]).
	escribeLista([H|T]):-
		escribeLista(T),
        	write(H,'\n').
        	
        miembro(E,[E|_]).
        miembro(E,[_|T]):-
        	miembro(E,T).
        	
	escribeProductos([Linea|[]]):-
		Linea = linea(Prod, _),
		write(Prod, ".").
	escribeProductos(ListaPedido):-
		ListaPedido = [Linea | R],
		Linea = linea(Prod, _),
		write(Prod, ", "),
		escribeProductos(R).


	realizarPedido(ListaPedido):-
		write("Recorrido para: "),
		escribeProductos(ListaPedido),
		write("\npcs\n"),
		resuelveLineas(ListaPedido, pcs, 0).


	resuelveLineas([], PosActual, DistanciaActual):-
		buscaFinal(PosActual, DistanciaActual, DistanciaTotal),
		write('\n', "Distancia total: ", DistanciaTotal,'\n').
		
	resuelveLineas(ListaPedido, PosIni, DistanciaAnt):-
		ListaPedido = [Linea | Resto],
		Linea = linea(Producto, Cantidad),
		
		ubicacion(Producto, Estanteria, CantidadExistente),
		Cantidad < CantidadExistente,
		
		estanteria(Estanteria, PosDest),
		ListaPos = [],

		busquedaEstanteria(PosDest, PosIni, ListaPos, DistanciaLinea),
		
		DistanciaActual = DistanciaAnt + DistanciaLinea,

		resuelveLineas(Resto, PosDest, DistanciaActual).

	
	busquedaEstanteria(PosDest, PosActual, ListaPos, 0):-
		PosDest = PosActual,
		escribeLista(ListaPos).
		
	busquedaEstanteria(PosDest, PosActual, ListaPos, DistanciaActual):-
		
		buscaConectados(PosActual, PosSig, IncDist),
		not(miembro(PosSig,ListaPos)),
		
		NuevaListaPos = [PosSig | ListaPos],
		busquedaEstanteria(PosDest, PosSig, NuevaListaPos, DistanciaAnt),	
		DistanciaActual = DistanciaAnt + IncDist.
		/*write(PosActual,"|",PosSig,":", DistanciaActual, "->").*/
		
	buscaConectados(PosActual, PosSig, Distancia):-
		conectado(PosSig, PosActual, Distancia);
		conectado(PosActual, PosSig, Distancia).

	
	buscaFinal(PosActual, DistanciaActual, DistanciaTotal):-
		ListaPos = [],
		busquedaEstanteria(pct, PosActual, ListaPos, DistanciaLinea),
		DistanciaTotal = DistanciaActual + DistanciaLinea.
	
goal

	/*pedido a realizar*/
	realizarPedido([linea(papeles,140),linea(plumas,10),linea(patatas,40)]).
	

	/*Estado final lista vacia*/