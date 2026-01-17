class ProfileModel {
  final String userName;
  final int points;
  final String? profilePhotoUrl;
  final String address;
  final String bankSampahName;

  ProfileModel({
    required this.userName,
    required this.points,
    this.profilePhotoUrl,
    required this.address,
    required this.bankSampahName,
  });
}
