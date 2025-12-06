import 'package:flutter/material.dart';
import 'lista_reservas_page.dart';
import 'reservations_data.dart';

class ReservaPage extends StatefulWidget {
  final String canchaName;
  final String canchaPrice;

  const ReservaPage({
    super.key,
    required this.canchaName,
    required this.canchaPrice,
  });

  @override
  State<ReservaPage> createState() => _ReservaPageState();
}

class _ReservaPageState extends State<ReservaPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController telCtrl = TextEditingController();

  DateTime? fecha;
  bool cargando = false;

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
    nameCtrl.dispose();
    telCtrl.dispose();
    super.dispose();
  }

  Future<String> enviarReserva() async {
    await Future.delayed(const Duration(seconds: 1));
    return "CONF-${DateTime.now().millisecondsSinceEpoch}";
  }

  void confirmar() async {
    if (nameCtrl.text.isEmpty || telCtrl.text.isEmpty || fecha == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    setState(() => cargando = true);

    final codigo = await enviarReserva();

    reservasGuardadas.add(
      Reserva(
        cancha: widget.canchaName,
        nombre: nameCtrl.text,
        telefono: telCtrl.text,
        fecha: fecha.toString().split(" ")[0],
        codigo: codigo,
      ),
    );

    setState(() => cargando = false);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ListaReservasPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Reservar Cancha"),
        backgroundColor: Colors.deepOrange.shade700,
        elevation: 6,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con degradado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepOrange.shade400, Colors.orange.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.canchaName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Precio: ${widget.canchaPrice}",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Nombre
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: "Nombre",
                  prefixIcon: const Icon(Icons.person, color: Colors.deepOrange),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Teléfono
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: TextField(
                controller: telCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Teléfono",
                  prefixIcon: const Icon(Icons.phone, color: Colors.deepOrange),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Fecha
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      child: Text(
                        fecha == null
                            ? "Fecha no seleccionada"
                            : fecha.toString().split(" ")[0],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade700,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    final now = DateTime.now();
                    final val = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: now,
                      lastDate: DateTime(now.year + 1),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Colors.deepOrange.shade700,
                              onPrimary: Colors.white,
                              onSurface: Colors.black87,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (val != null) {
                      setState(() => fecha = val);
                    }
                  },
                  child: const Icon(Icons.calendar_today),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Botón confirmar animado
            Center(
              child: GestureDetector(
                onTapDown: (_) => _animController.forward(),
                onTapUp: (_) => _animController.reverse(),
                onTapCancel: () => _animController.reverse(),
                onTap: confirmar,
                child: Transform.scale(
                  scale: _scaleAnim.value,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.deepOrange.shade400, Colors.orange.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: cargando
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Confirmar",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
