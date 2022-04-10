part of 'login_bloc.dart';

class LoginState {
  final String email;
  bool get isValidEmail => email.contains('@');
  final String pwd;
  bool get isValidPwd => pwd.length > 3;
  final FormSubmissionStatus formStatus;

  LoginState(
      {this.email = '',
      this.pwd = '',
      this.formStatus = const InitialFormStatus()});

  LoginState copyWith({
    String? email,
    String? pwd,
    FormSubmissionStatus? formStatus,
  }) {
    return LoginState(
        email: email ?? this.email,
        pwd: pwd ?? this.pwd,
        formStatus: formStatus ?? this.formStatus);
  }
}
