import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracedev/controller/users_controller.dart';
import 'package:tracedev/view/edit_mandor.dart';
import 'package:tracedev/view/tambah_mandor.dart';
import 'package:tracedev/widget/show_snackbar.dart';

class AkunMandor extends StatefulWidget {
  const AkunMandor({super.key});

  @override
  State<AkunMandor> createState() => _AkunMandorState();
}

class _AkunMandorState extends State<AkunMandor> {
  final _userController = UsersController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<UsersController>(context, listen: false).getAllMandors(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final widthApp = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Akun Mandor',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(36, 158, 192, 1),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        width: widthApp,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[50]!, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(134, 182, 246, 1),
                      Color.fromRGBO(99, 162, 231, 1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(134, 182, 246, 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.pushNamed(context, TambahMandor.routeName);
                    await Provider.of<UsersController>(
                      context,
                      listen: false,
                    ).getAllMandors();
                  },
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  label: const Text(
                    'Tambah Akun Mandor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(36, 158, 192, 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.group,
                      color: Color.fromRGBO(36, 158, 192, 1),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Daftar Akun Mandor',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: Color.fromRGBO(51, 51, 51, 1),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Consumer<UsersController>(
                  builder: (context, controller, child) {
                    if (controller.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (controller.errorMessage != null) {
                      return Center(child: Text(controller.errorMessage!));
                    } else if (controller.users.isEmpty) {
                      return const Center(child: Text('Tidak ada akun mandor'));
                    }
                    return ListView.builder(
                      itemCount: controller.users.length,
                      itemBuilder: (context, index) {
                        final user = controller.users[index];
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300 + (index * 50)),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Card(
                            elevation: 4,
                            shadowColor: Colors.grey.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.white, Colors.grey[50]!],
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 64,
                                          height: 64,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Center(
                                              child: Image.network(
                                                user.foto ?? '',
                                                width: 64,
                                                height: 64,
                                                fit: BoxFit.cover,
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  return Container(
                                                    color: Colors.grey[100],
                                                    child: Icon(
                                                      Icons.person,
                                                      color: Colors.grey[400],
                                                      size: 32,
                                                    ),
                                                  );
                                                },
                                                loadingBuilder: (
                                                  context,
                                                  child,
                                                  loadingProgress,
                                                ) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Container(
                                                    color: Colors.grey[100],
                                                    child: Center(
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                              Color
                                                            >(Colors.blue),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 20),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user.nama,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Color.fromRGBO(
                                                    51,
                                                    51,
                                                    51,
                                                    1,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              _buildDetailRow(
                                                Icons.location_on,
                                                user.alamat,
                                              ),
                                              const SizedBox(height: 8),
                                              _buildDetailRow(
                                                Icons.email,
                                                user.email,
                                              ),
                                              const SizedBox(height: 8),
                                              _buildDetailRow(
                                                Icons.phone,
                                                user.noHp,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    height: 1,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.grey[300]!,
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                user.isActive
                                                    ? Colors.green.withOpacity(
                                                      0.1,
                                                    )
                                                    : Colors.red.withOpacity(
                                                      0.1,
                                                    ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              color:
                                                  user.isActive
                                                      ? Colors.green
                                                          .withOpacity(0.3)
                                                      : Colors.red.withOpacity(
                                                        0.3,
                                                      ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  color:
                                                      user.isActive
                                                          ? Colors.green
                                                          : Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                user.isActive
                                                    ? 'Aktif'
                                                    : 'Nonaktif',
                                                style: TextStyle(
                                                  color:
                                                      user.isActive
                                                          ? Colors.green
                                                          : Colors.red,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const Spacer(),

                                        // Tombol aksi dengan design yang lebih modern
                                        Row(
                                          children: [
                                            _buildActionButton(
                                              icon: Icons.edit,
                                              color: Colors.orange,
                                              label: 'Edit',
                                              onPressed: () async {
                                                await Navigator.push(context, MaterialPageRoute(builder: (context) => EditMandor(userId: user.userId!),));
                                                await Provider.of<UsersController>(context, listen: false).getAllMandors();
                                              },
                                            ),
                                            SizedBox(width: 8),
                                            _buildActionButton(
                                              icon:
                                                  user.isActive
                                                      ? Icons.lock
                                                      : Icons.check_box_rounded,
                                              color:
                                                  user.isActive
                                                      ? const Color.fromRGBO(
                                                        239,
                                                        68,
                                                        68,
                                                        1,
                                                      )
                                                      : Colors.green,
                                              label:
                                                  user.isActive
                                                      ? 'Nonaktifkan'
                                                      : 'Aktifkan',
                                              onPressed: () {
                                                _showDeleteDialog(
                                                  context,
                                                  index,
                                                  user.userId!,
                                                  user.isActive,
                                                  user.nama,
                                                  user.foto ?? '',
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: const Color.fromRGBO(36, 158, 192, 1),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color.fromRGBO(75, 85, 99, 1),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: Colors.white,),
        label: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    int index,
    int id,
    bool status,
    String nama,
    String? foto,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            titlePadding: EdgeInsets.zero,
            title: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    status
                        ? Color.fromRGBO(239, 68, 68, 1)
                        : Color.fromRGBO(36, 192, 72, 1),
                    status
                        ? Color.fromRGBO(220, 38, 38, 1)
                        : Color.fromRGBO(36, 158, 192, 1),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.warning_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    status
                        ? 'Konfirmasi Nonaktifkan Akun'
                        : 'Konfirmasi Aktifkan Akun',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        foto!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.person,
                              size: 100,
                              color: Colors.grey,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    status
                        ? 'Apakah Anda yakin ingin menonaktifkan akun "$nama"?'
                        : 'Apakah Anda yakin ingin mengaktifkan akun "$nama"?',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tindakan ini tidak dapat dibatalkan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Batal',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: status ? const Color.fromRGBO(239, 68, 68, 1) : const Color.fromRGBO(36, 192, 72, 1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  status ? 'Nonaktifkan' : 'Aktifkan',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                onPressed: () async {
                  await _userController.toggleMandorStatus(id);
                  await Provider.of<UsersController>(
                    context,
                    listen: false,
                  ).getAllMandors();
                  Navigator.pop(context);
                  ShowSnackbar.show(
                    context,
                    status ? 'Akun "$nama" berhasil dinonaktifkan!' : 'Akun "$nama" berhasil diaktifkan!',
                  );
                },
              ),
            ],
          ),
    );
  }
}
