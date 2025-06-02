import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tracedev/models/project_model.dart';

class ApiServices {
  static const String baseUrl = "http://192.168.18.95:5113";

  Future<List<ProjectModel>> getAllProjects() async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/Project'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => ProjectModel.fromJson(e)).toList();
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
}
