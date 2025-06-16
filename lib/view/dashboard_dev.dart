import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:tracedev/controller/project_controller.dart';
import 'package:tracedev/view/edit_proyek.dart';
import 'package:tracedev/view/tambah_projek.dart';
import 'package:tracedev/view/tugaskan_mandor.dart';
import 'package:tracedev/widget/detail_proyek.dart';
import 'package:intl/intl.dart';

class DashboardDev extends StatefulWidget {
  const DashboardDev({super.key});

  @override
  State<DashboardDev> createState() => _DashboardDevState();
}

class _DashboardDevState extends State<DashboardDev> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<ProjectController>(
            context,
            listen: false,
          ).getAllProjects(),
    );
  }

  Future<String> getCityFromStringCoords(String koordinat) async {
    try {
      final parts = koordinat.split(',');
      final lat = double.parse(parts[0].trim());
      final lng = double.parse(parts[1].trim());

      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return place.locality ??
            place.subAdministrativeArea ??
            "Tidak diketahui";
      } else {
        return "Tidak ditemukan";
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  @override
  Widget build(BuildContext context) {
    String formatTanggal(DateTime date) {
      return DateFormat('yyyy-MM-dd').format(date); // contoh: 2025-06-02
    }

    final widthApp = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Manajemen Proyek',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Color.fromRGBO(36, 158, 192, 1),
      ),
      body: Container(
        width: widthApp,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16),
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
                    await Navigator.pushNamed(context, TambahProjek.routeName);
                    await Provider.of<ProjectController>(
                      context,
                      listen: false,
                    ).getAllProjects();
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
                    'Tambah Proyek',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(36, 158, 192, 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.construction,
                        color: Color.fromRGBO(36, 158, 192, 1),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Proyek yang sedang berjalan',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: Consumer<ProjectController>(
                  builder: (context, projectController, child) {
                    if (projectController.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (projectController.projects.isEmpty) {
                      return const Center(
                        child: Text('Tidak ada proyek yang sedang berjalan.'),
                      );
                    } else if (projectController.errorMessage != null) {
                      return Center(
                        child: Text(projectController.errorMessage!),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: projectController.projects.length,
                        itemBuilder: (context, index) {
                          final project = projectController.projects[index];
                          return GestureDetector(
                            onTap: () async {
                              final kecamatan = await getCityFromStringCoords(
                                project.lokasi,
                              );
                              showDialog(
                                context: context,
                                builder:
                                    (_) => DetailProyek(
                                      id: project.projectId!,
                                      title: project.namaProject,
                                      lokasi: kecamatan,
                                      status: project.status,
                                      deadline: formatTanggal(project.deadline),
                                      imageUrl: project.foto ?? '',
                                      jumlahMandor: "4",
                                    ),
                              );
                            },
                            child: Card(
                              elevation: 3,
                              shadowColor: Colors.grey.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header dengan gambar dan status
                                    Row(
                                      children: [
                                        // Gambar proyek
                                        Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image.network(
                                              project.foto ??
                                                  '',
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return Container(
                                                  color: Colors.grey[100],
                                                  child: Icon(
                                                    Icons.home_work,
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

                                        SizedBox(width: 16),

                                        // Informasi proyek
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Nama proyek
                                              Text(
                                                project.namaProject,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[800],
                                                ),
                                              ),

                                              SizedBox(height: 4),

                                              // Lokasi
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on,
                                                    size: 16,
                                                    color: Colors.grey[600],
                                                  ),
                                                  SizedBox(width: 4),
                                                  FutureBuilder<String>(
                                                    future:
                                                        getCityFromStringCoords(
                                                          project.lokasi,
                                                        ),
                                                    builder: (
                                                      context,
                                                      snapshot,
                                                    ) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return Text(
                                                          "Memuat...",
                                                        );
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Text("Gagal");
                                                      } else {
                                                        return Text(
                                                          snapshot.data ?? "-",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors
                                                                    .grey[600],
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),

                                              SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  // Status badge
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      border: Border.all(
                                                        color: Colors.green
                                                            .withOpacity(0.3),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      project.status,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Colors.green[700],
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),

                                                  SizedBox(width: 12),

                                                  // Deadline
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.orange
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.schedule,
                                                          size: 12,
                                                          color:
                                                              Colors
                                                                  .orange[700],
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          formatTanggal(
                                                            project.deadline,
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors
                                                                    .orange[700],
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Buttons Edit dan Delete
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.amber.withOpacity(
                                                  0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: IconButton(
                                                onPressed: () async {
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (
                                                            context,
                                                          ) => EditProyek(
                                                            idProject:
                                                                project.projectId!,
                                                          ),
                                                    ),
                                                  );
                                                  await Provider.of<
                                                    ProjectController
                                                  >(
                                                    context,
                                                    listen: false,
                                                  ).getAllProjects();
                                                },
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: Colors.amber[700],
                                                  size: 20,
                                                ),
                                                padding: EdgeInsets.all(8),
                                                constraints: BoxConstraints(
                                                  minWidth: 40,
                                                  minHeight: 40,
                                                ),
                                              ),
                                            ),

                                            SizedBox(width: 8),

                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red.withOpacity(
                                                  0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  // Aksi delete dengan konfirmasi
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red[700],
                                                  size: 20,
                                                ),
                                                padding: EdgeInsets.all(8),
                                                constraints: BoxConstraints(
                                                  minWidth: 40,
                                                  minHeight: 40,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                  36,
                                                  158,
                                                  192,
                                                  1,
                                                ).withAlpha(100),
                                                blurRadius: 6,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromRGBO(
                                                36,
                                                158,
                                                192,
                                                1,
                                              ),
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 12,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              elevation: 0,
                                            ),
                                            onPressed:
                                                () =>
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                TugaskanMandor(
                                                                  idProject: project.projectId!, projectName: project.namaProject,
                                                                ),
                                                      ),
                                                    ),
                                            icon: Icon(
                                              Icons.person,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                            label: Text(
                                              'Tugaskan Mandor',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
