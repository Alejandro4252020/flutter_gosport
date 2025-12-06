import 'package:flutter/material.dart';
import 'reservations_data.dart';
import 'home_page.dart';
import 'pdf_generator.dart'; //    IMPORTANTE PARA EL PDF


class ListaReservasPage extends StatefulWidget {
  const ListaReservasPage({super.key});

  @override
  State<ListaReservasPage> createState() => _ListaReservasPageState();
}

class _ListaReservasPageState extends State<ListaReservasPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  // --- Colores del Diseño Oscuro ---
  final Color _darkBackground = const Color(0xFF2C2F33); // Fondo principal
  final Color _cardBackground = const Color(0xFF42464D); // Fondo de las Cards
  final Color _accentColor = const Color.fromARGB(255, 255, 255, 255); // Color de acento (Appbar, botones)

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🎨 Fondo Oscuro
      backgroundColor: _darkBackground,
      appBar: AppBar(
        title: const Text("Mis Reservas", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 6,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            
            onPressed: () {
              PDFGenerator.generarPDF();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: reservasGuardadas.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.sports_soccer, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "No tienes reservas aún",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: reservasGuardadas.length,
                    itemBuilder: (context, i) {
                      final r = reservasGuardadas[i];
                      return Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.only(bottom: 16),
                        // 🎨 Color de Card Oscuro
                        color: _cardBackground,
                        shadowColor: Colors.black45,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            // Se reemplaza el gradiente claro por un color solido oscuro o un gradiente sutil
                            color: _cardBackground,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r.cancha,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  // 🎨 Texto de Cancha en color de acento
                                  color: _accentColor,
                                ),
                              ),
                              const SizedBox(height: 12),
                              // 🎨 Filas de tabla con texto blanco/gris claro
                              _filaTabla("Fecha:", r.fecha),
                              _filaTabla("Nombre:", r.nombre),
                              _filaTabla("Teléfono:", r.telefono),
                              _filaTabla("Código:", r.codigo),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // 🎨 Botones TextButton se mantienen, pero con color de fondo oscuro se notan más
                                  _botonEditar(i, r),
                                  const SizedBox(width: 10),
                                  _botonEliminar(i),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // 🎨 Botones de acción inferiores
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _botonPrincipal(
                  icon: Icons.home,
                  texto: "Volver al Inicio",
                  color: Colors.blue.shade700, // Color azul para el inicio
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false,
                    );
                  },
                ),
                const SizedBox(height: 12),
                _botonPrincipal(
                  icon: Icons.picture_as_pdf,
                  texto: "Imprimir Comprobante de Reserva",
                  color: Colors.green.shade700,
                  onTap: () => PDFGenerator.generarPDF(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------
  // 🟦 WIDGET REUSABLE PARA FORMATO "TABLA BONITA"
  // ---------------------------------------------
  Widget _filaTabla(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              titulo,
              style: TextStyle(
                //  Texto en color claro
                fontWeight: FontWeight.bold, 
                color: Colors.grey.shade300, 
              ),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              //  Texto en color claro
              style: const TextStyle(color: Colors.white), 
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------
  // BOTÓN EDITAR
  // -----------------------------
  Widget _botonEditar(int index, Reserva r) {
    return TextButton.icon(
      icon: const Icon(Icons.edit, color: Colors.blueAccent), // 🎨 Azul para editar
      label: const Text("Editar", style: TextStyle(color: Colors.blueAccent)), // 🎨 Azul para editar
      onPressed: () async {
        final editado = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditarReservaPage(
              index: index,
              reserva: r,
            ),
          ),
        );

        if (editado == true) {
          setState(() {});
        }
      },
    );
  }

  // -----------------------------
  // BOTÓN ELIMINAR
  // -----------------------------
  Widget _botonEliminar(int index) {
    return TextButton.icon(
      icon: const Icon(Icons.delete, color: Colors.red),
      label: const Text("Eliminar", style: TextStyle(color: Colors.red)),
      onPressed: () {
        setState(() {
          reservasGuardadas.removeAt(index);
        });
      },
    );
  }

  // -----------------------------
  // BOTÓN PRINCIPAL CON GRADIENTE
  // -----------------------------
  Widget _botonPrincipal(
      {required IconData icon,
      required String texto,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTapDown: (_) => _animController.forward(),
      onTapUp: (_) => _animController.reverse(),
      onTapCancel: () => _animController.reverse(),
      onTap: onTap,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnim.value,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  // ignore: deprecated_member_use
                  colors: [color.withOpacity(0.8), color],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: color.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    texto,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ------------------------------------------------------
// 🔧 Pantalla simple para EDITAR con estilo oscuro (simil 'Editar Usuario' de la imagen)
// ------------------------------------------------------
class EditarReservaPage extends StatefulWidget {
  final int index;
  final Reserva reserva;

  const EditarReservaPage({required this.index, required this.reserva, super.key});

  @override
  State<EditarReservaPage> createState() => _EditarReservaPageState();
}

class _EditarReservaPageState extends State<EditarReservaPage> {
  late TextEditingController nombre;
  late TextEditingController telefono;

  // --- Colores del Diseño Oscuro para la edición ---
  final Color _darkBackground = const Color(0xFF23272A); // Gris oscuro profundo
  final Color _cardBackground = const Color(0xFF36393E); // Gris más claro para el contenedor principal
  final Color _inputBackground = Colors.white; // Fondo blanco para los inputs (como en la imagen)

  @override
  void initState() {
    super.initState();
    nombre = TextEditingController(text: widget.reserva.nombre);
    telefono = TextEditingController(text: widget.reserva.telefono);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBackground,
      appBar: AppBar(
        title: const Text("Editar Reserva", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              // Contenedor principal del formulario
              color: _cardBackground, 
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Editar Reserva", 
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                
                // --- Input Nombre ---
                const Text("Nombre", style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 8),
                _buildTextField(nombre, "Nombre"),
                
                const SizedBox(height: 16),
                
                // --- Input Teléfono ---
                const Text("Teléfono", style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 8),
                _buildTextField(telefono, "Teléfono"),

                // Nota: Tu modelo actual solo tiene Nombre y Teléfono para editar.
                // Si quisieras agregar 'Correo' y 'Contraseña' como en la imagen, necesitarías
                // agregar esas propiedades a tu clase 'Reserva' y a los TextEditingController.
                
                const SizedBox(height: 30),
                
                // --- Botones Guardar y Cancelar ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildDarkButton("Guardar", const Color.fromARGB(255, 33, 185, 41), () {
                      reservasGuardadas[widget.index] = Reserva(
                        cancha: widget.reserva.cancha,
                        fecha: widget.reserva.fecha,
                        codigo: widget.reserva.codigo,
                        nombre: nombre.text,
                        telefono: telefono.text,
                      );
                      Navigator.pop(context, true);
                    }),
                    const SizedBox(width: 15),
                    _buildDarkButton("Cancelar", Colors.grey.shade700, () {
                      Navigator.pop(context, false);
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // -----------------------------
  // WIDGET TEXTFIELD (Para diseño oscuro/claro en input)
  // -----------------------------
  Widget _buildTextField(TextEditingController controller, String label) {
    return Card(
      elevation: 0, // Sin elevación para un look más plano
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)),
      //  Fondo blanco para el input
      color: _inputBackground, 
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          // Se elimina el labelText para seguir la estructura de la imagen (Título sobre el input)
          // labelText: label,
          // labelStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  // -----------------------------
  // WIDGET BOTÓN OSCURO (Guardar/Cancelar)
  // -----------------------------
  Widget _buildDarkButton(String text, Color color, VoidCallback onTap) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          // ignore: deprecated_member_use
          backgroundColor: color.withOpacity(0.6), // Fondo oscuro sutil
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          elevation: 4,
        ),
        child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}