class Reserva {
  final String cancha;
  final String nombre;
  final String telefono;
  final String fecha;
  final String codigo;

  Reserva({
    required this.cancha,
    required this.nombre,
    required this.telefono,
    required this.fecha,
    required this.codigo,
  });
}

// Lista global (temporal mientras no hay backend)
List<Reserva> reservasGuardadas = [];
