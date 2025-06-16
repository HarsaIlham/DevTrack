import 'package:flutter/material.dart';
import 'package:tracedev/models/mandor_project_project.dart';
import 'package:tracedev/services/api_services.dart';

class MandorProjectProjectController extends ChangeNotifier {
  final _apiServices = ApiServices();

  List<MandorProjectProject> _mandorProjectProjects = [];
  List<MandorProjectProject> get mandorProjectProjects =>
      _mandorProjectProjects;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  String? _errorMessage = null;
  String? get errorMessage => _errorMessage;

  Future<bool> tugaskanMandor(int mandorProyekId, int projectId) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    try {
      bool success = await _apiServices.tugaskanMandor(
        mandorProyekId,
        projectId,
      );
      _isSuccess = success;
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
