import 'package:flutter/material.dart';
import 'package:tracedev/models/project_model.dart';
import 'package:tracedev/services/api_services.dart';

class ProjectController extends ChangeNotifier {
  final ApiServices _apiServices = ApiServices();

  List<ProjectModel> _projects = [];
  List<ProjectModel> get projects => _projects;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  // Form controllers
  final TextEditingController namaProjectController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController fotoController = TextEditingController();

  // Selected deadline
  DateTime? _selectedDeadline;
  DateTime? get selectedDeadline => _selectedDeadline;

  // Set deadline
  void setDeadline(DateTime deadline) {
    _selectedDeadline = deadline;
    notifyListeners();
  }

  // Clear form
  void clearForm() {
    namaProjectController.clear();
    lokasiController.clear();
    statusController.clear();
    fotoController.clear();
    _selectedDeadline = null;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();
  }

  Future<void> getAllProjects() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _projects = await _apiServices.getAllProjects();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createProject() async {
    // Reset states
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    try {
      // Create project model
      final project = ProjectModel(
        namaProject: namaProjectController.text.trim(),
        lokasi: lokasiController.text.trim(),
        deadline: _selectedDeadline!,
        status: statusController.text.trim(),
        foto:
            fotoController.text.trim().isEmpty
                ? null
                : fotoController.text.trim(),
      );

      print("Calling API service to create project: $project");
      await _apiServices.createProject(project);
      print("API call successful.");

      // Success
      _isSuccess = true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Dispose controllers
  @override
  void dispose() {
    namaProjectController.dispose();
    lokasiController.dispose();
    statusController.dispose();
    fotoController.dispose();
    super.dispose();
  }
}
