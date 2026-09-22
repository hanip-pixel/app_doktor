import '../../core/widgets/status_badge.dart';
import '../models/billing_item.dart';
import '../models/examination_entry.dart';
import '../models/patient.dart';

class DummyPatients {
  static final List<Patient> todayList = [
    // -----------------------------------------------------------------
    // 1. Tn. Budi Santoso (p1) - Sedang Diperiksa (inProgress)
    // Skenario: Hasil Rontgen Thorax baru keluar dari Radiologi.
    // -----------------------------------------------------------------
    Patient(
      id: 'p1',
      name: 'Budi Santoso',
      mrNumber: '0012345',
      nik: '3171012304790001',
      age: 45,
      gender: 'L',
      complaint: 'Kontrol - DM',
      scheduleTime: '08:00',
      status: PatientStatus.inProgress,
      insurance: 'BPJS',
      noSep: '2026R00012345',
      keluhanUtama: 'Kontrol gula darah bulanan, badan lemas dan sering haus.',
      anamnesis:
          'Riwayat DM Tipe 2 sejak 3 tahun lalu. Rutin minum Metformin. Hari ini mengeluh agak cepat lelah. Hasil rontgen thorax baru keluar: Cor CTR 54% (kardiomegali ringan), pulmo normal.',
      pemeriksaanFisik:
          'Kepala/leher: anemis (-), ikterik (-). Cor: S1-S2 reguler, batas kiri bergeser 1 jari ke lateral. Pulmo: vesikuler, ronkhi (-), wheezing (-). Ekstremitas: edema pretibial (-).',
      tekananDarah: '130/80 mmHg',
      nadi: '78 x/menit',
      laju: '20 x/menit',
      suhu: '36.5 °C',
      diagnosa: const ['E11.9  Diabetes melitus tipe 2', 'I51.7  Kardiomegali'],
      tindakan: const [
        '89.03  Wawancara dan evaluasi medis komprehensif',
        '87.44  Rontgen Thorax AP/PA',
      ],
      rencanaTerapi:
          'Metformin 500mg 3x1 pc, Glimepiride 2mg 1x1 ac, diet DM 1700 kkal.',
      cpptData: CpptData(
        subjektif:
            'Pasien datang untuk kontrol rutin DM Tipe 2. Mengeluh sering haus dan badan terasa lemas 3 hari terakhir. Diet karbohidrat belum terkontrol dengan baik.',
        objektif:
            'TD 130/80 mmHg, N 78x/m, RR 20x/m, Suhu 36.5°C, GDS 210 mg/dL. Hasil Rontgen Thorax (RAD/2026/09/0014): Kardiomegali ringan (CTR 54%), pulmo bersih tidak ada infiltrat.',
        asesmen:
            'Diabetes Melitus Tipe 2 tidak terkontrol + Kardiomegali ringan.',
        plan:
            'Edukasi diet rendah karbohidrat, olahraga jalan santai 30 mnt/hari. Metformin 500mg 3x1 dc, Glimepiride 2mg 1x1 ac.',
      ),
      ttvData: TtvData(
        tekananDarah: '130/80',
        nadi: '78',
        lajuNafas: '20',
        suhu: '36.5',
        spo2: '98',
        beratBadan: '72',
        tinggiBadan: '168',
      ),
      diagnosaTindakanData: DiagnosaTindakanData(
        diagnosaList: ['E11.9  Diabetes melitus tipe 2', 'I51.7  Kardiomegali'],
        tindakanList: [
          '89.03  Wawancara dan evaluasi medis komprehensif',
          '87.44  Rontgen Thorax AP/PA',
        ],
        rencanaTerapi:
            'Metformin 500mg 3x1 pc, Glimepiride 2mg 1x1 ac, kontrol rutin bulan depan.',
        catatanEdukasi:
            'Diet rendah gula, kurangi konsumsi nasi putih berlebih, hindari minuman manis berkalori.',
      ),
    ),

    // -----------------------------------------------------------------
    // 2. Ny. Siti Aminah (p2) - Sedang Diperiksa (inProgress)
    // Skenario: Menunggu antrean foto rontgen & USG di Instalasi Radiologi.
    // -----------------------------------------------------------------
    Patient(
      id: 'p2',
      name: 'Siti Aminah',
      mrNumber: '0012346',
      nik: '3275024508860002',
      age: 38,
      gender: 'P',
      complaint: 'Nyeri abdomen',
      scheduleTime: '08:30',
      status: PatientStatus.inProgress,
      insurance: 'BPJS',
      noSep: '2026R00012346',
      keluhanUtama: 'Nyeri perut kanan bawah sejak 2 hari yang lalu.',
      anamnesis:
          'Nyeri hilang timbul, mual (-), muntah (-). Saat ini sedang menunggu antrean pemeriksaan USG Abdomen & BNO Foto Polos di Instalasi Radiologi.',
      pemeriksaanFisik:
          'Abdomen: datar, supel, nyeri tekan titik McBurney minimal (+), defans muskular (-), bising usus normal.',
      tekananDarah: '120/80 mmHg',
      nadi: '80 x/menit',
      laju: '18 x/menit',
      suhu: '36.8 °C',
      diagnosa: const [
        'R10.4  Nyeri abdomen lainnya',
        'N23  Kolik renal tidak spesifik',
      ],
      tindakan: const [
        '88.76  USG Abdomen Upper-Lower',
        '87.61  BNO / Foto Polos Abdomen 3 Posisi',
      ],
      rencanaTerapi:
          'Pemeriksaan penunjang USG & BNO Abdomen, Asam Mefenamat 500mg 3x1 pc prn nyeri.',
      cpptData: CpptData(
        subjektif:
            'Nyeri perut bagian bawah sejak 2 hari, hilang timbul seperti diremas. BAK lancar sedikit pekat, BAB biasa.',
        objektif:
            'TD 120/80 mmHg, N 80x/m, RR 18x/m, Suhu 36.8°C. Nyeri tekan perut bawah kanan (+). Order penunjang USG & BNO Abdomen sedang diproses Radiologi.',
        asesmen: 'Suspek Kolik Renal / Apendisitis Akut dd/ Dispepsia.',
        plan:
            'Tunggu hasil ekspertise Radiologi (USG + BNO). Terapi simptomatik analgetik anti-spasmodik.',
      ),
      ttvData: TtvData(
        tekananDarah: '120/80',
        nadi: '80',
        lajuNafas: '18',
        suhu: '36.8',
        spo2: '99',
        beratBadan: '58',
        tinggiBadan: '158',
      ),
    ),

    // -----------------------------------------------------------------
    // 3. Tn. Agus Setiawan (p3) - Menunggu (waiting)
    // -----------------------------------------------------------------
    Patient(
      id: 'p3',
      name: 'Agus Setiawan',
      mrNumber: '0012347',
      nik: '3174091201640003',
      age: 60,
      gender: 'L',
      complaint: 'Kontrol hipertensi',
      scheduleTime: '09:00',
      status: PatientStatus.waiting,
      insurance: 'BPJS',
      noSep: '2026R00012347',
      keluhanUtama: 'Kontrol tensi rutin bulanan.',
      anamnesis: 'Pusing ringan sesekali di tengkuk, rutin minum amlodipine.',
      tekananDarah: '145/90 mmHg',
      nadi: '74 x/menit',
      laju: '18 x/menit',
      suhu: '36.4 °C',
      diagnosa: const ['I10  Hipertensi esensial (primer)'],
      rencanaTerapi: 'Lanjutkan amlodipine 10mg, kurangi asupan garam.',
    ),

    // -----------------------------------------------------------------
    // 4. Ny. Rina Marlina (p4) - Menunggu (waiting)
    // -----------------------------------------------------------------
    Patient(
      id: 'p4',
      name: 'Rina Marlina',
      mrNumber: '0012348',
      nik: '3201085503950004',
      age: 29,
      gender: 'P',
      complaint: 'Demam',
      scheduleTime: '09:30',
      status: PatientStatus.waiting,
      insurance: 'Umum',
      keluhanUtama: 'Demam tinggi naik turun 3 hari.',
      anamnesis: 'Disertai sakit kepala dan nyeri sendi, nafsu makan menurun.',
      tekananDarah: '110/70 mmHg',
      nadi: '88 x/menit',
      laju: '20 x/menit',
      suhu: '38.5 °C',
      diagnosa: const ['A90  Demam dengue'],
      rencanaTerapi:
          'Cek Darah Lengkap (DL + NS1), Paracetamol 500mg, rehidrasi.',
    ),

    // -----------------------------------------------------------------
    // 5. Tn. Dedi Kurniawan (p5) - Menunggu (waiting)
    // -----------------------------------------------------------------
    Patient(
      id: 'p5',
      name: 'Dedi Kurniawan',
      mrNumber: '0012349',
      nik: '3172031806740005',
      age: 50,
      gender: 'L',
      complaint: 'Nyeri dada',
      scheduleTime: '10:00',
      status: PatientStatus.waiting,
      insurance: 'BPJS',
      noSep: '2026R00012349',
      keluhanUtama: 'Nyeri dada kiri seperti tertimpa beban berat.',
      anamnesis: 'Nyeri timbul saat beraktivitas berat, reda dengan istirahat.',
      tekananDarah: '135/85 mmHg',
      nadi: '82 x/menit',
      laju: '22 x/menit',
      suhu: '36.6 °C',
      diagnosa: const ['I20.9  Angina pektoris, tidak spesifik'],
      rencanaTerapi: 'Rujuk EKG cito, ISDN 5mg sublingual jika nyeri.',
    ),

    // -----------------------------------------------------------------
    // 6. Ny. Maya Indah (p6) - Selesai (done) - GERD
    // -----------------------------------------------------------------
    Patient(
      id: 'p6',
      name: 'Maya Indah',
      mrNumber: '0012350',
      nik: '3173026011910006',
      age: 33,
      gender: 'P',
      complaint: 'Pemeriksaan asam lambung (GERD)',
      scheduleTime: '07:00',
      status: PatientStatus.done,
      insurance: 'BPJS',
      noSep: '2026R00012350',
      keluhanUtama:
          'Rasa terbakar di ulu hati (heartburn) dan sering bersendawa asam.',
      anamnesis:
          'Keluhan memberat saat berbaring setelah makan atau minum kopi. Mual (+), muntah (-), penurunan BB (-).',
      pemeriksaanFisik:
          'Abdomen: Nyeri tekan regio epigastrium (+), hepar/lien tidak teraba, bising usus normal.',
      tekananDarah: '115/75 mmHg',
      nadi: '76 x/menit',
      laju: '18 x/menit',
      suhu: '36.5 °C',
      diagnosa: const [
        'K21.9  Gastro-esophageal reflux disease without esophagitis',
        'K30  Dispepsia',
      ],
      tindakan: const [
        '89.03  Konsultasi dan evaluasi medis',
        '99.21  Injeksi/Edukasi terapi oral',
      ],
      rencanaTerapi:
          'Omeprazole 20mg 2x1 ac, Sukralfat sirup 3x1 C, edukasi pola hidup sehat.',
      cpptData: CpptData(
        subjektif:
            'Pasien mengeluh ulu hati panas terbakar (heartburn) sejak 1 minggu, asam lambung naik ke tenggorokan (refluks). Riwayat sering makan telat dan konsumsi kopi.',
        objektif:
            'TD 115/75 mmHg, Nadi 76x/m, RR 18x/m, Suhu 36.5°C, SpO2 99%. Nyeri tekan epigastrium (+), meteorismus (-).',
        asesmen:
            'Gastro-Esophageal Reflux Disease (GERD) + Dispepsia Fungsional.',
        plan:
            'Omeprazole 20mg 2x1 ac (sebelum makan), Sukralfat Sirup 3x1 sendok makan, Antasida tablet 3x1 prn. Edukasi: hindari kopi, pedas, jangan langsung tidur setelah makan.',
      ),
      ttvData: TtvData(
        tekananDarah: '115/75',
        nadi: '76',
        lajuNafas: '18',
        suhu: '36.5',
        spo2: '99',
        beratBadan: '54',
        tinggiBadan: '160',
      ),
      diagnosaTindakanData: DiagnosaTindakanData(
        diagnosaList: [
          'K21.9  Gastro-esophageal reflux disease without esophagitis',
          'K30  Dispepsia',
        ],
        tindakanList: [
          '89.03  Konsultasi dan evaluasi medis',
          '99.21  Injeksi/Edukasi terapi oral',
        ],
        rencanaTerapi:
            'Omeprazole 20mg 2x1 ac, Sukralfat Sirup 3x1 C, Antasida DOEN 3x1 ac prn.',
        catatanEdukasi:
            'Makan teratur porsi kecil tapi sering, hindari makanan asam dan pedas, beri jeda minimal 2 jam setelah makan sebelum tidur.',
      ),
      services: const [
        ServiceItem(
          id: 'svc-001',
          name: 'Konsultasi Dokter Spesialis Penyakit Dalam',
          code: 'KON-SPPD-001',
          standard: ServiceStandard.kris,
          price: 150000,
          category: 'Konsultasi',
        ),
        ServiceItem(
          id: 'svc-005',
          name: 'Injeksi Intravena / Intramuskular',
          code: 'TIN-INJ-001',
          standard: ServiceStandard.kris,
          price: 35000,
          category: 'Tindakan Medis',
        ),
        ServiceItem(
          id: 'svc-002',
          name: 'Pemeriksaan Fisik Lengkap Poliklinik',
          code: '89.7',
          standard: ServiceStandard.kris,
          price: 50000,
          category: 'Tindakan Medis',
        ),
      ],
    ),

    // -----------------------------------------------------------------
    // 7. Tn. Hendra Wijaya (p7) - Selesai (done) - Bronkitis & Rontgen
    // -----------------------------------------------------------------
    Patient(
      id: 'p7',
      name: 'Hendra Wijaya',
      mrNumber: '0012351',
      nik: '3175051409820007',
      age: 42,
      gender: 'L',
      complaint: 'Batuk berdahak > 2 minggu',
      scheduleTime: '07:15',
      status: PatientStatus.done,
      insurance: 'BPJS',
      noSep: '2026R00012351',
      keluhanUtama:
          'Batuk berdahak warna putih kekuningan > 2 minggu, dada terasa agak sesak.',
      anamnesis:
          'Batuk berdahak tidak kunjung sembuh, demam sumeng-sumeng pada malam hari, riwayat merokok 1 bungkus/hari. Sudah dilakukan Rontgen Thorax PA: Cor dbn, pulmo tidak tampak sarang spesifik/TB, kesan: Bronkitis akut.',
      pemeriksaanFisik:
          'Pulmo: suara napas vesikuler, terdapat ronkhi basah kasar di kedua lapang basal paru, wheezing (-).',
      tekananDarah: '120/80 mmHg',
      nadi: '80 x/menit',
      laju: '19 x/menit',
      suhu: '37.0 °C',
      diagnosa: const ['J40  Bronkitis tidak spesifik'],
      tindakan: const [
        '87.44  Rontgen Thorax PA Dewasa',
        '89.03  Evaluasi medis & konseling pernapasan',
      ],
      rencanaTerapi:
          'Ambroxol tab 30mg 3x1, Cefixime 200mg 2x1 pc, istirahat cukup.',
      cpptData: CpptData(
        subjektif:
            'Batuk berdahak lebih dari 2 minggu, dahak kental putih kekuningan. Riwayat perokok aktif 15 tahun. Demam ringan naik turun.',
        objektif:
            'TD 120/80 mmHg, Nadi 80x/m, RR 19x/m, Suhu 37.0°C, SpO2 98%. Auskultasi: Ronkhi basah kasar minimal di basal paru bilateral. Hasil Rontgen Thorax PA (RAD/2026/09/0009): Cor dan pulmo dalam batas normal, bronkovaskular marking meningkat.',
        asesmen: 'Bronkitis akut / tidak spesifik (J40).',
        plan:
            'Ambroxol 30mg 3x1 tab pc, Cefixime 200mg 2x1 tab pc (selama 5 hari), edukasi berhenti merokok dan perbanyak minum air hangat.',
      ),
      ttvData: TtvData(
        tekananDarah: '120/80',
        nadi: '80',
        lajuNafas: '19',
        suhu: '37.0',
        spo2: '98',
        beratBadan: '68',
        tinggiBadan: '172',
      ),
      diagnosaTindakanData: DiagnosaTindakanData(
        diagnosaList: ['J40  Bronkitis tidak spesifik'],
        tindakanList: [
          '87.44  Rontgen Thorax PA Dewasa',
          '89.03  Evaluasi medis & konseling pernapasan',
        ],
        rencanaTerapi:
            'Ambroxol 30mg 3x1 tab pc, Cefixime 200mg 2x1 tab pc, Paracetamol 500mg prn.',
        catatanEdukasi:
            'Berhenti merokok total, gunakan masker saat keluar rumah, perbanyak konsumsi air putih hangat.',
      ),
    ),

    // -----------------------------------------------------------------
    // 8. Ny. Dewi Lestari (p8) - Selesai (done) - Migrain & Vertigo
    // -----------------------------------------------------------------
    Patient(
      id: 'p8',
      name: 'Dewi Lestari',
      mrNumber: '0012352',
      nik: '3276014207880008',
      age: 36,
      gender: 'P',
      complaint: 'Migrain dan vertigo',
      scheduleTime: '07:30',
      status: PatientStatus.done,
      insurance: 'Umum',
      keluhanUtama:
          'Pusing berputar (vertigo) dan sakit kepala sebelah kiri berdenyut sejak kemarin.',
      anamnesis:
          'Sakit kepala berdenyut sebelah kiri, sensitif terhadap cahaya dan suara bising (fotofobia/fonofobia). Merasa melayang saat bangun tidur. Riwayat kurang tidur dan stres pekerjaan.',
      pemeriksaanFisik:
          'Pemeriksaan neurologis: Nystagmus (-), Romberg test stabil, reflek fisiologis (+/+), kaku kuduk (-).',
      tekananDarah: '110/70 mmHg',
      nadi: '75 x/menit',
      laju: '18 x/menit',
      suhu: '36.5 °C',
      diagnosa: const [
        'G43.9  Migrain tidak spesifik',
        'H81.1  Vertigo paroksismal benigna',
      ],
      tindakan: const ['89.03  Konsultasi dan asesmen neurologis dasar'],
      rencanaTerapi:
          'Betahistine Mesylate 6mg 3x1 pc, Flunarizine 5mg 1x1 malam.',
      cpptData: CpptData(
        subjektif:
            'Pusing kepala berdenyut sisi kiri disertai rasa melayang / berputar saat perubahan posisi kepala mendadak. Mual ringan tanpa muntah.',
        objektif:
            'TD 110/70 mmHg, Nadi 75x/m, RR 18x/m, Suhu 36.5°C, SpO2 99%. Status lokalis kranium: nyeri tekan temporal sinistra (+).',
        asesmen:
            'Migrain tanpa aura (G43.9) + Benign Paroxysmal Positional Vertigo ringan (H81.1).',
        plan:
            'Betahistine Mesylate 6mg 3x1 tab pc, Flunarizine 5mg 1x1 tab malam, Paracetamol 500mg prn pusing berat. Edukasi istirahat di ruang gelap dan hindari stres.',
      ),
      ttvData: TtvData(
        tekananDarah: '110/70',
        nadi: '75',
        lajuNafas: '18',
        suhu: '36.5',
        spo2: '99',
        beratBadan: '52',
        tinggiBadan: '158',
      ),
      diagnosaTindakanData: DiagnosaTindakanData(
        diagnosaList: [
          'G43.9  Migrain tidak spesifik',
          'H81.1  Vertigo paroksismal benigna',
        ],
        tindakanList: ['89.03  Konsultasi dan asesmen neurologis dasar'],
        rencanaTerapi:
            'Betahistine Mesylate 6mg 3x1 pc, Flunarizine 5mg 1x1 tab malam, Paracetamol 500mg prn.',
        catatanEdukasi:
            'Istirahat teratur minimal 7 jam/malam, hindari lampu yang terlalu silau, hindari gerakan kepala mendadak.',
      ),
    ),

    // -----------------------------------------------------------------
    // 9. Tn. Bambang Pamungkas (p9) - Selesai (done) - OA Genu & Rontgen
    // -----------------------------------------------------------------
    Patient(
      id: 'p9',
      name: 'Bambang Pamungkas',
      mrNumber: '0012353',
      nik: '3171092008700009',
      age: 54,
      gender: 'L',
      complaint: 'Nyeri sendi lutut bilateral',
      scheduleTime: '07:40',
      status: PatientStatus.done,
      insurance: 'BPJS',
      noSep: '2026R00012353',
      keluhanUtama:
          'Nyeri kedua lutut saat berjalan dan berdiri dari posisi duduk, lutut terasa kaku pagi hari.',
      anamnesis:
          'Keluhan nyeri lutut bilateral sudah 6 bulan, memberat 2 minggu ini terutama saat naik tangga. Krepitasi (+). Hasil Rontgen Genu Bilateral: Tampak penyempitan celah sendi medial genu bilateral grade 2 (Osteoartritis).',
      pemeriksaanFisik:
          'Genu bilateral: krepitasi (+/+), nyeri tekan kompartemen medial (+/+), edema ringan (-/-), ROM fleksi terbatas 110°.',
      tekananDarah: '130/80 mmHg',
      nadi: '76 x/menit',
      laju: '18 x/menit',
      suhu: '36.6 °C',
      diagnosa: const ['M17.0  Osteoartritis lutut primer bilateral'],
      tindakan: const [
        '88.27  Rontgen Ekstremitas Bawah (Genu Bilateral AP/Lat)',
        '93.39  Edukasi terapi fisik & rehabilitasi',
      ],
      rencanaTerapi:
          'Meloxicam 7.5mg 2x1 pc, Glucosamine, edukasi kurangi beban lutut.',
      cpptData: CpptData(
        subjektif:
            'Nyeri kedua lutut saat menumpu berat badan dan naik tangga. Kaku sendi pagi hari < 30 menit. Riwayat sering angkat beban berat.',
        objektif:
            'TD 130/80 mmHg, Nadi 76x/m, RR 18x/m, Suhu 36.6°C, IMT 27.2 (Overweight). Hasil Rontgen Genu (RAD/2026/09/0004): Penyempitan celah sendi medial genu dextra & sinistra grade 2, osteofit ringan.',
        asesmen: 'Osteoartritis Genu Primer Bilateral Grade 2 (M17.0).',
        plan:
            'Meloxicam 7.5mg 2x1 tab pc, Glucosamine 500mg 1x1 tab, Eperisone 50mg 2x1 pc. Rujuk fisioterapi rehabilitasi medik untuk penguatan otot quadriceps, edukasi penurunan berat badan.',
      ),
      ttvData: TtvData(
        tekananDarah: '130/80',
        nadi: '76',
        lajuNafas: '18',
        suhu: '36.6',
        spo2: '98',
        beratBadan: '78',
        tinggiBadan: '169',
      ),
      diagnosaTindakanData: DiagnosaTindakanData(
        diagnosaList: ['M17.0  Osteoartritis lutut primer bilateral'],
        tindakanList: [
          '88.27  Rontgen Ekstremitas Bawah (Genu Bilateral AP/Lat)',
          '93.39  Edukasi terapi fisik & rehabilitasi',
        ],
        rencanaTerapi:
            'Meloxicam 7.5mg 2x1 pc, Glucosamine 500mg 1x1 tab, rujukan fisioterapi.',
        catatanEdukasi:
            'Kurangi naik turun tangga, hindari jongkok lama, kompres hangat bila kaku, turunkan berat badan bertahap.',
      ),
    ),

    // -----------------------------------------------------------------
    // 10. Ny. Nurul Hidayah (p10) - Selesai (done) - Urtikaria Alergi
    // -----------------------------------------------------------------
    Patient(
      id: 'p10',
      name: 'Nurul Hidayah',
      mrNumber: '0012354',
      nik: '3204056703990010',
      age: 25,
      gender: 'P',
      complaint: 'Alergi makanan / urtikaria akut',
      scheduleTime: '07:45',
      status: PatientStatus.done,
      insurance: 'BPJS',
      noSep: '2026R00012354',
      keluhanUtama:
          'Bentol-bentol kemerahan dan gatal di seluruh tubuh setelah makan kepiting/seafood.',
      anamnesis:
          'Timbul bentol plakat eritematosa batas tegas sejak tadi malam setelah makan udang/kepiting. Sesak napas (-), bibir bengkak (-), suara serak (-).',
      pemeriksaanFisik:
          'Regio truncus & ekstremitas: tampak plak urtika eritematosa multipel, edema superficial (+).',
      tekananDarah: '118/78 mmHg',
      nadi: '82 x/menit',
      laju: '18 x/menit',
      suhu: '36.7 °C',
      diagnosa: const ['L50.0  Urtikaria alergi'],
      tindakan: const ['89.03  Konsultasi dan pemeriksaan dermatologi dasar'],
      rencanaTerapi: 'Cetirizine 10mg 1x1, Deksametason 0.5mg 3x1 pc.',
      cpptData: CpptData(
        subjektif:
            'Muncul bentol-bentol merah gatal di lengan, dada, dan punggung sekitar 3 jam setelah konsumsi seafood. Riwayat alergi udang sebelumnya.',
        objektif:
            'TD 118/78 mmHg, Nadi 82x/m, RR 18x/m, Suhu 36.7°C, SpO2 99%. Status dermatologi: Urtika eritematosa batas tegas, multipel, ukuran bervariasi.',
        asesmen: 'Urtikaria Akut / Alergi Makanan (L50.0).',
        plan:
            'Cetirizine 10mg 1x1 tab malam, Deksametason 0.5mg 3x1 tab pc (selama 3 hari). Edukasi hindari alergen seafood.',
      ),
      ttvData: TtvData(
        tekananDarah: '118/78',
        nadi: '82',
        lajuNafas: '18',
        suhu: '36.7',
        spo2: '99',
        beratBadan: '50',
        tinggiBadan: '158',
      ),
      diagnosaTindakanData: DiagnosaTindakanData(
        diagnosaList: ['L50.0  Urtikaria alergi'],
        tindakanList: ['89.03  Konsultasi dan pemeriksaan dermatologi dasar'],
        rencanaTerapi:
            'Cetirizine 10mg 1x1 malam, Deksametason 0.5mg 3x1 pc selama 3 hari.',
        catatanEdukasi:
            'Catat dan hindari makanan pemicu alergi (seafood), jangan menggaruk kulit berlebihan untuk mencegah infeksi sekunder.',
      ),
    ),

    // -----------------------------------------------------------------
    // 11. Tn. Ahmad Fauzi (p11) - Selesai (done) - Hiperkolesterolemia
    // -----------------------------------------------------------------
    Patient(
      id: 'p11',
      name: 'Ahmad Fauzi',
      mrNumber: '0012355',
      nik: '3174061502750011',
      age: 49,
      gender: 'L',
      complaint: 'Kontrol kolesterol dan dislipidemia',
      scheduleTime: '07:50',
      status: PatientStatus.done,
      insurance: 'BPJS',
      noSep: '2026R00012355',
      keluhanUtama:
          'Kontrol hasil laboratorium kolesterol, leher belakang terasa kaku.',
      anamnesis:
          'Kontrol rutin hasil profil lipid: Kolesterol Total 260 mg/dL, LDL 175 mg/dL, Trigliserida 190 mg/dL. Keluhan tengkuk kaku terutama setelah makan berlemak.',
      pemeriksaanFisik:
          'Kepala/leher: spasme otot tengkuk ringan (+). Cor & Pulmo dalam batas normal.',
      tekananDarah: '125/80 mmHg',
      nadi: '78 x/menit',
      laju: '18 x/menit',
      suhu: '36.4 °C',
      diagnosa: const ['E78.0  Hiperkolesterolemia murni'],
      tindakan: const [
        '90.59  Pemeriksaan Profil Lipid Darah',
        '89.03  Konseling diet dan gaya hidup',
      ],
      rencanaTerapi: 'Atorvastatin 20mg 1x1 malam, diet rendah lemak jenuh.',
      cpptData: CpptData(
        subjektif:
            'Pasien kontrol berkala kolesterol tinggi. Tengkuk sering terasa tegang dan kaku terutama sore hari.',
        objektif:
            'TD 125/80 mmHg, Nadi 78x/m, RR 18x/m, Suhu 36.4°C. Profil Lipid: Kolesterol Total 260 mg/dL, LDL 175 mg/dL.',
        asesmen: 'Hiperkolesterolemia murni / Dislipidemia (E78.0).',
        plan:
            'Atorvastatin 20mg 1x1 malam. Diet rendah lemak jenuh & kolesterol, olahraga kardio rutin.',
      ),
      ttvData: TtvData(
        tekananDarah: '125/80',
        nadi: '78',
        lajuNafas: '18',
        suhu: '36.4',
        spo2: '98',
        beratBadan: '70',
        tinggiBadan: '167',
      ),
      diagnosaTindakanData: DiagnosaTindakanData(
        diagnosaList: ['E78.0  Hiperkolesterolemia murni'],
        tindakanList: [
          '90.59  Pemeriksaan Profil Lipid Darah',
          '89.03  Konseling diet dan gaya hidup',
        ],
        rencanaTerapi: 'Atorvastatin 20mg 1x1 malam, diet rendah lemak jenuh.',
        catatanEdukasi:
            'Batasi makanan berminyak, jeroan, dan santan. Lakukan olahraga aerobik 150 menit per minggu.',
      ),
    ),

    // -----------------------------------------------------------------
    // 12. Ny. Sri Wahyuni (p12) - Selesai (done) - Low Back Pain
    // -----------------------------------------------------------------
    Patient(
      id: 'p12',
      name: 'Sri Wahyuni',
      mrNumber: '0012356',
      nik: '3275045109680012',
      age: 56,
      gender: 'P',
      complaint: 'Nyeri punggung bawah (LBP)',
      scheduleTime: '07:55',
      status: PatientStatus.done,
      insurance: 'BPJS',
      noSep: '2026R00012356',
      keluhanUtama: 'Nyeri pinggang bawah menjalar ke bokong saat duduk lama.',
      anamnesis:
          'Nyeri pinggang sejak 1 bulan, memberat saat duduk lama di kantor. Kebas pada kaki (-), gangguan BAK/BAB (-).',
      pemeriksaanFisik:
          'Spasme otot paravertebral lumbal (+), Laseque test (-), Patrick/Kontra-Patrick (-).',
      tekananDarah: '128/82 mmHg',
      nadi: '76 x/menit',
      laju: '18 x/menit',
      suhu: '36.5 °C',
      diagnosa: const ['M54.5  Low back pain'],
      tindakan: const ['89.03  Konsultasi dan evaluasi muskuloskeletal'],
      rencanaTerapi:
          'Eperisone HCl 50mg 3x1 pc, Natrium Diklofenak 50mg 2x1 pc.',
      cpptData: CpptData(
        subjektif:
            'Nyeri punggung bawah mekanik hilang timbul. Pekerjaan banyak duduk di meja kantor.',
        objektif:
            'TD 128/82 mmHg, Nadi 76x/m, RR 18x/m, Suhu 36.5°C. Spasme otot paravertebral lumbal (+), Laseque test (-), Patrick/Kontra-Patrick (-).',
        asesmen: 'Low Back Pain / Nyeri Punggung Bawah Miogenik (M54.5).',
        plan:
            'Eperisone HCl 50mg 3x1 tab pc, Natrium Diklofenak 50mg 2x1 tab pc (prn nyeri). Edukasi posisi duduk ergonomis dan stretching punggung.',
      ),
      ttvData: TtvData(
        tekananDarah: '128/82',
        nadi: '76',
        lajuNafas: '18',
        suhu: '36.5',
        spo2: '99',
        beratBadan: '62',
        tinggiBadan: '155',
      ),
      diagnosaTindakanData: DiagnosaTindakanData(
        diagnosaList: ['M54.5  Low back pain'],
        tindakanList: ['89.03  Konsultasi dan evaluasi muskuloskeletal'],
        rencanaTerapi:
            'Eperisone HCl 50mg 3x1 pc, Natrium Diklofenak 50mg 2x1 pc.',
        catatanEdukasi:
            'Gunakan kursi ergonomis dengan penopang pinggang, berdiri dan lakukan peregangan setiap 1 jam duduk.',
      ),
    ),
  ];
}
