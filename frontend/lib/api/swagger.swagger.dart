// ignore_for_file: type=lint

import 'swagger.models.swagger.dart';
import 'package:chopper/chopper.dart';

import 'client_mapping.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:chopper/chopper.dart' as chopper;
export 'swagger.models.swagger.dart';

part 'swagger.swagger.chopper.dart';

// **************************************************************************
// SwaggerChopperGenerator
// **************************************************************************

@ChopperApi()
abstract class Swagger extends ChopperService {
  static Swagger create({
    ChopperClient? client,
    http.Client? httpClient,
    Authenticator? authenticator,
    ErrorConverter? errorConverter,
    Converter? converter,
    Uri? baseUrl,
    Iterable<dynamic>? interceptors,
  }) {
    if (client != null) {
      return _$Swagger(client);
    }

    final newClient = ChopperClient(
        services: [_$Swagger()],
        converter: converter ?? $JsonSerializableConverter(),
        interceptors: interceptors?.cast<Interceptor>().toList() ?? [],
        client: httpClient,
        authenticator: authenticator,
        errorConverter: errorConverter,
        baseUrl: baseUrl ?? Uri.parse('http://'));
    return _$Swagger(newClient);
  }

  ///
  Future<chopper.Response<List<Game>>> apiGamesGet() {
    generatedMapping.putIfAbsent(Game, () => Game.fromJsonFactory);

    return _apiGamesGet();
  }

  ///
  @Get(path: '/api/Games')
  Future<chopper.Response<List<Game>>> _apiGamesGet();

  ///
  Future<chopper.Response<Game>> apiGamesPost({required CreateGameDto? body}) {
    generatedMapping.putIfAbsent(Game, () => Game.fromJsonFactory);

    return _apiGamesPost(body: body);
  }

  ///
  @Post(
    path: '/api/Games',
    optionalBody: true,
  )
  Future<chopper.Response<Game>> _apiGamesPost(
      {@Body() required CreateGameDto? body});

  ///
  ///@param id
  Future<chopper.Response<GameState>> apiGamesIdGet({required int? id}) {
    generatedMapping.putIfAbsent(GameState, () => GameState.fromJsonFactory);

    return _apiGamesIdGet(id: id);
  }

  ///
  ///@param id
  @Get(path: '/api/Games/{id}')
  Future<chopper.Response<GameState>> _apiGamesIdGet(
      {@Path('id') required int? id});

  ///
  ///@param id
  Future<chopper.Response> apiGamesIdJoinPost({
    required int? id,
    required JoinGameDto? body,
  }) {
    return _apiGamesIdJoinPost(id: id, body: body);
  }

  ///
  ///@param id
  @Post(
    path: '/api/Games/{id}/join',
    optionalBody: true,
  )
  Future<chopper.Response> _apiGamesIdJoinPost({
    @Path('id') required int? id,
    @Body() required JoinGameDto? body,
  });

  ///
  ///@param id
  Future<chopper.Response> apiGamesIdLeavePost({required int? id}) {
    return _apiGamesIdLeavePost(id: id);
  }

  ///
  ///@param id
  @Post(
    path: '/api/Games/{id}/leave',
    optionalBody: true,
  )
  Future<chopper.Response> _apiGamesIdLeavePost({@Path('id') required int? id});

  ///
  ///@param id
  Future<chopper.Response> apiGamesIdStartPost({required int? id}) {
    return _apiGamesIdStartPost(id: id);
  }

  ///
  ///@param id
  @Post(
    path: '/api/Games/{id}/start',
    optionalBody: true,
  )
  Future<chopper.Response> _apiGamesIdStartPost({@Path('id') required int? id});

  ///
  ///@param id
  Future<chopper.Response> apiGamesIdMovePost({
    required int? id,
    required MakeMoveDto? body,
  }) {
    return _apiGamesIdMovePost(id: id, body: body);
  }

  ///
  ///@param id
  @Post(
    path: '/api/Games/{id}/move',
    optionalBody: true,
  )
  Future<chopper.Response> _apiGamesIdMovePost({
    @Path('id') required int? id,
    @Body() required MakeMoveDto? body,
  });

  ///
  Future<chopper.Response> apiPaymentsCreateCheckoutSessionPost(
      {required int? body}) {
    return _apiPaymentsCreateCheckoutSessionPost(body: body);
  }

  ///
  @Post(
    path: '/api/Payments/create-checkout-session',
    optionalBody: true,
  )
  Future<chopper.Response> _apiPaymentsCreateCheckoutSessionPost(
      {@Body() required int? body});

  ///
  ///@param session_id
  ///@param itemId
  Future<chopper.Response> apiPaymentsSuccessGet({
    String? sessionId,
    int? itemId,
  }) {
    return _apiPaymentsSuccessGet(sessionId: sessionId, itemId: itemId);
  }

