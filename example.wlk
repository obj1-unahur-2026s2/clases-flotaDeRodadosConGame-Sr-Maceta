import wollok.game.*
class Rodado {
    const property capacidad    //Numero
    const property velocidadMaxima   //Numero
    const property color    //String
    const property peso     //Numero

    var property position = game.origin()
    const posicionesVisitadas = []

    method moverA(nuevaPosicion) {
        position = nuevaPosicion
        posicionesVisitadas.add(nuevaPosicion)
    }
    method pasoPor(posicionBuscada) =
        posicionesVisitadas.any({p => p == posicionBuscada})
    method pasoPorFila(numero) =
        posicionesVisitadas.any({p => p.x() == numero})
    method recorrioFilas(listaDeNumeros) =
        listaDeNumeros.all({n => self.pasoPorFila(n)})

    var imagenActual = "autitorojo.png"
    method image() = imagenActual
    method cambiarARojo() {
        imagenActual = "autitorojo.png"
    }
    method cambiarAAzul() {
        imagenActual = "autitoAzul.png"
    }
    method cambiarAVerde() {
        imagenActual = "autitoVerde.png"
    }

    method moverDerecha() = self.position().right(1)
    method moverIzquierda() = self.position().left(1)
    method subir() = self.position().up(1)
    method bajar() = self.position().down(1)
}

object tipoDeRodado {
    method crearCorsa(colorDelCorsa, positionC){
        return new Rodado(
            capacidad = 4,
            velocidadMaxima = 150,
            color = colorDelCorsa,
            peso = 1300,
            position = positionC
        )
    } 
    method crearKwidSinTanqueAdicional(){
        return new Rodado(
            capacidad = 4,
            velocidadMaxima = 110,
            color = "Azul",
            peso = 1200
        )
    }
    method crearKwidConTanqueAdicional(){
        return new Rodado(
            capacidad = 3,
            velocidadMaxima = 120,
            color = "Azul",
            peso = 1350
        )
    }
    method crearRodadoEspecial(capacidadE, velocidadMaximaE, colorE, pesoE) {
        return new Rodado(
            capacidad = capacidadE,
            velocidadMaxima = velocidadMaximaE,
            color = colorE,
            peso = pesoE
        )
    }
}

object trafic {
    var tipoDeInterior = comodo
    var tipoDeMotor = pulenta
    method capacidad() = tipoDeInterior.capacidad()
    method velocidadMaxima() = tipoDeMotor.velocidadMaxima()
    method color() = "Blanco"
    method peso() = 4000 + tipoDeInterior.peso() + tipoDeMotor.peso()
    method cambiarInterior(nuevoInterior) {
        tipoDeInterior = nuevoInterior
    }
    method cambiarMotor(nuevoMotor) {
        tipoDeMotor = nuevoMotor
    }
}

object comodo {
    method capacidad() = 5
    method peso() = 700
}

object popular {
    method capacidad() = 12
    method peso() = 1000
}

object pulenta {
    method velocidadMaxima() = 130
    method peso() = 800
}

object bataton {
    method velocidadMaxima() = 80
    method peso() = 500
}

class Dependencia {
    const flota = []
    const empleados //Numero
    method agregarAFlota(rodado) {
        flota.add(rodado)
    }
    method quitarDeFlota(rodado) {
        flota.remove(rodado)
    }
    method pesoTotalFlota() = 
        flota.sum({r => r.peso()})
    method tieneAlMenos3Rodados() =
        flota.size() >= 3
    method todosLosRodadosPuedenIrAlMenosA(velocidad) = 
        flota.all({r => r.velocidadMaxima() >= velocidad})
    method estaBienEquipada() = 
        self.tieneAlMenos3Rodados() && 
        self.todosLosRodadosPuedenIrAlMenosA(100)
    method capacidadTotalEnColor(colorTotal) = 
        flota.filter({r => r.color() == colorTotal}).sum({r => r.capacidad()})
    method colorDelRodadoMasRapido() = 
        flota.max({r => r.velocidadMaxima()}).color()
    method capacidadFaltante() = 
        empleados - flota.sum({r => r.capacidad()})
    method esGrande() = 
        (empleados >= 40) && (flota.size() >= 5)


    const registroDePedidos = []
    method agregarPedido(pedido) {
        registroDePedidos.add(pedido)
    }
    method quitarPedido(pedido) {
        registroDePedidos.remove(pedido)
    }
    method totalDePasajeroEnRegistroDePedidos() = 
        registroDePedidos.sum({p => p.cantidadDePasajeros()})
    method cualesDeLosPedidosNoPuedenSerSatisfechosPorLaDependencia() =
        registroDePedidos.filter({p => !p.puedenSatisfacerPedido(flota)})
    method todosLosPedidosTienenEsteColorComoIncompatible(posibleColorIncompatible) = 
        registroDePedidos.all({p => p.esteColorEsIncompatible(posibleColorIncompatible)})
    method relajarTodosLosPedidosRegistrados() {
        registroDePedidos.forEach({p => p.relajar()})
    }
}

class Pedido {
    const distancia //Numero en kilometros
    var tiempoMaximo    //Numero en horas
    const property cantidadDePasajeros //Numero
    const coloresIncompatibles  //Conjunto
    method velocidadRequerida() = distancia/tiempoMaximo
    method puedeSatisfacerPedido(auto) = 
        auto.velocidadMaxima() >= (self.velocidadRequerida()+10) &&
        auto.capacidad() >= self.cantidadDePasajeros() &&
        !coloresIncompatibles.any({c => c == auto.color()})
    method acelerar() {
        tiempoMaximo -= 1
    }
    method relajar() {
        tiempoMaximo += 1
    }

    method puedenSatisfacerPedido(listaDeAutos) = 
        listaDeAutos.any({a => self.puedeSatisfacerPedido(a)})
    method esteColorEsIncompatible(posibleColorIncompatible) = 
        coloresIncompatibles.any({c => c == posibleColorIncompatible})
}

object tipoDePedido {
    method crearPedido(distanciaPedido, tiempoPedido, pasajerosPedido, coloresIncompatiblesPedido) {
        return new Pedido(
            distancia = distanciaPedido,
            tiempoMaximo = tiempoPedido,
            cantidadDePasajeros = pasajerosPedido,
            coloresIncompatibles = coloresIncompatiblesPedido
        )
    }
}

object paredLadrillos {
    var imagenActual = "paredLadrillos3.jpg"
    method image() = imagenActual
    var property resistencia = 3
    var property position = game.at(5, 5)
    method chocar() {
        resistencia -= 1
        if(resistencia == 2){
            imagenActual = "paredLadrillos2.jpg"
        }else if(resistencia == 1){
            imagenActual = "paredLadrillos1.jpg"
        }else if(resistencia == 0){
            game.removeVisual(self)
        }
    }
}