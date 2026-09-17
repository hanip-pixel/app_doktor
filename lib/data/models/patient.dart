import '../../core/widgets/status_badge.dart';

class Patient {
  final String id;
  final String name;
  final String mrNumber;
  final String? nik;
  final int age;
  final String gender; // 'L' atau 'P'
  final String complaint;
  final String scheduleTime;
  final PatientStatus status;
  final String insurance;
  final String? noSep;

  // detail pemeriksaan (statis)
  final String? keluhanUtama;
  final String? anamnesis;
  final String? pemeriksaanFisik;
  final String? tekananDarah;
  final String? nadi;
  final String? laju;
  final String? suhu;
  final List<String> diagnosa;
  final String? rencanaTerapi;

  const Patient({
    required this.id,
    required this.name,
    required this.mrNumber,
    this.nik,
    required this.age,
    required this.gender,
    required this.complaint,
    required this.scheduleTime,
    required this.status,
    this.insurance = 'BPJS',
    this.noSep,
    this.keluhanUtama,
    this.anamnesis,
    this.pemeriksaanFisik,
    this.tekananDarah,
    this.nadi,
    this.laju,
    this.suhu,
    this.diagnosa = const [],
    this.rencanaTerapi,
  });

  Patient copyWith({
    String? id,
    String? name,
    String? mrNumber,
    String? nik,
    int? age,
    String? gender,
    String? complaint,
    String? scheduleTime,
    PatientStatus? status,
    String? insurance,
    String? noSep,
    String? keluhanUtama,
    String? anamnesis,
    String? pemeriksaanFisik,
    String? tekananDarah,
    String? nadi,
    String? laju,
    String? suhu,
    List<String>? diagnosa,
    String? rencanaTerapi,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      mrNumber: mrNumber ?? this.mrNumber,
      nik: nik ?? this.nik,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      complaint: complaint ?? this.complaint,
      scheduleTime: scheduleTime ?? this.scheduleTime,
      status: status ?? this.status,
      insurance: insurance ?? this.insurance,
      noSep: noSep ?? this.noSep,
      keluhanUtama: keluhanUtama ?? this.keluhanUtama,
      anamnesis: anamnesis ?? this.anamnesis,
      pemeriksaanFisik: pemeriksaanFisik ?? this.pemeriksaanFisik,
      tekananDarah: tekananDarah ?? this.tekananDarah,
      nadi: nadi ?? this.nadi,
      laju: laju ?? this.laju,
      suhu: suhu ?? this.suhu,
      diagnosa: diagnosa ?? this.diagnosa,
      rencanaTerapi: rencanaTerapi ?? this.rencanaTerapi,
    );
  }
}
