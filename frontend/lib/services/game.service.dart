import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:frontend/api/swagger.swagger.dart';
import 'package:frontend/api/swagger.models.swagger.dart';
import 'package:get/get.dart';
import 'error_service.dart';

class GameService extends GetxService {
  static GameService get to => Get.find<GameService>();
  static const _tokenKey = 'jwt_token';

  final _api = Get.find<Swagger>();

  final RxnString _token = RxnString();
  String? get token => _token.value;
  bool get isLoggedIn => _token.value != null;

  Future<GameService> init() async {
    _token.value = html.window.localStorage[_tokenKey];
    return this;
  }

  Future<List<Game>> getGames() async {
    final response = await _api.apiGamesGet();

    if (response.isSuccessful) {
      return response.body ?? [];
    } else {
      final error = 'Failed to load games: ${response.error} ${response.body}';
      ErrorService.to.showError(error);
      throw Exception(error);
    }
  }

  Future<Game> createGame(CreateGameDto body) async {
    final response = await _api.apiGamesPost(body: body);

    if (response.isSuccessful) {
      return response.body!;
    } else {
      final error = 'Failed to create game: ${response.error} ${response.body}';
      ErrorService.to.showError(error);
      throw Exception(error);
    }
  }

  Future<GameStateDto> getGame(int gameId) async {
    final response = await _api.apiGamesIdGet(id: gameId);

    if (response.isSuccessful) {
      return response.body!;
    } else {
      final error = 'Failed to fetch game: ${response.error} ${response.body}';
      ErrorService.to.showError(error);
      throw Exception(error);
    }
  }

  Future<void> joinGame(JoinGameDto body, int gameId, int userId) async {
    final response = await _api.apiGamesIdJoinUserIdPost(
        id: gameId, userId: userId, body: body);
    if (response.isSuccessful) {
      // await getGame(gameId);
      return;
    } else {
      final error = 'Failed to join game: ${response.error} ${response.body}';
      ErrorService.to.showError(error);
      throw Exception(error);
    }
  }

  Future<void> startGame(int gameId) async {
    final response = await _api.apiGamesIdStartPost(id: gameId);
    if (response.isSuccessful) {
      return;
    } else {
      final error = 'Failed to start game: ${response.error} ${response.body}';
      ErrorService.to.showError(error);
      throw Exception(error);
    }
  }

  Future<void> makeMove(
      int gameId, int userId, String actionType, int amount) async {
    final response = await _api.apiGamesIdMoveUserIdPost(
        id: gameId,
        userId: userId,
        body: MakeMoveDto(actionType: actionType, amount: amount));
    if (response.isSuccessful) {
      return;
    } else {
      final error = 'Failed to make move: ${response.error} ${response.body}';
      ErrorService.to.showError(error);
      throw Exception(error);
    }
  }
}
