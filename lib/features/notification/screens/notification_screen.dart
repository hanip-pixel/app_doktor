import 'package:flutter/material.dart';
import '../../../data/dummy/dummy_notifications.dart';
import '../../patient/screens/patient_detail_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int get _unreadCount => DummyNotifications.unreadCount;

  void _markAllAsRead() {
    if (_unreadCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua notifikasi sudah dibaca.'),
          duration: Duration(seconds: 1),
          backgroundColor: Color(0xFF00897B),
        ),
      );
      return;
    }

    setState(() {
      DummyNotifications.markAllAsRead();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua notifikasi ditandai sebagai sudah dibaca.'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF00897B),
      ),
    );
  }

  void _deleteAllNotifications() {
    if (DummyNotifications.list.isEmpty) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_sweep_rounded, color: Color(0xFFE11D48), size: 26),
            SizedBox(width: 8),
            Text(
              'Hapus Semua Notifikasi?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus seluruh notifikasi? Tindakan ini dapat diurungkan setelahnya.',
          style: TextStyle(fontSize: 13.5, color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              final backupList = List<AppNotification>.from(DummyNotifications.list);
              setState(() {
                DummyNotifications.list.clear();
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Seluruh notifikasi berhasil dihapus.'),
                  duration: const Duration(seconds: 4),
                  backgroundColor: const Color(0xFF1E293B),
                  action: SnackBarAction(
                    label: 'URUNGKAN',
                    textColor: const Color(0xFF2DD4BF),
                    onPressed: () {
                      setState(() {
                        DummyNotifications.list.addAll(backupList);
                      });
                    },
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE11D48),
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus Semua'),
          ),
        ],
      ),
    );
  }

  void _deleteSingleNotification(int index, AppNotification item) {
    setState(() {
      DummyNotifications.list.removeAt(index);
    });

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notifikasi "${item.title}" dihapus.'),
        duration: const Duration(seconds: 4),
        backgroundColor: const Color(0xFF1E293B),
        action: SnackBarAction(
          label: 'URUNGKAN',
          textColor: const Color(0xFF2DD4BF),
          onPressed: () {
            setState(() {
              DummyNotifications.list.insert(index, item);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unread = _unreadCount;
    final notifications = DummyNotifications.list;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 16, 6),
              child: Row(
                children: [
                  if (Navigator.of(context).canPop())
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF0F172A),
                        size: 24,
                      ),
                      onPressed: () => Navigator.pop(context),
                    )
                  else
                    const SizedBox(width: 8),
                  const Text(
                    'Notifikasi',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (unread > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00897B),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$unread Baru',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Action Buttons Bar (Baca Semua & Hapus Semua)
            if (notifications.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                child: Row(
                  children: [
                    // Button Tandai Baca Semua
                    InkWell(
                      onTap: _markAllAsRead,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F6FB),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFE2EEF8),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.done_all_rounded,
                              size: 16,
                              color: Color(0xFF00897B),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Baca Semuanya',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF00897B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),

                    // Button Hapus Semua
                    InkWell(
                      onTap: _deleteAllNotifications,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1F2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFFFE4E6),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete_sweep_rounded,
                              size: 16,
                              color: Color(0xFFE11D48),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Hapus Semua',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFE11D48),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Notifications List / Empty State
            Expanded(
              child: notifications.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                      itemCount: notifications.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = notifications[index];
                        return _buildDismissibleItem(item, index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDismissibleItem(AppNotification item, int index) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFE11D48),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Hapus',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13.5,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        _deleteSingleNotification(index, item);
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              item.isRead = true;
            });
            if (item.patient != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PatientDetailScreen(patient: item.patient!),
                ),
              ).then((_) {
                if (mounted) setState(() {});
              });
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              // Pembedaan warna blok: belum dibaca vs sudah dibaca
              color: item.isRead
                  ? const Color(0xFFF8FAFC)
                  : const Color(0xFFE6F7F5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: item.isRead
                    ? const Color(0xFFE2E8F0)
                    : const Color(0xFF99F6E4),
                width: item.isRead ? 1.0 : 1.3,
              ),
              boxShadow: item.isRead
                  ? []
                  : [
                      BoxShadow(
                        color: const Color(0xFF00897B).withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Avatar
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: item.isRead
                        ? item.color.withValues(alpha: 0.08)
                        : item.color.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.isRead
                        ? item.color.withValues(alpha: 0.7)
                        : item.color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 14,
                                // Bold jika belum dibaca, lebih tipis jika sudah dibaca
                                fontWeight: item.isRead
                                    ? FontWeight.w600
                                    : FontWeight.w800,
                                color: item.isRead
                                    ? const Color(0xFF334155)
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          if (!item.isRead) ...[
                            const SizedBox(width: 6),
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(top: 4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF00897B),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.desc,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: item.isRead
                              ? const Color(0xFF64748B)
                              : const Color(0xFF334155),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            item.time,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight:
                                  item.isRead ? FontWeight.w400 : FontWeight.w600,
                              color: item.isRead
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF00897B),
                            ),
                          ),
                          if (item.patient != null) ...[
                            const SizedBox(width: 8),
                            const Text(
                              '•',
                              style: TextStyle(
                                  color: Color(0xFFCBD5E1), fontSize: 12),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Klik untuk buka EMR',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF00897B),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F6FB),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_off_outlined,
                size: 42,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tidak Ada Notifikasi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Seluruh notifikasi telah dihapus atau Anda sudah membaca semua pemberitahuan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: Color(0xFF64748B),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  DummyNotifications.resetSample();
                });
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Muat Ulang Contoh Notifikasi'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF00897B),
                side: const BorderSide(color: Color(0xFF00897B)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
