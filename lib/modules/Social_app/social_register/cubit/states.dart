abstract class SocialRegisterStates {}

class SocialRegisterInitialState extends SocialRegisterStates {}

class SocialRegisterChangePasswordState extends SocialRegisterStates {}

class SocialCreateUserSuccessState extends SocialRegisterStates {
  final String uId;
  SocialCreateUserSuccessState(this.uId);
}

class SocialCreateUserErrorState extends SocialRegisterStates {}

class SocialLoadingRegisterState extends SocialRegisterStates {}

class SocialSuccessRegisterState extends SocialRegisterStates {}

class SocialErrorRegisterState extends SocialRegisterStates {}
