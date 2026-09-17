import 'package:flutter/material.dart';
import '../models/patient.dart';
import 'dummy_patients.dart';

class AppNotification {
  final String id;
  final String title;
  final String desc;
  final String time;
  final IconData icon;
  final Color color;
  final Patient? patient;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.desc,
    required this.time,
    required this.icon,
    required this.color,
    this.patient,
    this.isRead = false,
  });
}

class DummyNotifications {
  // Static list so modifications persist during app session
  static final List<AppNotification> list = [
    AppNotification(
      id: 'notif_1',
      title: 'Hasil Rontgen Siap Dibaca',
      desc:
          'Hasil rontgen Thorax AP/PA & BNO Tn. Budi Santoso (RM 0012345) telah selesai diekspertise oleh Sp.Rad (Cor CTR 54%).',
      time: '5 menit lalu',
      icon: Icons.biotech_rounded,
      color: const Color(0xFF059669),
      patient: DummyPatients.todayList[0], // Budi Santoso
      isRead: false,
    ),
    AppNotification(
      id: 'notif_2',
      title: 'Pasien Masuk Antrean Radiologi',
      desc:
          'Order USG Abdomen & Foto Polos BNO Ny. Siti Aminah (RM 0012346) telah diterima oleh Instalasi Radiologi.',
      time: '12 menit lalu',
      icon: Icons.hourglass_top_rounded,
      color: const Color(0xFF9333EA),
      patient: DummyPatients.todayList[1], // Siti Aminah
      isRead: false,
    ),
    AppNotification(
      id: 'notif_3',
      title: 'Resep Obat Sedang Dirack',
      desc:
          'E-resep GERD Ny. Maya Indah (RM 0012350) sedang disiapkan dan diracik di Instalasi Farmasi.',
      time: '45 menit lalu',
      icon: Icons.local_pharmacy_rounded,
      color: const Color(0xFFD97706),
      patient: DummyPatients.todayList[5], // Maya Indah
      isRead: false,
    ),
    AppNotification(
      id: 'notif_4',
      title: 'Pasien Siap Dipanggil ke Poli',
      desc:
          'Tn. Agus Setiawan (RM 0012347) telah menyelesaikan triase perawat dan menunggu di ruang tunggu.',
      time: '1 jam lalu',
      icon: Icons.person_add_alt_1_outlined,
      color: const Color(0xFF2563EB),
      patient: DummyPatients.todayList[2], // Agus Setiawan
      isRead: true,
    ),
    AppNotification(
      id: 'notif_5',
      title: 'Verifikasi Billing Kasir Berhasil',
      desc:
          'Rincian tindakan dan obat Ny. Dewi Lestari (RM 0012352) telah lunas di Kasir Rawat Jalan.',
      time: '2 jam lalu',
      icon: Icons.payments_rounded,
      color: const Color(0xFF0284C7),
      patient: DummyPatients.todayList[7], // Dewi Lestari
      isRead: true,
    ),
    AppNotification(
      id: 'notif_6',
      title: 'Verifikasi SEP BPJS Berhasil',
      desc:
          'No. SEP 2026R00012351 Tn. Hendra Wijaya telah disetujui oleh sistem BPJS V-Claim.',
      time: '3 jam lalu',
      icon: Icons.verified_user_outlined,
      color: const Color(0xFF00897B),
      patient: DummyPatients.todayList[6], // Hendra Wijaya
      isRead: true,
    ),
  ];

  static int get unreadCount => list.where((n) => !n.isRead).length;

  static void markAllAsRead() {
    for (var n in list) {
      n.isRead = true;
    }
  }

  static void resetSample() {
    list.clear();
    list.addAll([
      AppNotification(
        id: 'notif_1',
        title: 'Hasil Rontgen Siap Dibaca',
        desc:
            'Hasil rontgen Thorax AP/PA & BNO Tn. Budi Santoso (RM 0012345) telah selesai diekspertise oleh Sp.Rad (Cor CTR 54%).',
        time: '5 menit lalu',
        icon: Icons.biotech_rounded,
        color: const Color(0xFF059669),
        patient: DummyPatients.todayList[0],
        isRead: false,
      ),
      AppNotification(
        id: 'notif_2',
        title: 'Pasien Masuk Antrean Radiologi',
        desc:
            'Order USG Abdomen & Foto Polos BNO Ny. Siti Aminah (RM 0012346) telah diterima oleh Instalasi Radiologi.',
        time: '12 menit lalu',
        icon: Icons.hourglass_top_rounded,
        color: const Color(0xFF9333EA),
        patient: DummyPatients.todayList[1],
        isRead: false,
      ),
      AppNotification(
        id: 'notif_3',
        title: 'Resep Obat Sedang Dirack',
        desc:
            'E-resep GERD Ny. Maya Indah (RM 0012350) sedang disiapkan dan diracik di Instalasi Farmasi.',
        time: '45 menit lalu',
        icon: Icons.local_pharmacy_rounded,
        color: const Color(0xFFD97706),
        patient: DummyPatients.todayList[5],
        isRead: false,
      ),
      AppNotification(
        id: 'notif_4',
        title: 'Pasien Siap Dipanggil ke Poli',
        desc:
            'Tn. Agus Setiawan (RM 0012347) telah menyelesaikan triase perawat dan menunggu di ruang tunggu.',
        time: '1 jam lalu',
        icon: Icons.person_add_alt_1_outlined,
        color: const Color(0xFF2563EB),
        patient: DummyPatients.todayList[2],
        isRead: true,
      ),
      AppNotification(
        id: 'notif_5',
        title: 'Verifikasi Billing Kasir Berhasil',
        desc:
            'Rincian tindakan dan obat Ny. Dewi Lestari (RM 0012352) telah lunas di Kasir Rawat Jalan.',
        time: '2 jam lalu',
        icon: Icons.payments_rounded,
        color: const Color(0xFF0284C7),
        patient: DummyPatients.todayList[7],
        isRead: true,
      ),
      AppNotification(
        id: 'notif_6',
        title: 'Verifikasi SEP BPJS Berhasil',
        desc:
            'No. SEP 2026R00012351 Tn. Hendra Wijaya telah disetujui oleh sistem BPJS V-Claim.',
        time: '3 jam lalu',
        icon: Icons.verified_user_outlined,
        color: const Color(0xFF00897B),
        patient: DummyPatients.todayList[6],
        isRead: true,
      ),
    ]);
  }
}
