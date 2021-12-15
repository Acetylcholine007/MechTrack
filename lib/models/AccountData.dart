class AccountData {
  String uid;
  String fullName;
  String username;
  String accountType;
  String email;
  bool isVerified;

  AccountData({
    this.uid,
    this.fullName,
    this.username,
    this.accountType,
    this.email,
    this.isVerified
  });

  AccountData copy() => AccountData(
    uid: this.uid,
    fullName: this.fullName,
    accountType: this.accountType,
    email: this.email,
    isVerified: this.isVerified
  );
}