class Profile {
  String email;
  String password;
  String userType;
  String firstName;
  String lastName;
  String phoneNumber;

  Profile({
    required this.email,
    required this.password,
    this.userType = "customer",
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });
}
