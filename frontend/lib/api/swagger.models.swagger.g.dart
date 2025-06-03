// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swagger.models.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveGameDto _$ActiveGameDtoFromJson(Map<String, dynamic> json) =>
    ActiveGameDto(
      gameId: (json['gameId'] as num?)?.toInt() ?? 0,
      tableName: json['tableName'] as String?,
      tableDifficulty: json['tableDifficulty'] as String?,
    );

Map<String, dynamic> _$ActiveGameDtoToJson(ActiveGameDto instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'tableName': instance.tableName,
      'tableDifficulty': instance.tableDifficulty,
    };

AgentDto _$AgentDtoFromJson(Map<String, dynamic> json) => AgentDto(
      name: json['name'] as String?,
      difficulty: json['difficulty'] as String?,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      username: json['username'] as String?,
    );

Map<String, dynamic> _$AgentDtoToJson(AgentDto instance) => <String, dynamic>{
      'name': instance.name,
      'difficulty': instance.difficulty,
      'userId': instance.userId,
      'username': instance.username,
    };

CardDto _$CardDtoFromJson(Map<String, dynamic> json) => CardDto(
      suit: json['suit'] as String?,
      $value: json['value'] as String?,
    );

Map<String, dynamic> _$CardDtoToJson(CardDto instance) => <String, dynamic>{
      'suit': instance.suit,
      'value': instance.$value,
    };

ChooseUsernameDto _$ChooseUsernameDtoFromJson(Map<String, dynamic> json) =>
    ChooseUsernameDto(
      username: json['username'] as String?,
    );

Map<String, dynamic> _$ChooseUsernameDtoToJson(ChooseUsernameDto instance) =>
    <String, dynamic>{
      'username': instance.username,
    };

