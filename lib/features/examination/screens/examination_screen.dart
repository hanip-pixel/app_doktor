import 'package:flutter/material.dart';
import '../../../core/widgets/patient_header_card.dart';
import '../../../data/models/patient.dart';
import '../widgets/examination_flow_view.dart';

class ExaminationScreen extends StatefulWidget {
  final Patient patient;

  const ExaminationScreen({super.key, required this.patient});

  @override
  State<ExaminationScreen> createState() => _ExaminationScreenState();
}

class _ExaminationScreenState extends State<ExaminationScreen> {
  late Patient _patient;

  @override
  void initState() {
    super.initState();
    _patient = widget.patient;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Minimalist Top App Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 2),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF0F172A),
                      size: 24,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Pemeriksaan Pasien',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),

            // Patient Header Card
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
              child: PatientHeaderCard(patient: _patient),
            ),

            // Reusable 3-Step Examination Flow (Layanan -> Isi Form -> Validasi)
            Expanded(
              child: ExaminationFlowView(
                patient: _patient,
                onSaved: (updated) {
                  setState(() {
                    _patient = updated;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
