// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swagger.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$Swagger extends Swagger {
  _$Swagger([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = Swagger;

  @override
  Future<Response<List<Game>>> _apiGamesGet() {
    final Uri $url = Uri.parse('/api/Games');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<Game>, Game>($request);
  }

  @override
  Future<Response<Game>> _apiGamesPost({required CreateGameDto? body}) {
    final Uri $url = Uri.parse('/api/Games');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Game, Game>($request);
  }

  @override
  Future<Response<GameStateDto>> _apiGamesIdGet({required int? id}) {
    final Uri $url = Uri.parse('/api/Games/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<GameStateDto, GameStateDto>($request);
  }

  @override
  Future<Response<GameStateDto>> _apiGamesIdPublicGet({required int? id}) {
    final Uri $url = Uri.parse('/api/Games/${id}/public');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<GameStateDto, GameStateDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiGamesIdJoinPost({
    required int? id,
    required JoinGameDto? body,
  }) {
    final Uri $url = Uri.parse('/api/Games/${id}/join');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiGamesIdLeavePost({required int? id}) {
    final Uri $url = Uri.parse('/api/Games/${id}/leave');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiGamesIdStartPost({required int? id}) {
    final Uri $url = Uri.parse('/api/Games/${id}/start');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiGamesIdMovePost({
    required int? id,
    required MakeMoveDto? body,
  }) {
    final Uri $url = Uri.parse('/api/Games/${id}/move');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<GameStateDto>> _apiGamesIdUserIdGet({
    required int? id,
    required int? userId,
  }) {
    final Uri $url = Uri.parse('/api/Games/${id}/${userId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<GameStateDto, GameStateDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiGamesIdJoinUserIdPost({
    required int? id,
    required int? userId,
    required JoinGameDto? body,
  }) {
    final Uri $url = Uri.parse('/api/Games/${id}/join/${userId}');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiGamesIdMoveUserIdPost({
    required int? id,
    required int? userId,
    required MakeMoveDto? body,
  }) {
    final Uri $url = Uri.parse('/api/Games/${id}/move/${userId}');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiGamesIdLeaveUserIdPost({
    required int? id,
    required int? userId,
  }) {
    final Uri $url = Uri.parse('/api/Games/${id}/leave/${userId}');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<UserDto>> _apiUsersRegisterPost(
      {required RegisterDto? body}) {
    final Uri $url = Uri.parse('/api/Users/register');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<UserDto, UserDto>($request);
  }

  @override
  Future<Response<UserDto>> _apiUsersLoginPost({required LoginDto? body}) {
    final Uri $url = Uri.parse('/api/Users/login');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<UserDto, UserDto>($request);
  }

  @override
  Future<Response<UserDto>> _apiUsersProfileGet() {
    final Uri $url = Uri.parse('/api/Users/profile');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<UserDto, UserDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiUsersProfilePut(
      {required UpdateProfileDto? body}) {
    final Uri $url = Uri.parse('/api/Users/profile');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
