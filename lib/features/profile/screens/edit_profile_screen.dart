import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controller Form Profil
  late TextEditingController _nameController;
  late TextEditingController _sipController;
  late TextEditingController _strController;
  late TextEditingController _specialtyController;
  late TextEditingController _hospitalController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  // State Foto Profil (Bisa diganti dengan preset avatar atau custom)
  IconData? _selectedAvatarIcon;
  String _avatarImagePath = 'assets/images/doctor_avatar.jpg';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'dr. Andi Pratama, Sp.PD');
    _sipController = TextEditingController(text: '446.1/1234/SIP.D-II/2023');
    _strController = TextEditingController(text: '31.1.1.100.2.19.123456');
    _specialtyController = TextEditingController(text: 'Spesialis Penyakit Dalam (Internis)');
    _hospitalController = TextEditingController(text: 'RSUD Dr. H. Abdul Moeloek');
    _phoneController = TextEditingController(text: '0812-3456-7890');
    _emailController = TextEditingController(text: 'dr.andi.pratama@rsud.go.id');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sipController.dispose();
    _strController.dispose();
    _specialtyController.dispose();
    _hospitalController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Modal Pilihan Ganti Foto Profil
  void _showChangePhotoModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'Ganti Foto Profil',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 14),

            // Pilihan 1: Kamera
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.camera_alt_rounded, color: Color(0xFF0284C7)),
              ),
              title: const Text('Ambil Foto dari Kamera', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Membuka Kamera...'),
                    backgroundColor: Color(0xFF00897B),
                  ),
                );
              },
            ),

            // Pilihan 2: Galeri
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.photo_library_rounded, color: Color(0xFF9333EA)),
              ),
              title: const Text('Pilih dari Galeri HP', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Membuka Galeri Foto...'),
                    backgroundColor: Color(0xFF00897B),
                  ),
                );
              },
            ),

            // Pilihan 3: Pilih Karakter Avatar Siap Pakai
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.face_retouching_natural_rounded, color: Color(0xFF00897B)),
              ),
              title: const Text('Pilih Karakter Avatar Dokter', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
              onTap: () {
                Navigator.pop(ctx);
                _showAvatarPicker();
              },
            ),

            // Pilihan 4: Hapus Foto / Gunakan Icon Default
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE11D48)),
              ),
              title: const Text('Gunakan Ikon Default', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5, color: Color(0xFFE11D48))),
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  _selectedAvatarIcon = Icons.person;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Foto profil di-reset ke ikon default')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Dialog Pemilihan Avatar Bawaan
  void _showAvatarPicker() {
    final avatars = [
      {'icon': Icons.medical_services_rounded, 'name': 'Dokter 1'},
      {'icon': Icons.health_and_safety_rounded, 'name': 'Dokter 2'},
      {'icon': Icons.account_circle_rounded, 'name': 'Dokter 3'},
      {'icon': Icons.support_agent_rounded, 'name': 'Dokter 4'},
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Pilih Karakter Avatar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: avatars.map((av) {
            final icon = av['icon'] as IconData;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedAvatarIcon = icon;
                });
                Navigator.pop(ctx);
              },
              child: CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFFE0F2F1),
                child: Icon(icon, color: const Color(0xFF00897B), size: 28),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail & Ubah Profil',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ==========================================
            // FOTO PROFIL DOKTER DENGAN TOMBOL GANTI
            // ==========================================
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: _selectedAvatarIcon != null
                          ? Container(
                              width: 96,
                              height: 96,
                              color: const Color(0xFFE0F2F1),
                              child: Icon(
                                _selectedAvatarIcon,
                                color: const Color(0xFF00897B),
                                size: 52,
                              ),
                            )
                          : Image.asset(
                              _avatarImagePath,
                              width: 96,
                              height: 96,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 96,
                                height: 96,
                                color: const Color(0xFFE0F2F1),
                                child: const Icon(
                                  Icons.person,
                                  color: Color(0xFF00897B),
                                  size: 52,
                                ),
                              ),
                            ),
                    ),
                  ),
                  // Tombol Kamera Mini di Pojok Kanan Bawah
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: _showChangePhotoModal,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00897B),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Text Tombol Ganti Foto
            GestureDetector(
              onTap: _showChangePhotoModal,
              child: const Text(
                'Ganti Foto Profil',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF00897B),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // FORM INFORMASI PROFIL DOKTER
            // ==========================================
            _buildSectionHeader('Data Pribadi & Kepegawaian'),
            const SizedBox(height: 10),
            _buildInputField('Nama Lengkap & Gelar', _nameController, Icons.person_outline_rounded),
            const SizedBox(height: 12),
            _buildInputField('Nomor SIP (Surat Izin Praktik)', _sipController, Icons.badge_outlined),
            const SizedBox(height: 12),
            _buildInputField('Nomor STR', _strController, Icons.verified_user_outlined),
            const SizedBox(height: 20),

            _buildSectionHeader('Spesialisasi & Unit Kerja'),
            const SizedBox(height: 10),
            _buildInputField('Spesialisasi / Poliklinik', _specialtyController, Icons.medical_information_outlined),
            const SizedBox(height: 12),
            _buildInputField('Rumah Sakit / Faskes', _hospitalController, Icons.local_hospital_outlined),
            const SizedBox(height: 20),

            _buildSectionHeader('Kontak & Komunikasi'),
            const SizedBox(height: 10),
            _buildInputField('Nomor WhatsApp / HP', _phoneController, Icons.phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            _buildInputField('Alamat Email', _emailController, Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 30),

            // Tombol Simpan Perubahan
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Perubahan profil berhasil disimpan!'),
                      backgroundColor: Color(0xFF00897B),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check_rounded, size: 20),
                label: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00897B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 12.5,
            color: Color(0xFF64748B),
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF00897B), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}