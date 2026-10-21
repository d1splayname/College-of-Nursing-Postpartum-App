 
// ============================================================
// (1) If you move this file into another folder, don't 
// forget to change the import path in family_screen.dart
//
// (2) Once APIs are connected, change mock calls in 
// family_screen.dart (marked as TODO)
// ============================================================


class FamilyMember {
  final String id; // database id
  final String username; // unique across the entire app
  final String nickname; // display name shown in the UI (set by primary user)
  String relationship;
  final bool isCurrentUser;

  FamilyMember({
    required this.id,
    required this.username,
    required this.nickname,
    required this.relationship,
    this.isCurrentUser = false,
  });


  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'].toString(),
      username: json['username'] as String,
      nickname: json['nickname'] as String,
      relationship: json['relationship'] as String,
      isCurrentUser: json['is_current_user'] as bool? ?? false,
    );
  }
}

class UsernameTakenException implements Exception {
  const UsernameTakenException();
}

abstract class FamilyService {
  Future<List<FamilyMember>> fetchMembers();


  Future<FamilyMember> addMember({
    required String username,
    required String nickname,
    required String password,
    required String relationship,
  });

  Future<void> updateRelationship(String id, String relationship);

  Future<void> removeMember(String id);
}


class ApiFamilyService implements FamilyService {
  @override
  Future<List<FamilyMember>> fetchMembers() {
    // TODO: GET /api/family-members
    throw UnimplementedError();
  }

  @override
  Future<FamilyMember> addMember({
    required String username,
    required String nickname,
    required String password,
    required String relationship,
  }) {
    // TODO: POST /api/family-members
    // if (response.statusCode == 409) throw const UsernameTakenException();
    throw UnimplementedError();
  }

  @override
  Future<void> updateRelationship(String id, String relationship) {
    // TODO: PATCH /api/family-members/$id
    throw UnimplementedError();
  }

  @override
  Future<void> removeMember(String id) {
    // TODO: DELETE /api/family-members/$id
    throw UnimplementedError();
  }
}

// ------------------------------------------------------------
// In-memory stand-in so the UI works before the backend exists.
// ------------------------------------------------------------
class MockFamilyService implements FamilyService {
  final List<FamilyMember> _members = [
    FamilyMember(
      id: '0',
      username: 'you',
      nickname: 'You',
      relationship: 'Mom',
      isCurrentUser: true,
    ),
  ];
  int _nextId = 1;

  @override
  Future<List<FamilyMember>> fetchMembers() async => List.of(_members);

  @override
  Future<FamilyMember> addMember({
    required String username,
    required String nickname,
    required String password,
    required String relationship,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final taken = _members.any(
      (m) => m.username.toLowerCase() == username.toLowerCase(),
    );
    if (taken) throw const UsernameTakenException();

    final member = FamilyMember(
      id: '${_nextId++}',
      username: username,
      nickname: nickname,
      relationship: relationship,
    );
    _members.add(member);
    return member;
  }

  @override
  Future<void> updateRelationship(String id, String relationship) async {
    _members.firstWhere((m) => m.id == id).relationship = relationship;
  }

  @override
  Future<void> removeMember(String id) async {
    _members.removeWhere((m) => m.id == id);
  }
}