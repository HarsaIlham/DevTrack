import 'package:tracedev/models/mandor_project.dart';
import 'package:tracedev/models/project_model.dart';

class MandorProjectProject {
  final int? id;
  final int mandorProyekId;
  final int projectId;
  final MandorProject? mandorProject;
  final ProjectModel? projectModel;

  MandorProjectProject({
    this.id,
    required this.mandorProyekId,
    required this.projectId,
    required this.mandorProject,
    required this.projectModel,
  });

  factory MandorProjectProject.fromJson(Map<String, dynamic> json) {
    return MandorProjectProject(
      id: json['id'],
      mandorProyekId: json['mandorProyekId'],
      projectId: json['projectId'],
      mandorProject: json['mandorProject'] != null
          ? MandorProject.fromJson(json['mandorProject'])
          : null,
      projectModel: json['project'] != null
          ? ProjectModel.fromJson(json['project'])
          : null,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {'mandorProyekId': mandorProyekId, 'projectId': projectId};
  }
}
