import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile({
    this.firstName,
    this.lastName,
    this.address1,
    this.address2,
    this.postalCode,
    this.password,
    this.email,
    this.phoneNumber,
  });

  String firstName;
  String lastName;
  dynamic address1;
  dynamic address2;
  dynamic postalCode;
  String password;
  String email;
  String phoneNumber;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        firstName: json["first_name"],
        lastName: json["last_name"],
        address1: json["address_1"],
        address2: json["address_2"],
        postalCode: json["postal_code"],
        password: json["password"],
        email: json["email"],
        phoneNumber: json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "address_1": address1,
        "address_2": address2,
        "postal_code": postalCode,
        "password": password,
        "email": email,
        "phone_number": phoneNumber,
      };

  String get name {
    if (firstName.isEmpty &&
        lastName.isEmpty &&
        firstName == null &&
        lastName == null)
      return '';
    else
      return firstName + " " + lastName;
  }

  String get emailDetail {
    if (email.isEmpty || email == null)
      return 'Not Provided';
    else
      return email.toString();
  }

  String get phoneNo {
    if (phoneNumber.isEmpty || phoneNumber == null)
      return 'Not provided';
    else
      return phoneNumber.toString();
  }

  String get addressDetail {
    if (address1 == null || address2 == null)
      return ''.toString();
    else if (address1 == '' && address2 == '')
      return postalCode.toString();
    else if (postalCode == '' && address1 == '')
      return address2.toString();
    else if (address2 == '' && postalCode == '')
      return address1.toString();
    else
      return address1.toString() +
          "\n" +
          address2.toString() +
          "\n" +
          postalCode.toString();
  }
}
