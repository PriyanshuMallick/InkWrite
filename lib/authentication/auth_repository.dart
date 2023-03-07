import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:inkwrite/models/ErrorModel.dart';
import 'package:inkwrite/models/user_model.dart';
import 'package:inkwrite/storage/local_storage.dart';

import '../utils/app_const.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorage: LocalStorage(),
  ),
);

final userProvider = StateProvider<UserModel?>(
  (ref) => null,
);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorage _localStorage;

  AuthRepository({
    required GoogleSignIn googleSignIn,
    required Client client,
    required LocalStorage localStorage,
  })  : _googleSignIn = googleSignIn,
        _client = client,
        _localStorage = localStorage;

  Future<ErrorModel> signInWithGoogle() async {
    // await AppConst.init();
    ErrorModel nError = ErrorModel(
      error: 'Some error occurred.',
      data: null,
    );
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAccount = UserModel(
          uid: '',
          name: user.displayName ?? '',
          email: user.email,
          profilePic: user.photoUrl ?? '',
          token: '',
        );

        // print("Host: ${AppConst.host}");

        var res = await _client.post(
          Uri.parse('${AppConst.host}/api/signup'),
          body: userAccount.toJson(),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        switch (res.statusCode) {
          case 200:
            final userData = jsonDecode(res.body);
            final newUser = userAccount.copyWith(
              uid: userData['user']['_id'],
              token: userData['token'],
            );
            nError = ErrorModel(error: null, data: newUser);
            _localStorage.setToken(newUser.token);
            break;
          default:
            print('Error From my REST: ${res.statusCode}');
        }
      }
    } catch (e) {
      nError = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return nError;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel error = ErrorModel(
      error: 'Some error occurred',
      data: null,
    );

    try {
      String? token = await _localStorage.getToken();

      if (token != null) {
        var res = await _client.get(
          Uri.parse('${AppConst.host}/'),
          headers: {
            'ContentType': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );
        switch (res.statusCode) {
          case 200:
            final newUser = UserModel.fromJson(
              jsonEncode(
                jsonDecode(res.body)['user'],
              ),
            ).copyWith(token: token);
            error = ErrorModel(error: null, data: newUser);
            _localStorage.setToken(newUser.token);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  void signOut() async {
    await _googleSignIn.signOut();
    _localStorage.setToken('');
  }
}
