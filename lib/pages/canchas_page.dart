import 'package:flutter/material.dart';
import 'reserva_page.dart';

class CanchasPage extends StatelessWidget {
  const CanchasPage({super.key});

  final List<Map<String, String>> canchas = const [
    {"name": "Cancha Central", "type": "Fútbol 5", "price": "\$20", "icon": "assets/icons/futbol_5.png"},
    {"name": "Cancha Norte", "type": "Fútbol 7", "price": "\$35", "icon": "assets/icons/futbol_7.png"},
    {"name": "Cancha Sur", "type": "Tenis", "price": "\$25", "icon": "assets/icons/tenis.png"},
    {"name": "Cancha Este", "type": "Basket", "price": "\$30", "icon": "assets/icons/basket.png"},
  ];

  @override
  Widget build(BuildContext context) {
    // Definimos el color neón/verde brillante
    const Color neonColor = Color(0xFF00FF00); 

    return Scaffold(
      // === CAMBIO 1: FONDO OSCURO CON GRADIENTE NEÓN (Simulando el estilo de la imagen) ===
      backgroundColor: const Color(0xFF1E2124), 
      
      appBar: AppBar(
        title: const Text(
          'Canchas Disponibles ⚽',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1565C0), // Mantener el App Bar azul
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Stack(
        children: [
          // Puedes agregar un widget para simular el fondo hexagonal y neón si tienes los assets
          // Por ahora, usaremos un Container con gradiente simple para el efecto oscuro
          
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: canchas.length,
            itemBuilder: (context, index) {
              final cancha = canchas[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReservaPage(
                        canchaName: cancha['name']!,
                        canchaPrice: cancha['price']!,
                      ),
                    ),
                  );
                },

                // === CAMBIO 2: Diseño de la tarjeta para un look deportivo oscuro y neón ===
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B2F33), // Color de fondo de la tarjeta oscuro
                    borderRadius: BorderRadius.circular(10),
                    // ignore: deprecated_member_use
                    border: Border.all(color: neonColor.withOpacity(0.4), width: 1), // Borde neón
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: neonColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      // Ícono/Imagen (simulando el diseño de la imagen)
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF42474D), // Fondo del ícono/imagen
                          borderRadius: BorderRadius.circular(8),
                          // ignore: deprecated_member_use
                          border: Border.all(color: neonColor.withOpacity(0.6), width: 1.5),
                        ),
                        child: Icon(
                            // Se asume que tienes íconos específicos. Usamos un default por ahora.
                            _getIconForCancha(cancha['type']!), 
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.9), 
                            size: 30,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cancha['name']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Texto blanco
                              ),
                            ),
                            Text(
                              cancha['type']!,
                              // ignore: deprecated_member_use
                              style: TextStyle(color: neonColor.withOpacity(0.8), fontSize: 14), // Tipo en color neón
                            ),
                          ],
                        ),
                      ),

                      // Precio con estilo de "flecha" o resaltado (simulado con un Container)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: neonColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: neonColor, width: 1),
                        ),
                        child: Text(
                          cancha['price']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: neonColor, // Precio en color neón
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Función auxiliar para obtener íconos según el tipo de cancha
  IconData _getIconForCancha(String type) {
    switch (type) {
      case 'Fútbol 5':
      case 'Fútbol 7':
        return Icons.sports_soccer;
      case 'Tenis':
        return Icons.sports_tennis;
      case 'Basket':
        return Icons.sports_basketball;
      default:
        return Icons.sports_score;
    }
  }
}