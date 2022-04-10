import 'package:bloc/bloc.dart';
import 'package:hnc/bloc/login/form_submission_status.dart';
import 'package:hnc/repository/hnc_repository.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.hncRepository}) : super(LoginState()) {
    on<EmailChangedEvent>(_emailChange);
    on<PasswordChangedEvent>(_passwordChange);
    on<LoginButtonPressEvent>(_loginSubmitted);
  }

  final HncRepository hncRepository;

  void _emailChange(EmailChangedEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(email: event.email));
  }

  void _passwordChange(
      PasswordChangedEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(pwd: event.pwd));
  }

  void _loginSubmitted(
      LoginButtonPressEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));
    try {
      await Future.delayed(
        const Duration(
          seconds: 8,
        ),
      );
      await hncRepository.authenticate(state.email, state.pwd);
      emit(state.copyWith(formStatus: SubmittingSuccess()));
    } catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(e as Exception)));
    }
  }
}