CreateGameDto _$CreateGameDtoFromJson(Map<String, dynamic> json) =>
    CreateGameDto(
      tableId: (json['tableId'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CreateGameDtoToJson(CreateGameDto instance) =>
    <String, dynamic>{
      'tableId': instance.tableId,
    };

GameStateDto _$GameStateDtoFromJson(Map<String, dynamic> json) => GameStateDto(
      gameId: (json['gameId'] as num?)?.toInt() ?? 0,
      tableId: (json['tableId'] as num?)?.toInt() ?? 0,
      tableName: json['tableName'] as String?,
      currentState: json['currentState'] as String?,
      potSize: (json['potSize'] as num?)?.toInt() ?? 0,
      currentTurnUserId: (json['currentTurnUserId'] as num?)?.toInt() ?? 0,
      communityCards: (json['communityCards'] as List<dynamic>?)
              ?.map((e) => CardDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      players: (json['players'] as List<dynamic>?)
              ?.map((e) => PlayerStateDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      playerCards: (json['playerCards'] as List<dynamic>?)
              ?.map((e) => CardDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lastMoves: (json['lastMoves'] as List<dynamic>?)
              ?.map((e) => MoveDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      roundWinners: (json['roundWinners'] as List<dynamic>?)
              ?.map((e) => RoundWinnerDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      playerRoundContributions:
          json['playerRoundContributions'] as Map<String, dynamic>?,
      callAmount: (json['callAmount'] as num?)?.toInt() ?? 0,
      minRaiseAmount: (json['minRaiseAmount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$GameStateDtoToJson(GameStateDto instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'tableId': instance.tableId,
      'tableName': instance.tableName,
      'currentState': instance.currentState,
      'potSize': instance.potSize,
      'currentTurnUserId': instance.currentTurnUserId,
      'communityCards':
          instance.communityCards?.map((e) => e.toJson()).toList(),
      'players': instance.players?.map((e) => e.toJson()).toList(),
      'playerCards': instance.playerCards?.map((e) => e.toJson()).toList(),
      'lastMoves': instance.lastMoves?.map((e) => e.toJson()).toList(),
      'roundWinners': instance.roundWinners?.map((e) => e.toJson()).toList(),
      'playerRoundContributions': instance.playerRoundContributions,
      'callAmount': instance.callAmount,
      'minRaiseAmount': instance.minRaiseAmount,
    };

JoinGameDto _$JoinGameDtoFromJson(Map<String, dynamic> json) => JoinGameDto(
      seatPosition: (json['seatPosition'] as num?)?.toInt() ?? 0,
      buyInAmount: (json['buyInAmount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$JoinGameDtoToJson(JoinGameDto instance) =>
    <String, dynamic>{
      'seatPosition': instance.seatPosition,
      'buyInAmount': instance.buyInAmount,
    };

LeaderboardView _$LeaderboardViewFromJson(Map<String, dynamic> json) =>
    LeaderboardView(
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      username: json['username'] as String?,
      chipsBalance: (json['chipsBalance'] as num?)?.toInt() ?? 0,
      avatarImage: json['avatarImage'] as String?,
      gamesWon: (json['gamesWon'] as num?)?.toInt() ?? 0,
      gamesPlayed: (json['gamesPlayed'] as num?)?.toInt() ?? 0,
      winRatio: (json['winRatio'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$LeaderboardViewToJson(LeaderboardView instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'chipsBalance': instance.chipsBalance,
      'avatarImage': instance.avatarImage,
      'gamesWon': instance.gamesWon,
      'gamesPlayed': instance.gamesPlayed,
      'winRatio': instance.winRatio,
    };

LoginDto _$LoginDtoFromJson(Map<String, dynamic> json) => LoginDto(
      username: json['username'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginDtoToJson(LoginDto instance) => <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

MakeMoveDto _$MakeMoveDtoFromJson(Map<String, dynamic> json) => MakeMoveDto(
      actionType: json['actionType'] as String,
      amount: (json['amount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MakeMoveDtoToJson(MakeMoveDto instance) =>
    <String, dynamic>{
      'actionType': instance.actionType,
      'amount': instance.amount,
    };

MoveDto _$MoveDtoFromJson(Map<String, dynamic> json) => MoveDto(
      playerId: (json['playerId'] as num?)?.toInt() ?? 0,
      actionType: json['actionType'] as String?,
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      moveTime: json['moveTime'] == null
          ? null
          : DateTime.parse(json['moveTime'] as String),
    );

Map<String, dynamic> _$MoveDtoToJson(MoveDto instance) => <String, dynamic>{
      'playerId': instance.playerId,
      'actionType': instance.actionType,
      'amount': instance.amount,
      'moveTime': instance.moveTime?.toIso8601String(),
    };

PlayerStateDto _$PlayerStateDtoFromJson(Map<String, dynamic> json) =>
    PlayerStateDto(
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      username: json['username'] as String?,
      currentChips: (json['currentChips'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? false,
      isDealer: json['isDealer'] as bool? ?? false,
      isSmallBlind: json['isSmallBlind'] as bool? ?? false,
      isBigBlind: json['isBigBlind'] as bool? ?? false,
      seatPosition: (json['seatPosition'] as num?)?.toInt() ?? 0,
      cards: (json['cards'] as List<dynamic>?)
              ?.map((e) => CardDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$PlayerStateDtoToJson(PlayerStateDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'currentChips': instance.currentChips,
      'isActive': instance.isActive,
      'isDealer': instance.isDealer,
      'isSmallBlind': instance.isSmallBlind,
      'isBigBlind': instance.isBigBlind,
      'seatPosition': instance.seatPosition,
      'cards': instance.cards?.map((e) => e.toJson()).toList(),
    };

RegisterDto _$RegisterDtoFromJson(Map<String, dynamic> json) => RegisterDto(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$RegisterDtoToJson(RegisterDto instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
    };

RoundWinnerDto _$RoundWinnerDtoFromJson(Map<String, dynamic> json) =>
    RoundWinnerDto(
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      username: json['username'] as String?,
      amountWon: (json['amountWon'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RoundWinnerDtoToJson(RoundWinnerDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'amountWon': instance.amountWon,
    };

SocialLoginDto _$SocialLoginDtoFromJson(Map<String, dynamic> json) =>
    SocialLoginDto(
      provider: json['provider'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$SocialLoginDtoToJson(SocialLoginDto instance) =>
    <String, dynamic>{
      'provider': instance.provider,
      'token': instance.token,
    };

UpdateProfileDto _$UpdateProfileDtoFromJson(Map<String, dynamic> json) =>
    UpdateProfileDto(
      email: json['email'] as String?,
      avatarImage: json['avatarImage'] as String?,
    );

Map<String, dynamic> _$UpdateProfileDtoToJson(UpdateProfileDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'avatarImage': instance.avatarImage,
    };

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      username: json['username'] as String?,
      email: json['email'] as String?,
      chipsBalance: (json['chipsBalance'] as num?)?.toInt() ?? 0,
      avatarImage: json['avatarImage'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'email': instance.email,
      'chipsBalance': instance.chipsBalance,
      'avatarImage': instance.avatarImage,
      'token': instance.token,
    };
