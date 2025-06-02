import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:tracedev/controller/project_controller.dart';
import 'package:tracedev/view/tambah_projek.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final projectController = Provider.of<ProjectController>(
        context,
        listen: false,
      );
      projectController.getAllProjects();
    });
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
              ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.pushNamed(context, TambahProjek.routeName);
                  await Provider.of<ProjectController>(
                    context,
                    listen: false,
                  ).getAllProjects();
                },
                icon: Icon(Icons.add, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(134, 182, 246, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                label: Text(
                  'Tambah Proyek',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Proyek yang Sedang Berjalan',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.black,
                  ),
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
                          return GestureDetector(
                            onTap: () async {
                              final project = projectController.projects[index];
                              final kecamatan = await getCityFromStringCoords(project.lokasi);
                              showDialog(
                                context: context,
                                builder:
                                    (_) => DetailProyek(
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
                                              projectController
                                                      .projects[index]
                                                      .foto ??
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
                                                projectController
                                                    .projects[index]
                                                    .namaProject,
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
                                                          "-8.166077, 113.710357",
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
                                                      projectController
                                                          .projects[index]
                                                          .status,
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
                                                            projectController
                                                                .projects[index]
                                                                .deadline,
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
                                                onPressed: () {
                                                  // Aksi edit
                                                },
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: Colors.amber[700],
                                                  size: 20,
                                                ),
                                                tooltip: 'Edit Proyek',
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
                                                tooltip: 'Hapus Proyek',
                                                padding: EdgeInsets.all(8),
                                                constraints: BoxConstraints(
                                                  minWidth: 40,
                                                  minHeight: 40,
                                                ),
                                              ),
                                            ),
                                          ],
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
