import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'reservations_data.dart';

class PDFGenerator {
  static Future<void> generarPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(30),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // -----------------------
              // TÍTULO MEJORADO
              // -----------------------
              pw.Center(
                child: pw.Text(
                  "MIS RESERVAS",
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.SizedBox(height: 20),

              // -----------------------
              // LISTA DE RESERVAS
              // -----------------------
              ...reservasGuardadas.map((r) {
                return pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  margin: const pw.EdgeInsets.only(bottom: 16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 1.2),
                    borderRadius: pw.BorderRadius.circular(12),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // TITULO DE LA TARJETA
                      pw.Text(
                        "Cancha: ${r.cancha}",
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),

                      pw.SizedBox(height: 8),

                      // CAMPOS (limpios y alineados)
                      pw.Text("Fecha: ${r.fecha}"),
                      pw.Text("Nombre: ${r.nombre}"),
                      pw.Text("Teléfono: ${r.telefono}"),
                      pw.Text("Código: ${r.codigo}"),
                    ],
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}