  ///
  ///@param session_id
  ///@param itemId
  @Get(path: '/api/Payments/success')
  Future<chopper.Response> _apiPaymentsSuccessGet({
    @Query('session_id') String? sessionId,
    @Query('itemId') int? itemId,
  });

  ///
  Future<chopper.Response> apiPaymentsCancelGet() {
    return _apiPaymentsCancelGet();
  }

  ///
  @Get(path: '/api/Payments/cancel')
  Future<chopper.Response> _apiPaymentsCancelGet();

  ///
  Future<chopper.Response<UserDto>> apiUsersRegisterPost(
      {required RegisterDto? body}) {
    generatedMapping.putIfAbsent(UserDto, () => UserDto.fromJsonFactory);

    return _apiUsersRegisterPost(body: body);
  }

  ///
  @Post(
    path: '/api/Users/register',
    optionalBody: true,
  )
  Future<chopper.Response<UserDto>> _apiUsersRegisterPost(
      {@Body() required RegisterDto? body});

  ///
  Future<chopper.Response<UserDto>> apiUsersLoginPost(
      {required LoginDto? body}) {
    generatedMapping.putIfAbsent(UserDto, () => UserDto.fromJsonFactory);

    return _apiUsersLoginPost(body: body);
  }

  ///
  @Post(
    path: '/api/Users/login',
    optionalBody: true,
  )
  Future<chopper.Response<UserDto>> _apiUsersLoginPost(
      {@Body() required LoginDto? body});

  ///
  Future<chopper.Response<UserDto>> apiUsersProfileGet() {
    generatedMapping.putIfAbsent(UserDto, () => UserDto.fromJsonFactory);

    return _apiUsersProfileGet();
  }

  ///
  @Get(path: '/api/Users/profile')
  Future<chopper.Response<UserDto>> _apiUsersProfileGet();

  ///
  Future<chopper.Response> apiUsersProfilePut(
      {required UpdateProfileDto? body}) {
    return _apiUsersProfilePut(body: body);
  }

  ///
  @Put(
    path: '/api/Users/profile',
    optionalBody: true,
  )
  Future<chopper.Response> _apiUsersProfilePut(
      {@Body() required UpdateProfileDto? body});

  ///
  ///@param count
  Future<chopper.Response<List<LeaderboardEntry>>> apiUsersLeaderboardTopGet(
      {int? count}) {
    generatedMapping.putIfAbsent(
        LeaderboardEntry, () => LeaderboardEntry.fromJsonFactory);

    return _apiUsersLeaderboardTopGet(count: count);
  }

  ///
  ///@param count
  @Get(path: '/api/Users/leaderboard/top')
  Future<chopper.Response<List<LeaderboardEntry>>> _apiUsersLeaderboardTopGet(
      {@Query('count') int? count});

  ///
  ///@param userId
  Future<chopper.Response> apiUsersLeaderboardPlayerInfoUserIdGet(
      {required int? userId}) {
    return _apiUsersLeaderboardPlayerInfoUserIdGet(userId: userId);
  }

  ///
  ///@param userId
  @Get(path: '/api/Users/leaderboard/player-info/{userId}')
  Future<chopper.Response> _apiUsersLeaderboardPlayerInfoUserIdGet(
      {@Path('userId') required int? userId});
}

typedef $JsonFactory<T> = T Function(Map<String, dynamic> json);

class $CustomJsonDecoder {
  $CustomJsonDecoder(this.factories);

  final Map<Type, $JsonFactory> factories;

  dynamic decode<T>(dynamic entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity);
    }

    if (entity is T) {
      return entity;
    }

    if (isTypeOf<T, Map>()) {
      return entity;
    }

    if (isTypeOf<T, Iterable>()) {
      return entity;
    }

    if (entity is Map<String, dynamic>) {
      return _decodeMap<T>(entity);
    }

    return entity;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! $JsonFactory<T>) {
      return throw "Could not find factory for type $T. Is '$T: $T.fromJsonFactory' included in the CustomJsonDecoder instance creation in bootstrapper.dart?";
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<T>((v) => decode<T>(v) as T).toList();
}

class $JsonSerializableConverter extends chopper.JsonConverter {
  @override
  FutureOr<chopper.Response<ResultType>> convertResponse<ResultType, Item>(
      chopper.Response response) async {
    if (response.bodyString.isEmpty) {
      // In rare cases, when let's say 204 (no content) is returned -
      // we cannot decode the missing json with the result type specified
      return chopper.Response(response.base, null, error: response.error);
    }

    if (ResultType == String) {
      return response.copyWith();
    }

    if (ResultType == DateTime) {
      return response.copyWith(
          body: DateTime.parse((response.body as String).replaceAll('"', ''))
              as ResultType);
    }

    final jsonRes = await super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
        body: $jsonDecoder.decode<Item>(jsonRes.body) as ResultType);
  }
}

final $jsonDecoder = $CustomJsonDecoder(generatedMapping);
