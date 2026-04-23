/// Intern model with all internship-related data fields.
/// Designed for REST API / Firebase integration (no SQLite).
class InternModel {
  final String id;
  final String userId;
  final String matricule; // student ID / employee number
  final String fullName;
  final String email;
  final String department;
  final String specialization;
  final String? company;
  final String? mentorId;
  final String? photoUrl;
  final String status; // 'pending' | 'active' | 'completed' | 'suspended'
  final DateTime? internshipStart;
  final DateTime? internshipEnd;
  final String? trainingFileUrl;
  final double? overallGrade;
  final List<String> assignedModules;

  const InternModel({
    required this.id,
    required this.userId,
    required this.matricule,
    required this.fullName,
    required this.email,
    required this.department,
    required this.specialization,
    this.company,
    this.mentorId,
    this.photoUrl,
    this.status = 'pending',
    this.internshipStart,
    this.internshipEnd,
    this.trainingFileUrl,
    this.overallGrade,
    this.assignedModules = const [],
  });

  factory InternModel.fromJson(Map<String, dynamic> json) {
    return InternModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      matricule: json['matricule'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      department: json['department'] as String,
      specialization: json['specialization'] as String,
      company: json['company'] as String?,
      mentorId: json['mentor_id'] as String?,
      photoUrl: json['photo_url'] as String?,
      status: json['status'] as String? ?? 'pending',
      internshipStart: json['internship_start'] != null
          ? DateTime.tryParse(json['internship_start'] as String)
          : null,
      internshipEnd: json['internship_end'] != null
          ? DateTime.tryParse(json['internship_end'] as String)
          : null,
      trainingFileUrl: json['training_file_url'] as String?,
      overallGrade: (json['overall_grade'] as num?)?.toDouble(),
      assignedModules: (json['assigned_modules'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'matricule': matricule,
        'full_name': fullName,
        'email': email,
        'department': department,
        'specialization': specialization,
        'company': company,
        'mentor_id': mentorId,
        'photo_url': photoUrl,
        'status': status,
        'internship_start': internshipStart?.toIso8601String(),
        'internship_end': internshipEnd?.toIso8601String(),
        'training_file_url': trainingFileUrl,
        'overall_grade': overallGrade,
        'assigned_modules': assignedModules,
      };

  bool get isActive => status == 'active';
  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';
}
