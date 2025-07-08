import '../model/user_model.dart';

class SessionManager {
  static UserModel? _currentUser;

  static void setUser(UserModel user) {
    _currentUser = user;
  }

  static UserModel? getUser() {
    return _currentUser;
  }

  static int? getUserId() {
    return _currentUser?.id;
  }

  static String? getUserEmail() {
    return _currentUser?.email;
  }

  static String? getUsername() {
    return _currentUser?.username;
  }

  static String? getProfilePicture() {
    return _currentUser?.profilePicture;
  }

  static void clearSession() {
    _currentUser = null;
  }
}
