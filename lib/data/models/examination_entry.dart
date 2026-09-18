import 'package:flutter/material.dart';

enum ExaminationServiceType {
  cppt,
  ttv,
  diagnosaTindakan,
}

extension ExaminationServiceTypeExt on ExaminationServiceType {
  String get title {
    switch (this) {
      case ExaminationServiceType.cppt:
        return 'CPPT (SOAP)';
      case ExaminationServiceType.ttv:
        return 'Tanda-Tanda Vital (TTV)';
      case ExaminationServiceType.diagnosaTindakan:
        return 'Diagnosa & Tindakan';
    }
  }

  String get subtitle {
    switch (this) {
      case ExaminationServiceType.cppt:
        return 'Catatan Perkembangan Pasien Terintegrasi (Subjektif, Objektif, Asesmen, Plan)';
      case ExaminationServiceType.ttv:
        return 'Tekanan Darah, Nadi, Laju Nafas, Suhu, SpO2, BB/TB & IMT';
      case ExaminationServiceType.diagnosaTindakan:
        return 'Diagnosa ICD-10, Prosedur ICD-9-CM, Rencana Terapi & Edukasi';
    }
  }

  IconData get icon {
    switch (this) {
      case ExaminationServiceType.cppt:
        return Icons.history_edu_rounded;
      case ExaminationServiceType.ttv:
        return Icons.favorite_rounded;
      case ExaminationServiceType.diagnosaTindakan:
        return Icons.assignment_turned_in_rounded;
    }
  }

  Color get color {
    switch (this) {
      case ExaminationServiceType.cppt:
        return const Color(0xFF00897B);
      case ExaminationServiceType.ttv:
        return const Color(0xFFE11D48);
      case ExaminationServiceType.diagnosaTindakan:
        return const Color(0xFF2563EB);
    }
  }

  Color get bgColor {
    switch (this) {
      case ExaminationServiceType.cppt:
        return const Color(0xFFE0F2F1);
      case ExaminationServiceType.ttv:
        return const Color(0xFFFFE4E6);
      case ExaminationServiceType.diagnosaTindakan:
        return const Color(0xFFDBEAFE);
    }
  }
}

class CpptData {
  String subjektif;
  String objektif;
  String asesmen;
  String plan;

  CpptData({
    this.subjektif = '',
    this.objektif = '',
    this.asesmen = '',
    this.plan = '',
  });

  CpptData copyWith({
    String? subjektif,
    String? objektif,
    String? asesmen,
    String? plan,
  }) {
    return CpptData(
      subjektif: subjektif ?? this.subjektif,
      objektif: objektif ?? this.objektif,
      asesmen: asesmen ?? this.asesmen,
      plan: plan ?? this.plan,
    );
  }

  bool get isFilled =>
      subjektif.isNotEmpty ||
      objektif.isNotEmpty ||
      asesmen.isNotEmpty ||
      plan.isNotEmpty;
}

class TtvData {
  String tekananDarah; // contoh: 120/80
  String nadi; // contoh: 80
  String lajuNafas; // contoh: 18
  String suhu; // contoh: 36.5
  String spo2; // contoh: 98
  String beratBadan; // contoh: 65
  String tinggiBadan; // contoh: 170

  TtvData({
    this.tekananDarah = '120/80',
    this.nadi = '80',
    this.lajuNafas = '18',
    this.suhu = '36.5',
    this.spo2 = '98',
    this.beratBadan = '65',
    this.tinggiBadan = '170',
  });

  double? get imt {
    final bb = double.tryParse(beratBadan);
    final tb = double.tryParse(tinggiBadan);
    if (bb != null && tb != null && tb > 0) {
      final tbMeter = tb / 100.0;
      return bb / (tbMeter * tbMeter);
    }
    return null;
  }

  String get imtCategory {
    final val = imt;
    if (val == null) return '-';
    if (val < 18.5) return 'Berat Badan Kurang';
    if (val < 25.0) return 'Normal';
    if (val < 30.0) return 'Kelebihan Berat Badan';
    return 'Obesitas';
  }

  TtvData copyWith({
    String? tekananDarah,
    String? nadi,
    String? lajuNafas,
    String? suhu,
    String? spo2,
    String? beratBadan,
    String? tinggiBadan,
  }) {
    return TtvData(
      tekananDarah: tekananDarah ?? this.tekananDarah,
      nadi: nadi ?? this.nadi,
      lajuNafas: lajuNafas ?? this.lajuNafas,
      suhu: suhu ?? this.suhu,
      spo2: spo2 ?? this.spo2,
      beratBadan: beratBadan ?? this.beratBadan,
      tinggiBadan: tinggiBadan ?? this.tinggiBadan,
    );
  }

  bool get isFilled =>
      tekananDarah.isNotEmpty ||
      nadi.isNotEmpty ||
      lajuNafas.isNotEmpty ||
      suhu.isNotEmpty;
}

class DiagnosaTindakanData {
  List<String> diagnosaList; // ICD-10
  List<String> tindakanList; // ICD-9-CM
  String rencanaTerapi;
  String catatanEdukasi;

  DiagnosaTindakanData({
    List<String>? diagnosaList,
    List<String>? tindakanList,
    this.rencanaTerapi = '',
    this.catatanEdukasi = '',
  })  : diagnosaList = diagnosaList ?? [],
        tindakanList = tindakanList ?? [];

  DiagnosaTindakanData copyWith({
    List<String>? diagnosaList,
    List<String>? tindakanList,
    String? rencanaTerapi,
    String? catatanEdukasi,
  }) {
    return DiagnosaTindakanData(
      diagnosaList: diagnosaList != null ? List.from(diagnosaList) : List.from(this.diagnosaList),
      tindakanList: tindakanList != null ? List.from(tindakanList) : List.from(this.tindakanList),
      rencanaTerapi: rencanaTerapi ?? this.rencanaTerapi,
      catatanEdukasi: catatanEdukasi ?? this.catatanEdukasi,
    );
  }

  bool get isFilled =>
      diagnosaList.isNotEmpty ||
      tindakanList.isNotEmpty ||
      rencanaTerapi.isNotEmpty ||
      catatanEdukasi.isNotEmpty;
}

enum ExaminationFlowStep {
  selectServices, // Step 1: Memilih layanan pemeriksaan (CPPT, TTV, Diagnosa/Tindakan)
  inputForm,      // Step 2: Mengisi formulir pemeriksaan
  review,         // Step 3: Meninjau hasil pemeriksaan (Tersedia tombol Edit & Hapus)
  saved,          // Step 4: Selesai disimpan / Finalisasi
}
