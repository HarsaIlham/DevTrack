import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tracedev/models/mandor_project.dart';
import 'package:tracedev/models/project_model.dart';
import 'package:tracedev/models/users.dart';

class ApiServices {
  static const String baseUrl = "http://10.132.13.8:5113";

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/Auth/login');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      // Parsing json
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Login gagal. Email atau password salah');
    } else {
      throw Exception('Terjadi kesalahan. Kode: ${response.statusCode}');
    }
  }

  Future<List<ProjectModel>> getAllProjects() async {
    final response = await http.get(Uri.parse('$baseUrl/api/Project'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => ProjectModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data project');
    }
  }

  Future<ProjectModel> getProjectById(int id) async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/Project/$id'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return ProjectModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mengambil data project');
    }
  }

  Future<ProjectModel> createProject(ProjectModel project) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Project/create'),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $token',
      },
      body: json.encode(project.toCreateJson()),
    );

    if (response.statusCode == 200) {
      return ProjectModel.fromJson(json.decode(response.body));
    } else {
      try {
        final Map<String, dynamic> errorData = json.decode(response.body);
        final String errorMessage =
            errorData.containsKey('message')
                ? errorData['message']
                : 'Error ${response.statusCode}: ${response.reasonPhrase}';
        throw Exception(errorMessage);
      } catch (_) {
        throw Exception(
          'Unexpected error ${response.statusCode}: ${response.body}',
        );
      }
    }
  }

  Future<ProjectModel> updateProject(int id, ProjectModel project) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/Project/edit/$id'),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $token',
      },
      body: json.encode(project.toCreateJson()),
    );

    if (response.statusCode == 200) {
      return ProjectModel.fromJson(json.decode(response.body));
    } else {
      try {
        final Map<String, dynamic> errorData = json.decode(response.body);
        final String errorMessage =
            errorData.containsKey('message')
                ? errorData['message']
                : 'Error ${response.statusCode}: ${response.reasonPhrase}';
        throw Exception(errorMessage);
      } catch (_) {
        throw Exception(
          'Unexpected error ${response.statusCode}: ${response.body}',
        );
      }
    }
  }

  Future<List<Users>> getAllMandors() async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/UserManagement/mandor'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Users.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data project');
    }
  }

  Future<Users> getMandorById(int id) async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/UserManagement/mandor/$id'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Users.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mengambil data project');
    }
  }

  Future<Users> createMandor(Users users) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/UserManagement/add-mandor'),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $token',
      },
      body: json.encode(users.toCreateJson()),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Users.fromJson(data['mandor']);
    } else {
      try {
        final Map<String, dynamic> errorData = json.decode(response.body);
        final String errorMessage =
            errorData.containsKey('message')
                ? "Error di API ${errorData['message']}"
                : 'Error ${response.statusCode}: ${response.reasonPhrase}';
        throw Exception(errorMessage);
      } catch (_) {
        throw Exception(
          'Unexpected error ${response.statusCode}: ${response.body}',
        );
      }
    }
  }

  Future<bool> toggleMandorStatus(int id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/UserManagement/ToggleStatus/$id'),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Status berhasil diubah menjadi: ${data['is_active']}');
      return data['is_active'];
    } else {
      try {
        final Map<String, dynamic> errorData = json.decode(response.body);
        final String errorMessage =
            errorData.containsKey('message')
                ? "Error di API ${errorData['message']}"
                : 'Error ${response.statusCode}: ${response.reasonPhrase}';
        throw Exception(errorMessage);
      } catch (_) {
        throw Exception(
          'Unexpected error ${response.statusCode}: ${response.body}',
        );
      }
    }
  }

  Future<Users> editMandor(int id, Users user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/UserManagement/edit-mandor/$id'),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $token',
      },
      body: json.encode(user.toCreateJson()),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Users.fromJson(data['mandor']);
    }

    try {
      final Map<String, dynamic> errorData = json.decode(response.body);
      final String errorMessage =
          errorData.containsKey('message')
              ? "Error di API ${errorData['message']}"
              : 'Error ${response.statusCode}: ${response.reasonPhrase}';
      throw Exception(errorMessage);
    } catch (_) {
      throw Exception(
        'Unexpected error ${response.statusCode}: ${response.body}',
      );
    }
  }

  Future<List<MandorProject>> getAllMandorProject() async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/MandorProject'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => MandorProject.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data project');
    }
  }

  Future<bool> tugaskanMandor(int mandorId, int projectId) async {
    final response = await http
        .post(
          Uri.parse(
            '$baseUrl/api/MandorProjectProject/assign?mandorProyekId=$mandorId&projectId=$projectId',
          ),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return true;
    }
    try {
      final Map<String, dynamic> errorData = json.decode(response.body);
      final String errorMessage =
          errorData.containsKey('message')
              ? "Error di API ${errorData['message']}"
              : 'Error ${response.statusCode}: ${response.reasonPhrase}';
      throw Exception(errorMessage);
    } catch (_) {
      throw Exception(
        'Unexpected error ${response.statusCode}: ${response.body}',
      );
    }
  }
}
