import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tracedev/models/project_model.dart';
import 'package:tracedev/services/api_services.dart';
import 'package:tracedev/services/cloudinary_service.dart';

class ProjectController extends ChangeNotifier {
  final ApiServices _apiServices = ApiServices();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  List<ProjectModel> _projects = [];
  List<ProjectModel> get projects => _projects;

  ProjectModel? _project;
  ProjectModel? get project => _project;

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
    _selectedDeadline = null;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();
  }

  Future<void> getAllProjects() async {
    print("[getAllProjects] Called");

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    print("[getAllProjects] Loading started");

    try {
      print("[getAllProjects] Connecting to API...");
      _projects = await _apiServices.getAllProjects();
      print(
        "[getAllProjects] API call successful. Project count: ${_projects.length}",
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      print("[getAllProjects] Error occurred: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
      print("[getAllProjects] Loading ended");
    }
  }

  Future<void> getProjectById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _project = await _apiServices.getProjectById(id);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createProject(File? _selectedImage) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    try {
      String? _imageUrl;

      if (_selectedImage != null) {
        _imageUrl = await _cloudinaryService.uploadGambar(_selectedImage);
        if (_imageUrl == null) {
          throw Exception('Gagal mengupload gambar ke Cloudinary');
        }
      }
      // Create project model
      final project = ProjectModel(
        namaProject: namaProjectController.text.trim(),
        lokasi: lokasiController.text.trim(),
        deadline: _selectedDeadline!,
        status: statusController.text.trim(),
        foto: _imageUrl,
      );

      await _apiServices.createProject(project);

      // Success
      _isSuccess = true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProject(int id, File? _selectedImage, String _imgUrlSekarang) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    try {
      String? _imageUrl;

      if (_selectedImage != null) {
        _imageUrl = await _cloudinaryService.uploadGambar(_selectedImage);
        if (_imageUrl == null) {
          throw Exception('Gagal mengupload gambar ke Cloudinary');
        }
      } else {
        _imageUrl = _imgUrlSekarang;
      }

      final project = ProjectModel(
        namaProject: namaProjectController.text.trim(),
        lokasi: lokasiController.text.trim(),
        deadline: _selectedDeadline!,
        status: statusController.text.trim(),
        foto: _imageUrl,
      );

      await _apiServices.updateProject(id, project);
      _isSuccess = true;
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
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
    super.dispose();
  }
}
