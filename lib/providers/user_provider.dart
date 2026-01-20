
import '../models/user_response.dart';
import '../repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class UserState {
  final bool loading;
  final List<User> users;
  final String? error;

  UserState({
    this.loading = false,
    this.users = const [],
    this.error,
  });

  UserState copyWith({
    bool? loading,
    List<User>? users,
    String? error,
  }) {
    return UserState(
      loading: loading ?? this.loading,
      users: users ?? this.users,
      error: error,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  final UserRepository repository;

  UserNotifier(this.repository) : super(UserState());

  Future<void> fetchAllUsers() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final data = await repository.fetchAllUsers();
      state = state.copyWith(loading: false, users: data);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> toggleUserStatus(String uid) async {
    try {
      await repository.updateActiveStatus(uid);
      
      
      final updatedUsers = state.users.map((user) {
        if (user.uid == uid) {
          return User(
            email: user.email,
            name: user.name,
            uid: user.uid,
            active: !user.active, 
            phone: user.phone,
            dob: user.dob,
            subscriptionPlan: user.subscriptionPlan,
          );
        }
        return user;
      }).toList();

      state = state.copyWith(users: updatedUsers);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await repository.deleteUser(uid);

      state = state.copyWith(
        users: state.users.where((user) => user.uid != uid).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}


final userRepositoryProvider = Provider((ref) => UserRepository());

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return UserNotifier(repo);
});