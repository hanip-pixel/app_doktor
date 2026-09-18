import '../../core/widgets/status_badge.dart';
import 'examination_entry.dart';

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

  // detail pemeriksaan (statis / kompatibilitas)
  final String? keluhanUtama;
  final String? anamnesis;
  final String? pemeriksaanFisik;
  final String? tekananDarah;
  final String? nadi;
  final String? laju;
  final String? suhu;
  final List<String> diagnosa;
  final List<String> tindakan;
  final String? rencanaTerapi;

  // Detail Pemeriksaan Layanan Baru (CPPT, TTV, Diagnosa/Tindakan)
  final CpptData? cpptData;
  final TtvData? ttvData;
  final DiagnosaTindakanData? diagnosaTindakanData;

  // Identitas Tambahan Demografis & Layanan
  final String? birthDate;
  final String? bloodType;
  final String? phone;
  final String? address;
  final List<String> allergies;
  final String? poli;
  final String? dpjp;
  final String? emergencyContact;
  final String? occupation;

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
    this.birthDate,
    this.bloodType,
    this.phone,
    this.address,
    this.allergies = const [],
    this.poli = 'Poli Penyakit Dalam',
    this.dpjp = 'dr. Andi Pratama, Sp.PD',
    this.emergencyContact,
    this.occupation,
    this.keluhanUtama,
    this.anamnesis,
    this.pemeriksaanFisik,
    this.tekananDarah,
    this.nadi,
    this.laju,
    this.suhu,
    this.diagnosa = const [],
    this.tindakan = const [],
    this.rencanaTerapi,
    this.cpptData,
    this.ttvData,
    this.diagnosaTindakanData,
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
    String? birthDate,
    String? bloodType,
    String? phone,
    String? address,
    List<String>? allergies,
    String? poli,
    String? dpjp,
    String? emergencyContact,
    String? occupation,
    String? keluhanUtama,
    String? anamnesis,
    String? pemeriksaanFisik,
    String? tekananDarah,
    String? nadi,
    String? laju,
    String? suhu,
    List<String>? diagnosa,
    List<String>? tindakan,
    String? rencanaTerapi,
    CpptData? cpptData,
    TtvData? ttvData,
    DiagnosaTindakanData? diagnosaTindakanData,
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
      birthDate: birthDate ?? this.birthDate,
      bloodType: bloodType ?? this.bloodType,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      allergies: allergies ?? this.allergies,
      poli: poli ?? this.poli,
      dpjp: dpjp ?? this.dpjp,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      occupation: occupation ?? this.occupation,
      keluhanUtama: keluhanUtama ?? this.keluhanUtama,
      anamnesis: anamnesis ?? this.anamnesis,
      pemeriksaanFisik: pemeriksaanFisik ?? this.pemeriksaanFisik,
      tekananDarah: tekananDarah ?? this.tekananDarah,
      nadi: nadi ?? this.nadi,
      laju: laju ?? this.laju,
      suhu: suhu ?? this.suhu,
      diagnosa: diagnosa ?? this.diagnosa,
      tindakan: tindakan ?? this.tindakan,
      rencanaTerapi: rencanaTerapi ?? this.rencanaTerapi,
      cpptData: cpptData ?? this.cpptData,
      ttvData: ttvData ?? this.ttvData,
      diagnosaTindakanData:
          diagnosaTindakanData ?? this.diagnosaTindakanData,
    );
  }
}

