class Scenario {
  final String userCharacter; // Vai trò hoặc nghề nghiệp của người dùng
  final String userGender; // Giới tính người dùng
  final String aiCharacter; // Vai trò AI
  final String aiGender; // Giới tính AI
  final String description; // Mô tả tình huống

  Scenario({
    required this.userCharacter,
    required this.userGender,
    required this.aiCharacter,
    required this.aiGender,
    required this.description,
  });
}
