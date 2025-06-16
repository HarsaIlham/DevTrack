import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracedev/controller/mandor_project_controller.dart';
import 'package:tracedev/controller/mandor_project_project_controller.dart';
import 'package:tracedev/controller/users_controller.dart';
import 'package:tracedev/models/mandor_project.dart';
import 'package:tracedev/models/users.dart';
import 'package:tracedev/widget/confirm_assign_dialog.dart';
import 'package:tracedev/widget/show_snackbar.dart';

class TugaskanMandor extends StatefulWidget {
  final int idProject;
  final String projectName;

  const TugaskanMandor({
    super.key,
    required this.idProject,
    required this.projectName,
  });

  @override
  State<TugaskanMandor> createState() => _TugaskanMandorState();
}

class _TugaskanMandorState extends State<TugaskanMandor> {
  final TextEditingController _searchController = TextEditingController();
  final MandorProjectProjectController _mandorProjectProjectController =
      MandorProjectProjectController();
  late MandorProjectController _mandorProjectController;
  String _selectedFilter = 'Semua';
  List<MandorProject> originalData = [];
  List<MandorProject> filteredData = [];
  Map<int, MandorProject> _mandorProjects = {};
  int _selectedMandorId = 0;
  bool? isWorkingFilter;

  @override
  void initState() {
    super.initState();
    _mandorProjectController = MandorProjectController();
    _loadMandors();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMandors() async {
    await Future.delayed(const Duration(seconds: 1));
    await _mandorProjectController.getAllMandorProject();
    setState(() {
      originalData = _mandorProjectController.mandorsProject;
      filteredData = List.from(originalData);
    });
  }

  void filterByWorkingStatus(bool? isWorking) {
    setState(() {
      isWorkingFilter = isWorking;
      _applyFilters();
    });
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    List<MandorProject> tempData = List.from(originalData);

    // Filter berdasarkan isWorking
    if (isWorkingFilter != null) {
      tempData =
          tempData.where((item) => item.isWorking == isWorkingFilter).toList();
    }

    // Search berdasarkan nama dan alamat
    String searchTerm = _searchController.text.toLowerCase().trim();
    if (searchTerm.isNotEmpty) {
      tempData =
          tempData.where((item) {
            String nama = item.users!.nama.toLowerCase();
            String alamat = item.users!.alamat.toLowerCase();
            return nama.contains(searchTerm) || alamat.contains(searchTerm);
          }).toList();
    }

    setState(() {
      filteredData = tempData;
    });
  }

  void resetFilters() {
    setState(() {
      isWorkingFilter = null;
      _searchController.clear();
      filteredData = List.from(originalData);
    });
  }

  void _selectMandor(int mandorId) {
    setState(() {
      _selectedMandorId = mandorId;
    });
  }

  void _assignMandor() {
    if (_selectedMandorId != 0) {
      MandorProject? selectedMandor = originalData.firstWhere(
        (mandor) => mandor.userId == _selectedMandorId,
      );
      showDialog(
        context: context,
        builder:
            (context) => ConfirmAssignDialog(
              id: _selectedMandorId,
              isWorking: selectedMandor.isWorking,
              name: selectedMandor.users!.nama,
              foto: selectedMandor.users!.foto,
              onConfirm: () async {
                await _mandorProjectProjectController.tugaskanMandor(_selectedMandorId, widget.idProject);
                await _loadMandors();
                ShowSnackbar.show(context, 'Mandor berhasil ditugaskan!');
                Navigator.pop(context);
              },
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Tugaskan Mandor',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(36, 158, 192, 1),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: resetFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari mandor berdasarkan nama, atau alamat...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Filter Chips
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      SizedBox(width: 8),
                      FilterChip(
                        label: Text('Semua'),
                        selected: isWorkingFilter == null,
                        onSelected: (selected) => filterByWorkingStatus(null),
                      ),
                      SizedBox(width: 8),
                      FilterChip(
                        label: Text('Tersedia'),
                        selected: isWorkingFilter == false,
                        onSelected: (selected) => filterByWorkingStatus(false),
                      ),
                      SizedBox(width: 8),
                      FilterChip(
                        label: Text('Sibuk'),
                        selected: isWorkingFilter == true,
                        onSelected: (selected) => filterByWorkingStatus(true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredData.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                MandorProject mandorProject = filteredData[index];
                return _buildMandorCard(mandorProject);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          _selectedMandorId != 0
              ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: ElevatedButton(
                    onPressed: _assignMandor,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Tugaskan Mandor',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
              : null,
    );
  }

  // Widget _buildFilterChip(String label) {
  //   bool isSelected = _selectedFilter == label;
  //   return Padding(
  //     padding: const EdgeInsets.only(right: 8),
  //     child: FilterChip(
  //       label: Text(label),
  //       selected: isSelected,
  //       onSelected: (selected) {
  //         setState(() {
  //           _selectedFilter = label;
  //         });
  //         _filterMandors();
  //       },
  //       backgroundColor: Colors.grey[100],
  //       selectedColor: Colors.blue[100],
  //       checkmarkColor: Colors.blue[600],
  //       labelStyle: TextStyle(
  //         color: isSelected ? Colors.blue[600] : Colors.grey[700],
  //         fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildMandorCard(MandorProject mandor) {
    bool isSelected = _selectedMandorId == mandor.userId;
    bool isAvailable = mandor.isWorking == false;

    return GestureDetector(
      onTap: isAvailable ? () => _selectMandor(mandor.userId!) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue[600]! : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                          image:
                              mandor.users!.foto != null
                                  ? DecorationImage(
                                    image: NetworkImage(mandor.users!.foto!),
                                    fit: BoxFit.cover,
                                    onError: (error, stackTrace) {},
                                  )
                                  : null,
                        ),
                        child:
                            mandor.users!.foto == null
                                ? Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.grey[600],
                                )
                                : null,
                      ),
                      const SizedBox(width: 16),

                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    mandor.users!.nama,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isAvailable
                                            ? Colors.green[100]
                                            : Colors.orange[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    mandor.isWorking ? 'Sibuk' : 'Siap',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          isAvailable
                                              ? Colors.green[700]
                                              : Colors.orange[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    mandor.users!.alamat,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 14,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  mandor.users!.noHp,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Stats
                  if (mandor != null)
                    Row(
                      children: [
                        _buildStatItem(Icons.star, '5', Colors.orange),
                        _buildStatItem(Icons.work, '100 proyek', Colors.blue),
                        _buildStatItem(
                          Icons.schedule,
                          mandor.isWorking ? 'Bekerja' : 'Tidak Bekerja',
                          Colors.green,
                        ),
                      ],
                    ),

                  // Selection Indicator
                  if (isSelected)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),

                  // Unavailable Overlay
                  if (!isAvailable)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, Color color) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Tidak ada mandor ditemukan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba ubah kata kunci pencarian atau filter',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
