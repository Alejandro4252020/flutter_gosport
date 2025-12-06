import 'package:flutter/material.dart';
import 'canchas_page.dart';
import 'lista_reservas_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(_animController);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // Definiendo el gradiente de verde claro para ambas tarjetas
  final LinearGradient _gradienteVerdeClaro = LinearGradient(
    colors: [const Color.fromARGB(255, 0, 0, 0), const Color.fromARGB(255, 11, 0, 0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Definiendo el color de texto oscuro para el botón
  final Color _colorTextoBotonOscuro = const Color.fromARGB(255, 0, 0, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        // ===================================
        // 💡 AGREGAR EL ICONO/LOGO (LEADING)
        // ===================================
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0), // Margen a la izquierda
          child: Image.asset(
            'assets/images/logosport.png', // <-- REEMPLAZA 'logo.png' CON LA RUTA REAL DE TU LOGO
            height: 40,
            width: 40,
          ),
        ),
        
        title: const Text(
          'GOSPORTS',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Color.fromARGB(255, 239, 239, 239)),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 6,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Imagen superior con overlay blanco
              _imagenConOverlay('assets/images/nueva.png', height: 500),

              const SizedBox(height: 25),

              // === ROW para poner las tarjetas lado a lado ===
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TARJETA 1 — Reserva tus canchas (VERDE CLARO)
                  Expanded(
                    child: _tarjetaAnimada(
                      titulo: "Reserva tus canchas",
                      icon: 'assets/images/cancelar.png',
                      // === CAMBIO DE COLOR AQUÍ ===
                      gradiente: _gradienteVerdeClaro,
                      colorBoton: const Color.fromARGB(255, 254, 254, 254),
                      // === AJUSTE DE TEXTO DE BOTÓN AQUÍ ===
                      colorTextoBoton: _colorTextoBotonOscuro,
                      textoBoton: "Ver Canchas",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CanchasPage()),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 16), // Espacio entre las tarjetas

                  // TARJETA 2 — Mis Reservas (VERDE CLARO)
                  Expanded(
                    child: _tarjetaAnimada(
                      titulo: "Mis Reservas",
                      icon: 'assets/images/cancha-de-futbol.png',
                      // === CAMBIO DE COLOR AQUÍ ===
                      gradiente: _gradienteVerdeClaro,
                      colorBoton: Colors.white,
                      // === AJUSTE DE TEXTO DE BOTÓN AQUÍ ===
                      colorTextoBoton: _colorTextoBotonOscuro,
                      textoBoton: "Ver Historial",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ListaReservasPage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              // =============================================================

              const SizedBox(height: 25),

              // Imagen inferior con overlay blanco
              _imagenConOverlay('assets/images/black.webp', height: 200),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      // ===========================================
      // FOOTER AGREGADO (bottomNavigationBar)
      // ===========================================
      bottomNavigationBar: BottomAppBar(
        color: Colors.black, // Fondo negro
        child: Container(
          height: 45,
          alignment: Alignment.center,
          child: const Text(
            '© 2024 GOSPORTS. Todos los derechos reservados.',
            style: TextStyle(
              color: Colors.white, // Texto blanco
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  // Imagen con overlay BLANCO suave
  Widget _imagenConOverlay(String path, {required double height}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Image.asset(
            path,
            height: height,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  // ignore: deprecated_member_use
                  Colors.white.withOpacity(0.4),
                  Colors.transparent
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tarjeta animada, ajustada para un espacio más pequeño
  Widget _tarjetaAnimada({
    required String titulo,
    String? icon,
    IconData? icono,
    required LinearGradient gradiente,
    required Color colorBoton,
    required Color colorTextoBoton,
    required String textoBoton,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTapDown: (_) => _animController.forward(),
      onTapUp: (_) => _animController.reverse(),
      onTapCancel: () => _animController.reverse(),
      onTap: onTap,
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnim.value,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 250, // Mantenemos la altura fija para la alineación
          decoration: BoxDecoration(
            gradient: gradiente,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 1. Icono / Imagen (Centrado y más pequeño)
              SizedBox(
                width: 60,
                height: 60,
                child: icon != null
                    ? Image.asset(icon)
                    : Center(
                        child: Icon(
                          icono,
                          size: 50,
                          color: Colors.white, // Mantenemos el ícono blanco
                        ),
                      ),
              ),
              
              // 2. Título (Centrado)
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Mantenemos el texto blanco
                  letterSpacing: 0.5,
                ),
              ),

              // 3. Botón (Centrado)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorBoton,
                  foregroundColor: colorTextoBoton,
                  elevation: 6,
                  shadowColor: Colors.black38,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                onPressed: onTap,
                child: Text(textoBoton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}