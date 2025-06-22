// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:collection/collection.dart';
import 'dart:convert';

import 'swagger.models.swagger.dart';
import 'package:chopper/chopper.dart';

import 'client_mapping.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show MultipartFile;
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
    List<Interceptor>? interceptors,
  }) {
    if (client != null) {
      return _$Swagger(client);
    }

    final newClient = ChopperClient(
        services: [_$Swagger()],
        converter: converter ?? $JsonSerializableConverter(),
        interceptors: interceptors ?? [],
        client: httpClient,
        authenticator: authenticator,
        errorConverter: errorConverter,
        baseUrl: baseUrl ?? Uri.parse('http://'));
    return _$Swagger(newClient);
  }

  ///
  Future<chopper.Response<List<ActiveGameDto>>> apiGamesGet() {
    generatedMapping.putIfAbsent(
        ActiveGameDto, () => ActiveGameDto.fromJsonFactory);

    return _apiGamesGet();
  }

  ///
  @Get(path: '/api/Games')
  Future<chopper.Response<List<ActiveGameDto>>> _apiGamesGet();

  ///
  Future<chopper.Response<ActiveGameDto>> apiGamesPost(
      {required CreateGameDto? body}) {
    generatedMapping.putIfAbsent(
        ActiveGameDto, () => ActiveGameDto.fromJsonFactory);

    return _apiGamesPost(body: body);
  }

  ///
  @Post(
    path: '/api/Games',
    optionalBody: true,
  )
  Future<chopper.Response<ActiveGameDto>> _apiGamesPost(
      {@Body() required CreateGameDto? body});

  ///
  Future<chopper.Response<List<TableDto>>> tablesGet() {
    generatedMapping.putIfAbsent(TableDto, () => TableDto.fromJsonFactory);

    return _tablesGet();
  }

  ///
  @Get(path: '/tables')
  Future<chopper.Response<List<TableDto>>> _tablesGet();

  ///
  ///@param id
  Future<chopper.Response<GameStateDto>> apiGamesIdGet({required int? id}) {
    generatedMapping.putIfAbsent(
        GameStateDto, () => GameStateDto.fromJsonFactory);

    return _apiGamesIdGet(id: id);
  }

  ///
  ///@param id
  @Get(path: '/api/Games/{id}')
  Future<chopper.Response<GameStateDto>> _apiGamesIdGet(
      {@Path('id') required int? id});

  ///
  ///@param id
  Future<chopper.Response<GameStateDto>> apiGamesIdPublicGet(
      {required int? id}) {
    generatedMapping.putIfAbsent(
        GameStateDto, () => GameStateDto.fromJsonFactory);

    return _apiGamesIdPublicGet(id: id);
  }

  ///
  ///@param id
  @Get(path: '/api/Games/{id}/public')
  Future<chopper.Response<GameStateDto>> _apiGamesIdPublicGet(
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
  ///@param id
  Future<chopper.Response<List<HintDto>>> apiGamesIdHintPost(
      {required int? id}) {
    generatedMapping.putIfAbsent(HintDto, () => HintDto.fromJsonFactory);

    return _apiGamesIdHintPost(id: id);
  }

  ///
  ///@param id
  @Post(
    path: '/api/Games/{id}/hint',
    optionalBody: true,
  )
  Future<chopper.Response<List<HintDto>>> _apiGamesIdHintPost(
      {@Path('id') required int? id});

  ///
  ///@param id
  ///@param userId
  Future<chopper.Response<GameStateDto>> apiGamesIdUserIdGet({
    required int? id,
    required int? userId,
  }) {
    generatedMapping.putIfAbsent(
        GameStateDto, () => GameStateDto.fromJsonFactory);

    return _apiGamesIdUserIdGet(id: id, userId: userId);
  }

  ///
  ///@param id
  ///@param userId
  @Get(path: '/api/Games/{id}/{userId}')
  Future<chopper.Response<GameStateDto>> _apiGamesIdUserIdGet({
    @Path('id') required int? id,
    @Path('userId') required int? userId,
  });

  ///
  ///@param id
  ///@param userId
  Future<chopper.Response> apiGamesIdJoinUserIdPost({
    required int? id,
    required int? userId,
    required JoinGameDto? body,
  }) {
    return _apiGamesIdJoinUserIdPost(id: id, userId: userId, body: body);
  }

  ///
  ///@param id
  ///@param userId
  @Post(
    path: '/api/Games/{id}/join/{userId}',
    optionalBody: true,
  )
  Future<chopper.Response> _apiGamesIdJoinUserIdPost({
    @Path('id') required int? id,
    @Path('userId') required int? userId,
    @Body() required JoinGameDto? body,
  });

  ///
  ///@param id
  ///@param userId
  Future<chopper.Response> apiGamesIdMoveUserIdPost({
    required int? id,
    required int? userId,
    required MakeMoveDto? body,
  }) {
    return _apiGamesIdMoveUserIdPost(id: id, userId: userId, body: body);
  }

  ///
  ///@param id
  ///@param userId
  @Post(
    path: '/api/Games/{id}/move/{userId}',
    optionalBody: true,
  )
  Future<chopper.Response> _apiGamesIdMoveUserIdPost({
    @Path('id') required int? id,
    @Path('userId') required int? userId,
    @Body() required MakeMoveDto? body,
  });

  ///
  ///@param id
  ///@param userId
  Future<chopper.Response<List<HintDto>>> apiGamesIdHintUserIdPost({
    required int? id,
    required int? userId,
  }) {
    generatedMapping.putIfAbsent(HintDto, () => HintDto.fromJsonFactory);

    return _apiGamesIdHintUserIdPost(id: id, userId: userId);
  }

  ///
  ///@param id
  ///@param userId
  @Post(
    path: '/api/Games/{id}/hint/{userId}',
    optionalBody: true,
  )
  Future<chopper.Response<List<HintDto>>> _apiGamesIdHintUserIdPost({
    @Path('id') required int? id,
    @Path('userId') required int? userId,
  });

  ///
  ///@param id
  ///@param userId
  Future<chopper.Response> apiGamesIdLeaveUserIdPost({
    required int? id,
    required int? userId,
  }) {
    return _apiGamesIdLeaveUserIdPost(id: id, userId: userId);
  }

  ///
  ///@param id
  ///@param userId
  @Post(
    path: '/api/Games/{id}/leave/{userId}',
    optionalBody: true,
  )
  Future<chopper.Response> _apiGamesIdLeaveUserIdPost({
    @Path('id') required int? id,
    @Path('userId') required int? userId,
  });

  ///
  ///@param id
  Future<chopper.Response<List<AgentDto>>> apiGamesIdAiAgentsGet(
      {required int? id}) {
    generatedMapping.putIfAbsent(AgentDto, () => AgentDto.fromJsonFactory);

    return _apiGamesIdAiAgentsGet(id: id);
  }

  ///
  ///@param id
  @Get(path: '/api/Games/{id}/ai-agents')
  Future<chopper.Response<List<AgentDto>>> _apiGamesIdAiAgentsGet(
      {@Path('id') required int? id});

  ///
  ///@param id
  ///@param agentId
  Future<chopper.Response> apiGamesIdAddAgentIdPost({
    required int? id,
    required int? agentId,
    required JoinGameDto? body,
  }) {
    return _apiGamesIdAddAgentIdPost(id: id, agentId: agentId, body: body);
  }

  ///
  ///@param id
  ///@param agentId
  @Post(
    path: '/api/Games/{id}/add/{agentId}',
    optionalBody: true,
  )
  Future<chopper.Response> _apiGamesIdAddAgentIdPost({
    @Path('id') required int? id,
    @Path('agentId') required int? agentId,
    @Body() required JoinGameDto? body,
  });

  ///
  Future<chopper.Response<PurchaseResponseDto>>
      apiPaymentsCreateCheckoutSessionPost(
          {required PurchaseRequestDto? body}) {
    generatedMapping.putIfAbsent(
        PurchaseResponseDto, () => PurchaseResponseDto.fromJsonFactory);

    return _apiPaymentsCreateCheckoutSessionPost(body: body);
  }

  ///
  @Post(
    path: '/api/Payments/create-checkout-session',
    optionalBody: true,
  )
  Future<chopper.Response<PurchaseResponseDto>>
      _apiPaymentsCreateCheckoutSessionPost(
          {@Body() required PurchaseRequestDto? body});

  ///
  ///@param session_id
  ///@param itemId
  ///@param userId
  Future<chopper.Response> apiPaymentsSuccessGet({
    String? sessionId,
    int? itemId,
    int? userId,
  }) {
    return _apiPaymentsSuccessGet(
        sessionId: sessionId, itemId: itemId, userId: userId);
  }

  ///
  ///@param session_id
  ///@param itemId
  ///@param userId
  @Get(path: '/api/Payments/success')
  Future<chopper.Response> _apiPaymentsSuccessGet({
    @Query('session_id') String? sessionId,
    @Query('itemId') int? itemId,
    @Query('userId') int? userId,
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
  Future<chopper.Response<UserDto>> apiUsersSocialLoginPost(
      {required SocialLoginDto? body}) {
    generatedMapping.putIfAbsent(UserDto, () => UserDto.fromJsonFactory);

    return _apiUsersSocialLoginPost(body: body);
  }

  ///
  @Post(
    path: '/api/Users/social-login',
    optionalBody: true,
  )
  Future<chopper.Response<UserDto>> _apiUsersSocialLoginPost(
      {@Body() required SocialLoginDto? body});

  ///
  Future<chopper.Response<UserDto>> apiUsersChangeUsernamePost(
      {required ChangeUsernameDto? body}) {
    generatedMapping.putIfAbsent(UserDto, () => UserDto.fromJsonFactory);

    return _apiUsersChangeUsernamePost(body: body);
  }

  ///
  @Post(
    path: '/api/Users/change-username',
    optionalBody: true,
  )
  Future<chopper.Response<UserDto>> _apiUsersChangeUsernamePost(
      {@Body() required ChangeUsernameDto? body});

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
  ///@param userId
  Future<chopper.Response<UserDto>> apiUsersProfileUserIdGet(
      {required int? userId}) {
    generatedMapping.putIfAbsent(UserDto, () => UserDto.fromJsonFactory);

    return _apiUsersProfileUserIdGet(userId: userId);
  }

  ///
  ///@param userId
  @Get(path: '/api/Users/profile/{userId}')
  Future<chopper.Response<UserDto>> _apiUsersProfileUserIdGet(
      {@Path('userId') required int? userId});

  ///
  ///@param count
  Future<chopper.Response<List<LeaderboardView>>> apiUsersLeaderboardTopGet(
      {int? count}) {
    generatedMapping.putIfAbsent(
        LeaderboardView, () => LeaderboardView.fromJsonFactory);

    return _apiUsersLeaderboardTopGet(count: count);
  }

  ///
  ///@param count
  @Get(path: '/api/Users/leaderboard/top')
  Future<chopper.Response<List<LeaderboardView>>> _apiUsersLeaderboardTopGet(
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

  ///
  Future<chopper.Response<List<ShopItemDto>>> apiUsersShopGet() {
    generatedMapping.putIfAbsent(
        ShopItemDto, () => ShopItemDto.fromJsonFactory);

    return _apiUsersShopGet();
  }

  ///
  @Get(path: '/api/Users/shop')
  Future<chopper.Response<List<ShopItemDto>>> _apiUsersShopGet();

  ///
  ///@param userId
  Future<chopper.Response<List<ShopItemDto>>> apiUsersShopUserIdGet(
      {required int? userId}) {
    generatedMapping.putIfAbsent(
        ShopItemDto, () => ShopItemDto.fromJsonFactory);

    return _apiUsersShopUserIdGet(userId: userId);
  }

  ///
  ///@param userId
  @Get(path: '/api/Users/shop/{userId}')
  Future<chopper.Response<List<ShopItemDto>>> _apiUsersShopUserIdGet(
      {@Path('userId') required int? userId});

  ///
  Future<chopper.Response<List<ShopItemDto>>> apiUsersInventoryGet() {
    generatedMapping.putIfAbsent(
        ShopItemDto, () => ShopItemDto.fromJsonFactory);

    return _apiUsersInventoryGet();
  }

  ///
  @Get(path: '/api/Users/inventory')
  Future<chopper.Response<List<ShopItemDto>>> _apiUsersInventoryGet();

  ///
  ///@param userId
  Future<chopper.Response<List<ShopItemDto>>> apiUsersInventoryUserIdGet(
      {required int? userId}) {
    generatedMapping.putIfAbsent(
        ShopItemDto, () => ShopItemDto.fromJsonFactory);

    return _apiUsersInventoryUserIdGet(userId: userId);
  }

  ///
  ///@param userId
  @Get(path: '/api/Users/inventory/{userId}')
  Future<chopper.Response<List<ShopItemDto>>> _apiUsersInventoryUserIdGet(
      {@Path('userId') required int? userId});

  ///
  Future<chopper.Response<UserDto>> apiUsersSetItemPost(
      {required SelectItemDto? body}) {
    generatedMapping.putIfAbsent(UserDto, () => UserDto.fromJsonFactory);

    return _apiUsersSetItemPost(body: body);
  }

  ///
  @Post(
    path: '/api/Users/setItem',
    optionalBody: true,
  )
  Future<chopper.Response<UserDto>> _apiUsersSetItemPost(
      {@Body() required SelectItemDto? body});

  ///
  ///@param userId
  Future<chopper.Response<UserDto>> apiUsersSetItemUserIdPost({
    required int? userId,
    required SelectItemDto? body,
  }) {
    generatedMapping.putIfAbsent(UserDto, () => UserDto.fromJsonFactory);

    return _apiUsersSetItemUserIdPost(userId: userId, body: body);
  }

  ///
  ///@param userId
  @Post(
    path: '/api/Users/setItem/{userId}',
    optionalBody: true,
  )
  Future<chopper.Response<UserDto>> _apiUsersSetItemUserIdPost({
    @Path('userId') required int? userId,
    @Body() required SelectItemDto? body,
  });

  ///
  ///@param userId
  Future<chopper.Response<UserDto>> apiUsersAdd1KChipsUserIdPost(
      {required int? userId}) {
    generatedMapping.putIfAbsent(UserDto, () => UserDto.fromJsonFactory);

    return _apiUsersAdd1KChipsUserIdPost(userId: userId);
  }

  ///
  ///@param userId
  @Post(
    path: '/api/Users/Add1KChips/{userId}',
    optionalBody: true,
  )
  Future<chopper.Response<UserDto>> _apiUsersAdd1KChipsUserIdPost(
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
