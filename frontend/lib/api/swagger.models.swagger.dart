// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:convert';

part 'swagger.models.swagger.g.dart';

@JsonSerializable(explicitToJson: true)
class ActiveGameDto {
  const ActiveGameDto({
    this.gameId,
    this.tableName,
    this.tableDifficulty,
  });

  factory ActiveGameDto.fromJson(Map<String, dynamic> json) =>
      _$ActiveGameDtoFromJson(json);

  static const toJsonFactory = _$ActiveGameDtoToJson;
  Map<String, dynamic> toJson() => _$ActiveGameDtoToJson(this);

  @JsonKey(name: 'gameId', defaultValue: 0)
  final int? gameId;
  @JsonKey(name: 'tableName')
  final String? tableName;
  @JsonKey(name: 'tableDifficulty')
  final String? tableDifficulty;
  static const fromJsonFactory = _$ActiveGameDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ActiveGameDto &&
            (identical(other.gameId, gameId) ||
                const DeepCollectionEquality().equals(other.gameId, gameId)) &&
            (identical(other.tableName, tableName) ||
                const DeepCollectionEquality()
                    .equals(other.tableName, tableName)) &&
            (identical(other.tableDifficulty, tableDifficulty) ||
                const DeepCollectionEquality()
                    .equals(other.tableDifficulty, tableDifficulty)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(gameId) ^
      const DeepCollectionEquality().hash(tableName) ^
      const DeepCollectionEquality().hash(tableDifficulty) ^
      runtimeType.hashCode;
}

extension $ActiveGameDtoExtension on ActiveGameDto {
  ActiveGameDto copyWith(
      {int? gameId, String? tableName, String? tableDifficulty}) {
    return ActiveGameDto(
        gameId: gameId ?? this.gameId,
        tableName: tableName ?? this.tableName,
        tableDifficulty: tableDifficulty ?? this.tableDifficulty);
  }

  ActiveGameDto copyWithWrapped(
      {Wrapped<int?>? gameId,
      Wrapped<String?>? tableName,
      Wrapped<String?>? tableDifficulty}) {
    return ActiveGameDto(
        gameId: (gameId != null ? gameId.value : this.gameId),
        tableName: (tableName != null ? tableName.value : this.tableName),
        tableDifficulty: (tableDifficulty != null
            ? tableDifficulty.value
            : this.tableDifficulty));
  }
}

@JsonSerializable(explicitToJson: true)
class AgentDto {
  const AgentDto({
    this.name,
    this.difficulty,
    this.userId,
    this.username,
  });

  factory AgentDto.fromJson(Map<String, dynamic> json) =>
      _$AgentDtoFromJson(json);

  static const toJsonFactory = _$AgentDtoToJson;
  Map<String, dynamic> toJson() => _$AgentDtoToJson(this);

  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'difficulty')
  final String? difficulty;
  @JsonKey(name: 'userId', defaultValue: 0)
  final int? userId;
  @JsonKey(name: 'username')
  final String? username;
  static const fromJsonFactory = _$AgentDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AgentDto &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.difficulty, difficulty) ||
                const DeepCollectionEquality()
                    .equals(other.difficulty, difficulty)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(difficulty) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(username) ^
      runtimeType.hashCode;
}

extension $AgentDtoExtension on AgentDto {
  AgentDto copyWith(
      {String? name, String? difficulty, int? userId, String? username}) {
    return AgentDto(
        name: name ?? this.name,
        difficulty: difficulty ?? this.difficulty,
        userId: userId ?? this.userId,
        username: username ?? this.username);
  }

  AgentDto copyWithWrapped(
      {Wrapped<String?>? name,
      Wrapped<String?>? difficulty,
      Wrapped<int?>? userId,
      Wrapped<String?>? username}) {
    return AgentDto(
        name: (name != null ? name.value : this.name),
        difficulty: (difficulty != null ? difficulty.value : this.difficulty),
        userId: (userId != null ? userId.value : this.userId),
        username: (username != null ? username.value : this.username));
  }
}

@JsonSerializable(explicitToJson: true)
class CardDto {
  const CardDto({
    this.suit,
    this.$value,
  });

  factory CardDto.fromJson(Map<String, dynamic> json) =>
      _$CardDtoFromJson(json);

  static const toJsonFactory = _$CardDtoToJson;
  Map<String, dynamic> toJson() => _$CardDtoToJson(this);

  @JsonKey(name: 'suit')
  final String? suit;
  @JsonKey(name: 'value')
  final String? $value;
  static const fromJsonFactory = _$CardDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CardDto &&
            (identical(other.suit, suit) ||
                const DeepCollectionEquality().equals(other.suit, suit)) &&
            (identical(other.$value, $value) ||
                const DeepCollectionEquality().equals(other.$value, $value)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(suit) ^
      const DeepCollectionEquality().hash($value) ^
      runtimeType.hashCode;
}

extension $CardDtoExtension on CardDto {
  CardDto copyWith({String? suit, String? $value}) {
    return CardDto(suit: suit ?? this.suit, $value: $value ?? this.$value);
  }

  CardDto copyWithWrapped({Wrapped<String?>? suit, Wrapped<String?>? $value}) {
    return CardDto(
        suit: (suit != null ? suit.value : this.suit),
        $value: ($value != null ? $value.value : this.$value));
  }
}

@JsonSerializable(explicitToJson: true)
class ChangeUsernameDto {
  const ChangeUsernameDto({
    this.userId,
    this.username,
  });

  factory ChangeUsernameDto.fromJson(Map<String, dynamic> json) =>
      _$ChangeUsernameDtoFromJson(json);

  static const toJsonFactory = _$ChangeUsernameDtoToJson;
  Map<String, dynamic> toJson() => _$ChangeUsernameDtoToJson(this);

  @JsonKey(name: 'userId', defaultValue: 0)
  final int? userId;
  @JsonKey(name: 'username')
  final String? username;
  static const fromJsonFactory = _$ChangeUsernameDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ChangeUsernameDto &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(username) ^
      runtimeType.hashCode;
}

extension $ChangeUsernameDtoExtension on ChangeUsernameDto {
  ChangeUsernameDto copyWith({int? userId, String? username}) {
    return ChangeUsernameDto(
        userId: userId ?? this.userId, username: username ?? this.username);
  }

  ChangeUsernameDto copyWithWrapped(
      {Wrapped<int?>? userId, Wrapped<String?>? username}) {
    return ChangeUsernameDto(
        userId: (userId != null ? userId.value : this.userId),
        username: (username != null ? username.value : this.username));
  }
}

@JsonSerializable(explicitToJson: true)
class CreateGameDto {
  const CreateGameDto({
    required this.tableId,
  });

  factory CreateGameDto.fromJson(Map<String, dynamic> json) =>
      _$CreateGameDtoFromJson(json);

  static const toJsonFactory = _$CreateGameDtoToJson;
  Map<String, dynamic> toJson() => _$CreateGameDtoToJson(this);

  @JsonKey(name: 'tableId', defaultValue: 0)
  final int tableId;
  static const fromJsonFactory = _$CreateGameDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateGameDto &&
            (identical(other.tableId, tableId) ||
                const DeepCollectionEquality().equals(other.tableId, tableId)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(tableId) ^ runtimeType.hashCode;
}

extension $CreateGameDtoExtension on CreateGameDto {
  CreateGameDto copyWith({int? tableId}) {
    return CreateGameDto(tableId: tableId ?? this.tableId);
  }

  CreateGameDto copyWithWrapped({Wrapped<int>? tableId}) {
    return CreateGameDto(
        tableId: (tableId != null ? tableId.value : this.tableId));
  }
}

@JsonSerializable(explicitToJson: true)
class GameStateDto {
  const GameStateDto({
    this.gameId,
    this.tableId,
    this.tableName,
    this.currentState,
    this.potSize,
    this.currentTurnUserId,
    this.communityCards,
    this.players,
    this.playerCards,
    this.lastMoves,
    this.roundWinners,
    this.playerRoundContributions,
    this.callAmount,
    this.minRaiseAmount,
  });

  factory GameStateDto.fromJson(Map<String, dynamic> json) =>
      _$GameStateDtoFromJson(json);

  static const toJsonFactory = _$GameStateDtoToJson;
  Map<String, dynamic> toJson() => _$GameStateDtoToJson(this);

  @JsonKey(name: 'gameId', defaultValue: 0)
  final int? gameId;
  @JsonKey(name: 'tableId', defaultValue: 0)
  final int? tableId;
  @JsonKey(name: 'tableName')
  final String? tableName;
  @JsonKey(name: 'currentState')
  final String? currentState;
  @JsonKey(name: 'potSize', defaultValue: 0)
  final int? potSize;
  @JsonKey(name: 'currentTurnUserId', defaultValue: 0)
  final int? currentTurnUserId;
  @JsonKey(name: 'communityCards', defaultValue: <CardDto>[])
  final List<CardDto>? communityCards;
  @JsonKey(name: 'players', defaultValue: <PlayerStateDto>[])
  final List<PlayerStateDto>? players;
  @JsonKey(name: 'playerCards', defaultValue: <CardDto>[])
  final List<CardDto>? playerCards;
  @JsonKey(name: 'lastMoves', defaultValue: <MoveDto>[])
  final List<MoveDto>? lastMoves;
  @JsonKey(name: 'roundWinners', defaultValue: <RoundWinnerDto>[])
  final List<RoundWinnerDto>? roundWinners;
  @JsonKey(name: 'playerRoundContributions')
  final Map<String, dynamic>? playerRoundContributions;
  @JsonKey(name: 'callAmount', defaultValue: 0)
  final int? callAmount;
  @JsonKey(name: 'minRaiseAmount', defaultValue: 0)
  final int? minRaiseAmount;
  static const fromJsonFactory = _$GameStateDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GameStateDto &&
            (identical(other.gameId, gameId) ||
                const DeepCollectionEquality().equals(other.gameId, gameId)) &&
            (identical(other.tableId, tableId) ||
                const DeepCollectionEquality()
                    .equals(other.tableId, tableId)) &&
            (identical(other.tableName, tableName) ||
                const DeepCollectionEquality()
                    .equals(other.tableName, tableName)) &&
            (identical(other.currentState, currentState) ||
                const DeepCollectionEquality()
                    .equals(other.currentState, currentState)) &&
            (identical(other.potSize, potSize) ||
                const DeepCollectionEquality()
                    .equals(other.potSize, potSize)) &&
            (identical(other.currentTurnUserId, currentTurnUserId) ||
                const DeepCollectionEquality()
                    .equals(other.currentTurnUserId, currentTurnUserId)) &&
            (identical(other.communityCards, communityCards) ||
                const DeepCollectionEquality()
                    .equals(other.communityCards, communityCards)) &&
            (identical(other.players, players) ||
                const DeepCollectionEquality()
                    .equals(other.players, players)) &&
            (identical(other.playerCards, playerCards) ||
                const DeepCollectionEquality()
                    .equals(other.playerCards, playerCards)) &&
            (identical(other.lastMoves, lastMoves) ||
                const DeepCollectionEquality()
                    .equals(other.lastMoves, lastMoves)) &&
            (identical(other.roundWinners, roundWinners) ||
                const DeepCollectionEquality()
                    .equals(other.roundWinners, roundWinners)) &&
            (identical(
                    other.playerRoundContributions, playerRoundContributions) ||
                const DeepCollectionEquality().equals(
                    other.playerRoundContributions,
                    playerRoundContributions)) &&
            (identical(other.callAmount, callAmount) ||
                const DeepCollectionEquality()
                    .equals(other.callAmount, callAmount)) &&
            (identical(other.minRaiseAmount, minRaiseAmount) ||
                const DeepCollectionEquality()
                    .equals(other.minRaiseAmount, minRaiseAmount)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(gameId) ^
      const DeepCollectionEquality().hash(tableId) ^
      const DeepCollectionEquality().hash(tableName) ^
      const DeepCollectionEquality().hash(currentState) ^
      const DeepCollectionEquality().hash(potSize) ^
      const DeepCollectionEquality().hash(currentTurnUserId) ^
      const DeepCollectionEquality().hash(communityCards) ^
      const DeepCollectionEquality().hash(players) ^
      const DeepCollectionEquality().hash(playerCards) ^
      const DeepCollectionEquality().hash(lastMoves) ^
      const DeepCollectionEquality().hash(roundWinners) ^
      const DeepCollectionEquality().hash(playerRoundContributions) ^
      const DeepCollectionEquality().hash(callAmount) ^
      const DeepCollectionEquality().hash(minRaiseAmount) ^
      runtimeType.hashCode;
}

extension $GameStateDtoExtension on GameStateDto {
  GameStateDto copyWith(
      {int? gameId,
      int? tableId,
      String? tableName,
      String? currentState,
      int? potSize,
      int? currentTurnUserId,
      List<CardDto>? communityCards,
      List<PlayerStateDto>? players,
      List<CardDto>? playerCards,
      List<MoveDto>? lastMoves,
      List<RoundWinnerDto>? roundWinners,
      Map<String, dynamic>? playerRoundContributions,
      int? callAmount,
      int? minRaiseAmount}) {
    return GameStateDto(
        gameId: gameId ?? this.gameId,
        tableId: tableId ?? this.tableId,
        tableName: tableName ?? this.tableName,
        currentState: currentState ?? this.currentState,
        potSize: potSize ?? this.potSize,
        currentTurnUserId: currentTurnUserId ?? this.currentTurnUserId,
        communityCards: communityCards ?? this.communityCards,
        players: players ?? this.players,
        playerCards: playerCards ?? this.playerCards,
        lastMoves: lastMoves ?? this.lastMoves,
        roundWinners: roundWinners ?? this.roundWinners,
        playerRoundContributions:
            playerRoundContributions ?? this.playerRoundContributions,
        callAmount: callAmount ?? this.callAmount,
        minRaiseAmount: minRaiseAmount ?? this.minRaiseAmount);
  }

  GameStateDto copyWithWrapped(
      {Wrapped<int?>? gameId,
      Wrapped<int?>? tableId,
      Wrapped<String?>? tableName,
      Wrapped<String?>? currentState,
      Wrapped<int?>? potSize,
      Wrapped<int?>? currentTurnUserId,
      Wrapped<List<CardDto>?>? communityCards,
      Wrapped<List<PlayerStateDto>?>? players,
      Wrapped<List<CardDto>?>? playerCards,
      Wrapped<List<MoveDto>?>? lastMoves,
      Wrapped<List<RoundWinnerDto>?>? roundWinners,
      Wrapped<Map<String, dynamic>?>? playerRoundContributions,
      Wrapped<int?>? callAmount,
      Wrapped<int?>? minRaiseAmount}) {
    return GameStateDto(
        gameId: (gameId != null ? gameId.value : this.gameId),
        tableId: (tableId != null ? tableId.value : this.tableId),
        tableName: (tableName != null ? tableName.value : this.tableName),
        currentState:
            (currentState != null ? currentState.value : this.currentState),
        potSize: (potSize != null ? potSize.value : this.potSize),
        currentTurnUserId: (currentTurnUserId != null
            ? currentTurnUserId.value
            : this.currentTurnUserId),
        communityCards: (communityCards != null
            ? communityCards.value
            : this.communityCards),
        players: (players != null ? players.value : this.players),
        playerCards:
            (playerCards != null ? playerCards.value : this.playerCards),
        lastMoves: (lastMoves != null ? lastMoves.value : this.lastMoves),
        roundWinners:
            (roundWinners != null ? roundWinners.value : this.roundWinners),
        playerRoundContributions: (playerRoundContributions != null
            ? playerRoundContributions.value
            : this.playerRoundContributions),
        callAmount: (callAmount != null ? callAmount.value : this.callAmount),
        minRaiseAmount: (minRaiseAmount != null
            ? minRaiseAmount.value
            : this.minRaiseAmount));
  }
}

@JsonSerializable(explicitToJson: true)
class HintDto {
  const HintDto({
    this.modelName,
    this.move,
    this.difficulty,
  });

  factory HintDto.fromJson(Map<String, dynamic> json) =>
      _$HintDtoFromJson(json);

  static const toJsonFactory = _$HintDtoToJson;
  Map<String, dynamic> toJson() => _$HintDtoToJson(this);

  @JsonKey(name: 'modelName')
  final String? modelName;
  @JsonKey(name: 'move')
  final String? move;
  @JsonKey(name: 'difficulty')
  final String? difficulty;
  static const fromJsonFactory = _$HintDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is HintDto &&
            (identical(other.modelName, modelName) ||
                const DeepCollectionEquality()
                    .equals(other.modelName, modelName)) &&
            (identical(other.move, move) ||
                const DeepCollectionEquality().equals(other.move, move)) &&
            (identical(other.difficulty, difficulty) ||
                const DeepCollectionEquality()
                    .equals(other.difficulty, difficulty)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(modelName) ^
      const DeepCollectionEquality().hash(move) ^
      const DeepCollectionEquality().hash(difficulty) ^
      runtimeType.hashCode;
}

extension $HintDtoExtension on HintDto {
  HintDto copyWith({String? modelName, String? move, String? difficulty}) {
    return HintDto(
        modelName: modelName ?? this.modelName,
        move: move ?? this.move,
        difficulty: difficulty ?? this.difficulty);
  }

  HintDto copyWithWrapped(
      {Wrapped<String?>? modelName,
      Wrapped<String?>? move,
      Wrapped<String?>? difficulty}) {
    return HintDto(
        modelName: (modelName != null ? modelName.value : this.modelName),
        move: (move != null ? move.value : this.move),
        difficulty: (difficulty != null ? difficulty.value : this.difficulty));
  }
}

@JsonSerializable(explicitToJson: true)
class JoinGameDto {
  const JoinGameDto({
    required this.seatPosition,
    required this.buyInAmount,
  });

  factory JoinGameDto.fromJson(Map<String, dynamic> json) =>
      _$JoinGameDtoFromJson(json);

  static const toJsonFactory = _$JoinGameDtoToJson;
  Map<String, dynamic> toJson() => _$JoinGameDtoToJson(this);

  @JsonKey(name: 'seatPosition', defaultValue: 0)
  final int seatPosition;
  @JsonKey(name: 'buyInAmount', defaultValue: 0)
  final int buyInAmount;
  static const fromJsonFactory = _$JoinGameDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is JoinGameDto &&
            (identical(other.seatPosition, seatPosition) ||
                const DeepCollectionEquality()
                    .equals(other.seatPosition, seatPosition)) &&
            (identical(other.buyInAmount, buyInAmount) ||
                const DeepCollectionEquality()
                    .equals(other.buyInAmount, buyInAmount)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(seatPosition) ^
      const DeepCollectionEquality().hash(buyInAmount) ^
      runtimeType.hashCode;
}

extension $JoinGameDtoExtension on JoinGameDto {
  JoinGameDto copyWith({int? seatPosition, int? buyInAmount}) {
    return JoinGameDto(
        seatPosition: seatPosition ?? this.seatPosition,
        buyInAmount: buyInAmount ?? this.buyInAmount);
  }

  JoinGameDto copyWithWrapped(
      {Wrapped<int>? seatPosition, Wrapped<int>? buyInAmount}) {
    return JoinGameDto(
        seatPosition:
            (seatPosition != null ? seatPosition.value : this.seatPosition),
        buyInAmount:
            (buyInAmount != null ? buyInAmount.value : this.buyInAmount));
  }
}

@JsonSerializable(explicitToJson: true)
class LeaderboardView {
  const LeaderboardView({
    this.userId,
    this.username,
    this.chipsBalance,
    this.avatarImage,
    this.gamesWon,
    this.gamesPlayed,
    this.winRatio,
  });

  factory LeaderboardView.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardViewFromJson(json);

  static const toJsonFactory = _$LeaderboardViewToJson;
  Map<String, dynamic> toJson() => _$LeaderboardViewToJson(this);

  @JsonKey(name: 'userId', defaultValue: 0)
  final int? userId;
  @JsonKey(name: 'username')
  final String? username;
  @JsonKey(name: 'chipsBalance', defaultValue: 0)
  final int? chipsBalance;
  @JsonKey(name: 'avatarImage')
  final String? avatarImage;
  @JsonKey(name: 'gamesWon', defaultValue: 0)
  final int? gamesWon;
  @JsonKey(name: 'gamesPlayed', defaultValue: 0)
  final int? gamesPlayed;
  @JsonKey(name: 'winRatio')
  final double? winRatio;
  static const fromJsonFactory = _$LeaderboardViewFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LeaderboardView &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)) &&
            (identical(other.chipsBalance, chipsBalance) ||
                const DeepCollectionEquality()
                    .equals(other.chipsBalance, chipsBalance)) &&
            (identical(other.avatarImage, avatarImage) ||
                const DeepCollectionEquality()
                    .equals(other.avatarImage, avatarImage)) &&
            (identical(other.gamesWon, gamesWon) ||
                const DeepCollectionEquality()
                    .equals(other.gamesWon, gamesWon)) &&
            (identical(other.gamesPlayed, gamesPlayed) ||
                const DeepCollectionEquality()
                    .equals(other.gamesPlayed, gamesPlayed)) &&
            (identical(other.winRatio, winRatio) ||
                const DeepCollectionEquality()
                    .equals(other.winRatio, winRatio)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(chipsBalance) ^
      const DeepCollectionEquality().hash(avatarImage) ^
      const DeepCollectionEquality().hash(gamesWon) ^
      const DeepCollectionEquality().hash(gamesPlayed) ^
      const DeepCollectionEquality().hash(winRatio) ^
      runtimeType.hashCode;
}

extension $LeaderboardViewExtension on LeaderboardView {
  LeaderboardView copyWith(
      {int? userId,
      String? username,
      int? chipsBalance,
      String? avatarImage,
      int? gamesWon,
      int? gamesPlayed,
      double? winRatio}) {
    return LeaderboardView(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        chipsBalance: chipsBalance ?? this.chipsBalance,
        avatarImage: avatarImage ?? this.avatarImage,
        gamesWon: gamesWon ?? this.gamesWon,
        gamesPlayed: gamesPlayed ?? this.gamesPlayed,
        winRatio: winRatio ?? this.winRatio);
  }

  LeaderboardView copyWithWrapped(
      {Wrapped<int?>? userId,
      Wrapped<String?>? username,
      Wrapped<int?>? chipsBalance,
      Wrapped<String?>? avatarImage,
      Wrapped<int?>? gamesWon,
      Wrapped<int?>? gamesPlayed,
      Wrapped<double?>? winRatio}) {
    return LeaderboardView(
        userId: (userId != null ? userId.value : this.userId),
        username: (username != null ? username.value : this.username),
        chipsBalance:
            (chipsBalance != null ? chipsBalance.value : this.chipsBalance),
        avatarImage:
            (avatarImage != null ? avatarImage.value : this.avatarImage),
        gamesWon: (gamesWon != null ? gamesWon.value : this.gamesWon),
        gamesPlayed:
            (gamesPlayed != null ? gamesPlayed.value : this.gamesPlayed),
        winRatio: (winRatio != null ? winRatio.value : this.winRatio));
  }
}

@JsonSerializable(explicitToJson: true)
class LoginDto {
  const LoginDto({
    required this.username,
    required this.password,
  });

  factory LoginDto.fromJson(Map<String, dynamic> json) =>
      _$LoginDtoFromJson(json);

  static const toJsonFactory = _$LoginDtoToJson;
  Map<String, dynamic> toJson() => _$LoginDtoToJson(this);

  @JsonKey(name: 'username')
  final String username;
  @JsonKey(name: 'password')
  final String password;
  static const fromJsonFactory = _$LoginDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LoginDto &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(password) ^
      runtimeType.hashCode;
}

extension $LoginDtoExtension on LoginDto {
  LoginDto copyWith({String? username, String? password}) {
    return LoginDto(
        username: username ?? this.username,
        password: password ?? this.password);
  }

  LoginDto copyWithWrapped(
      {Wrapped<String>? username, Wrapped<String>? password}) {
    return LoginDto(
        username: (username != null ? username.value : this.username),
        password: (password != null ? password.value : this.password));
  }
}

@JsonSerializable(explicitToJson: true)
class MakeMoveDto {
  const MakeMoveDto({
    required this.actionType,
    this.amount,
  });

  factory MakeMoveDto.fromJson(Map<String, dynamic> json) =>
      _$MakeMoveDtoFromJson(json);

  static const toJsonFactory = _$MakeMoveDtoToJson;
  Map<String, dynamic> toJson() => _$MakeMoveDtoToJson(this);

  @JsonKey(name: 'actionType')
  final String actionType;
  @JsonKey(name: 'amount', defaultValue: 0)
  final int? amount;
  static const fromJsonFactory = _$MakeMoveDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MakeMoveDto &&
            (identical(other.actionType, actionType) ||
                const DeepCollectionEquality()
                    .equals(other.actionType, actionType)) &&
            (identical(other.amount, amount) ||
                const DeepCollectionEquality().equals(other.amount, amount)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(actionType) ^
      const DeepCollectionEquality().hash(amount) ^
      runtimeType.hashCode;
}

extension $MakeMoveDtoExtension on MakeMoveDto {
  MakeMoveDto copyWith({String? actionType, int? amount}) {
    return MakeMoveDto(
        actionType: actionType ?? this.actionType,
        amount: amount ?? this.amount);
  }

  MakeMoveDto copyWithWrapped(
      {Wrapped<String>? actionType, Wrapped<int?>? amount}) {
    return MakeMoveDto(
        actionType: (actionType != null ? actionType.value : this.actionType),
        amount: (amount != null ? amount.value : this.amount));
  }
}

@JsonSerializable(explicitToJson: true)
class MoveDto {
  const MoveDto({
    this.playerId,
    this.actionType,
    this.amount,
    this.moveTime,
  });

  factory MoveDto.fromJson(Map<String, dynamic> json) =>
      _$MoveDtoFromJson(json);

  static const toJsonFactory = _$MoveDtoToJson;
  Map<String, dynamic> toJson() => _$MoveDtoToJson(this);

  @JsonKey(name: 'playerId', defaultValue: 0)
  final int? playerId;
  @JsonKey(name: 'actionType')
  final String? actionType;
  @JsonKey(name: 'amount', defaultValue: 0)
  final int? amount;
  @JsonKey(name: 'moveTime')
  final DateTime? moveTime;
  static const fromJsonFactory = _$MoveDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MoveDto &&
            (identical(other.playerId, playerId) ||
                const DeepCollectionEquality()
                    .equals(other.playerId, playerId)) &&
            (identical(other.actionType, actionType) ||
                const DeepCollectionEquality()
                    .equals(other.actionType, actionType)) &&
            (identical(other.amount, amount) ||
                const DeepCollectionEquality().equals(other.amount, amount)) &&
            (identical(other.moveTime, moveTime) ||
                const DeepCollectionEquality()
                    .equals(other.moveTime, moveTime)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(playerId) ^
      const DeepCollectionEquality().hash(actionType) ^
      const DeepCollectionEquality().hash(amount) ^
      const DeepCollectionEquality().hash(moveTime) ^
      runtimeType.hashCode;
}

extension $MoveDtoExtension on MoveDto {
  MoveDto copyWith(
      {int? playerId, String? actionType, int? amount, DateTime? moveTime}) {
    return MoveDto(
        playerId: playerId ?? this.playerId,
        actionType: actionType ?? this.actionType,
        amount: amount ?? this.amount,
        moveTime: moveTime ?? this.moveTime);
  }

  MoveDto copyWithWrapped(
      {Wrapped<int?>? playerId,
      Wrapped<String?>? actionType,
      Wrapped<int?>? amount,
      Wrapped<DateTime?>? moveTime}) {
    return MoveDto(
        playerId: (playerId != null ? playerId.value : this.playerId),
        actionType: (actionType != null ? actionType.value : this.actionType),
        amount: (amount != null ? amount.value : this.amount),
        moveTime: (moveTime != null ? moveTime.value : this.moveTime));
  }
}

@JsonSerializable(explicitToJson: true)
class PlayerStateDto {
  const PlayerStateDto({
    this.userId,
    this.username,
    this.avatar,
    this.currentChips,
    this.isActive,
    this.isDealer,
    this.isSmallBlind,
    this.isBigBlind,
    this.seatPosition,
    this.cards,
  });

  factory PlayerStateDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerStateDtoFromJson(json);

  static const toJsonFactory = _$PlayerStateDtoToJson;
  Map<String, dynamic> toJson() => _$PlayerStateDtoToJson(this);

  @JsonKey(name: 'userId', defaultValue: 0)
  final int? userId;
  @JsonKey(name: 'username')
  final String? username;
  @JsonKey(name: 'avatar')
  final String? avatar;
  @JsonKey(name: 'currentChips', defaultValue: 0)
  final int? currentChips;
  @JsonKey(name: 'isActive', defaultValue: false)
  final bool? isActive;
  @JsonKey(name: 'isDealer', defaultValue: false)
  final bool? isDealer;
  @JsonKey(name: 'isSmallBlind', defaultValue: false)
  final bool? isSmallBlind;
  @JsonKey(name: 'isBigBlind', defaultValue: false)
  final bool? isBigBlind;
  @JsonKey(name: 'seatPosition', defaultValue: 0)
  final int? seatPosition;
  @JsonKey(name: 'cards', defaultValue: <CardDto>[])
  final List<CardDto>? cards;
  static const fromJsonFactory = _$PlayerStateDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PlayerStateDto &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)) &&
            (identical(other.avatar, avatar) ||
                const DeepCollectionEquality().equals(other.avatar, avatar)) &&
            (identical(other.currentChips, currentChips) ||
                const DeepCollectionEquality()
                    .equals(other.currentChips, currentChips)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.isDealer, isDealer) ||
                const DeepCollectionEquality()
                    .equals(other.isDealer, isDealer)) &&
            (identical(other.isSmallBlind, isSmallBlind) ||
                const DeepCollectionEquality()
                    .equals(other.isSmallBlind, isSmallBlind)) &&
            (identical(other.isBigBlind, isBigBlind) ||
                const DeepCollectionEquality()
                    .equals(other.isBigBlind, isBigBlind)) &&
            (identical(other.seatPosition, seatPosition) ||
                const DeepCollectionEquality()
                    .equals(other.seatPosition, seatPosition)) &&
            (identical(other.cards, cards) ||
                const DeepCollectionEquality().equals(other.cards, cards)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(avatar) ^
      const DeepCollectionEquality().hash(currentChips) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(isDealer) ^
      const DeepCollectionEquality().hash(isSmallBlind) ^
      const DeepCollectionEquality().hash(isBigBlind) ^
      const DeepCollectionEquality().hash(seatPosition) ^
      const DeepCollectionEquality().hash(cards) ^
      runtimeType.hashCode;
}

extension $PlayerStateDtoExtension on PlayerStateDto {
  PlayerStateDto copyWith(
      {int? userId,
      String? username,
      String? avatar,
      int? currentChips,
      bool? isActive,
      bool? isDealer,
      bool? isSmallBlind,
      bool? isBigBlind,
      int? seatPosition,
      List<CardDto>? cards}) {
    return PlayerStateDto(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        avatar: avatar ?? this.avatar,
        currentChips: currentChips ?? this.currentChips,
        isActive: isActive ?? this.isActive,
        isDealer: isDealer ?? this.isDealer,
        isSmallBlind: isSmallBlind ?? this.isSmallBlind,
        isBigBlind: isBigBlind ?? this.isBigBlind,
        seatPosition: seatPosition ?? this.seatPosition,
        cards: cards ?? this.cards);
  }

  PlayerStateDto copyWithWrapped(
      {Wrapped<int?>? userId,
      Wrapped<String?>? username,
      Wrapped<String?>? avatar,
      Wrapped<int?>? currentChips,
      Wrapped<bool?>? isActive,
      Wrapped<bool?>? isDealer,
      Wrapped<bool?>? isSmallBlind,
      Wrapped<bool?>? isBigBlind,
      Wrapped<int?>? seatPosition,
      Wrapped<List<CardDto>?>? cards}) {
    return PlayerStateDto(
        userId: (userId != null ? userId.value : this.userId),
        username: (username != null ? username.value : this.username),
        avatar: (avatar != null ? avatar.value : this.avatar),
        currentChips:
            (currentChips != null ? currentChips.value : this.currentChips),
        isActive: (isActive != null ? isActive.value : this.isActive),
        isDealer: (isDealer != null ? isDealer.value : this.isDealer),
        isSmallBlind:
            (isSmallBlind != null ? isSmallBlind.value : this.isSmallBlind),
        isBigBlind: (isBigBlind != null ? isBigBlind.value : this.isBigBlind),
        seatPosition:
            (seatPosition != null ? seatPosition.value : this.seatPosition),
        cards: (cards != null ? cards.value : this.cards));
  }
}

@JsonSerializable(explicitToJson: true)
class PurchaseRequest {
  const PurchaseRequest({
    this.itemId,
  });

  factory PurchaseRequest.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRequestFromJson(json);

  static const toJsonFactory = _$PurchaseRequestToJson;
  Map<String, dynamic> toJson() => _$PurchaseRequestToJson(this);

  @JsonKey(name: 'itemId', defaultValue: 0)
  final int? itemId;
  static const fromJsonFactory = _$PurchaseRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PurchaseRequest &&
            (identical(other.itemId, itemId) ||
                const DeepCollectionEquality().equals(other.itemId, itemId)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(itemId) ^ runtimeType.hashCode;
}

extension $PurchaseRequestExtension on PurchaseRequest {
  PurchaseRequest copyWith({int? itemId}) {
    return PurchaseRequest(itemId: itemId ?? this.itemId);
  }

  PurchaseRequest copyWithWrapped({Wrapped<int?>? itemId}) {
    return PurchaseRequest(
        itemId: (itemId != null ? itemId.value : this.itemId));
  }
}

@JsonSerializable(explicitToJson: true)
class RegisterDto {
  const RegisterDto({
    required this.username,
    required this.email,
    required this.password,
  });

  factory RegisterDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterDtoFromJson(json);

  static const toJsonFactory = _$RegisterDtoToJson;
  Map<String, dynamic> toJson() => _$RegisterDtoToJson(this);

  @JsonKey(name: 'username')
  final String username;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'password')
  final String password;
  static const fromJsonFactory = _$RegisterDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RegisterDto &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(password) ^
      runtimeType.hashCode;
}

extension $RegisterDtoExtension on RegisterDto {
  RegisterDto copyWith({String? username, String? email, String? password}) {
    return RegisterDto(
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password);
  }

  RegisterDto copyWithWrapped(
      {Wrapped<String>? username,
      Wrapped<String>? email,
      Wrapped<String>? password}) {
    return RegisterDto(
        username: (username != null ? username.value : this.username),
        email: (email != null ? email.value : this.email),
        password: (password != null ? password.value : this.password));
  }
}

@JsonSerializable(explicitToJson: true)
class RoundWinnerDto {
  const RoundWinnerDto({
    this.userId,
    this.username,
    this.amountWon,
  });

  factory RoundWinnerDto.fromJson(Map<String, dynamic> json) =>
      _$RoundWinnerDtoFromJson(json);

  static const toJsonFactory = _$RoundWinnerDtoToJson;
  Map<String, dynamic> toJson() => _$RoundWinnerDtoToJson(this);

  @JsonKey(name: 'userId', defaultValue: 0)
  final int? userId;
  @JsonKey(name: 'username')
  final String? username;
  @JsonKey(name: 'amountWon', defaultValue: 0)
  final int? amountWon;
  static const fromJsonFactory = _$RoundWinnerDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RoundWinnerDto &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)) &&
            (identical(other.amountWon, amountWon) ||
                const DeepCollectionEquality()
                    .equals(other.amountWon, amountWon)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(amountWon) ^
      runtimeType.hashCode;
}

extension $RoundWinnerDtoExtension on RoundWinnerDto {
  RoundWinnerDto copyWith({int? userId, String? username, int? amountWon}) {
    return RoundWinnerDto(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        amountWon: amountWon ?? this.amountWon);
  }

  RoundWinnerDto copyWithWrapped(
      {Wrapped<int?>? userId,
      Wrapped<String?>? username,
      Wrapped<int?>? amountWon}) {
    return RoundWinnerDto(
        userId: (userId != null ? userId.value : this.userId),
        username: (username != null ? username.value : this.username),
        amountWon: (amountWon != null ? amountWon.value : this.amountWon));
  }
}

@JsonSerializable(explicitToJson: true)
class SelectItemDto {
  const SelectItemDto({
    this.itemId,
  });

  factory SelectItemDto.fromJson(Map<String, dynamic> json) =>
      _$SelectItemDtoFromJson(json);

  static const toJsonFactory = _$SelectItemDtoToJson;
  Map<String, dynamic> toJson() => _$SelectItemDtoToJson(this);

  @JsonKey(name: 'itemId', defaultValue: 0)
  final int? itemId;
  static const fromJsonFactory = _$SelectItemDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SelectItemDto &&
            (identical(other.itemId, itemId) ||
                const DeepCollectionEquality().equals(other.itemId, itemId)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(itemId) ^ runtimeType.hashCode;
}

extension $SelectItemDtoExtension on SelectItemDto {
  SelectItemDto copyWith({int? itemId}) {
    return SelectItemDto(itemId: itemId ?? this.itemId);
  }

  SelectItemDto copyWithWrapped({Wrapped<int?>? itemId}) {
    return SelectItemDto(itemId: (itemId != null ? itemId.value : this.itemId));
  }
}

@JsonSerializable(explicitToJson: true)
class ShopItemDto {
  const ShopItemDto({
    this.itemId,
    this.name,
    this.description,
    this.price,
    this.itemType,
    this.currency,
  });

  factory ShopItemDto.fromJson(Map<String, dynamic> json) =>
      _$ShopItemDtoFromJson(json);

  static const toJsonFactory = _$ShopItemDtoToJson;
  Map<String, dynamic> toJson() => _$ShopItemDtoToJson(this);

  @JsonKey(name: 'itemId', defaultValue: 0)
  final int? itemId;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'price')
  final double? price;
  @JsonKey(name: 'itemType')
  final String? itemType;
  @JsonKey(name: 'currency')
  final String? currency;
  static const fromJsonFactory = _$ShopItemDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ShopItemDto &&
            (identical(other.itemId, itemId) ||
                const DeepCollectionEquality().equals(other.itemId, itemId)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.price, price) ||
                const DeepCollectionEquality().equals(other.price, price)) &&
            (identical(other.itemType, itemType) ||
                const DeepCollectionEquality()
                    .equals(other.itemType, itemType)) &&
            (identical(other.currency, currency) ||
                const DeepCollectionEquality()
                    .equals(other.currency, currency)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(itemId) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(price) ^
      const DeepCollectionEquality().hash(itemType) ^
      const DeepCollectionEquality().hash(currency) ^
      runtimeType.hashCode;
}

extension $ShopItemDtoExtension on ShopItemDto {
  ShopItemDto copyWith(
      {int? itemId,
      String? name,
      String? description,
      double? price,
      String? itemType,
      String? currency}) {
    return ShopItemDto(
        itemId: itemId ?? this.itemId,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        itemType: itemType ?? this.itemType,
        currency: currency ?? this.currency);
  }

  ShopItemDto copyWithWrapped(
      {Wrapped<int?>? itemId,
      Wrapped<String?>? name,
      Wrapped<String?>? description,
      Wrapped<double?>? price,
      Wrapped<String?>? itemType,
      Wrapped<String?>? currency}) {
    return ShopItemDto(
        itemId: (itemId != null ? itemId.value : this.itemId),
        name: (name != null ? name.value : this.name),
        description:
            (description != null ? description.value : this.description),
        price: (price != null ? price.value : this.price),
        itemType: (itemType != null ? itemType.value : this.itemType),
        currency: (currency != null ? currency.value : this.currency));
  }
}

@JsonSerializable(explicitToJson: true)
class SocialLoginDto {
  const SocialLoginDto({
    this.provider,
    this.token,
  });

  factory SocialLoginDto.fromJson(Map<String, dynamic> json) =>
      _$SocialLoginDtoFromJson(json);

  static const toJsonFactory = _$SocialLoginDtoToJson;
  Map<String, dynamic> toJson() => _$SocialLoginDtoToJson(this);

  @JsonKey(name: 'provider')
  final String? provider;
  @JsonKey(name: 'token')
  final String? token;
  static const fromJsonFactory = _$SocialLoginDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SocialLoginDto &&
            (identical(other.provider, provider) ||
                const DeepCollectionEquality()
                    .equals(other.provider, provider)) &&
            (identical(other.token, token) ||
                const DeepCollectionEquality().equals(other.token, token)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(provider) ^
      const DeepCollectionEquality().hash(token) ^
      runtimeType.hashCode;
}

extension $SocialLoginDtoExtension on SocialLoginDto {
  SocialLoginDto copyWith({String? provider, String? token}) {
    return SocialLoginDto(
        provider: provider ?? this.provider, token: token ?? this.token);
  }

  SocialLoginDto copyWithWrapped(
      {Wrapped<String?>? provider, Wrapped<String?>? token}) {
    return SocialLoginDto(
        provider: (provider != null ? provider.value : this.provider),
        token: (token != null ? token.value : this.token));
  }
}

@JsonSerializable(explicitToJson: true)
class TableDto {
  const TableDto({
    this.tableId,
    this.name,
    this.difficultyLevel,
    this.maxPlayers,
    this.minBuyIn,
    this.maxBuyIn,
    this.smallBlind,
    this.bigBlind,
  });

  factory TableDto.fromJson(Map<String, dynamic> json) =>
      _$TableDtoFromJson(json);

  static const toJsonFactory = _$TableDtoToJson;
  Map<String, dynamic> toJson() => _$TableDtoToJson(this);

  @JsonKey(name: 'tableId', defaultValue: 0)
  final int? tableId;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'difficultyLevel')
  final String? difficultyLevel;
  @JsonKey(name: 'maxPlayers', defaultValue: 0)
  final int? maxPlayers;
  @JsonKey(name: 'minBuyIn', defaultValue: 0)
  final int? minBuyIn;
  @JsonKey(name: 'maxBuyIn', defaultValue: 0)
  final int? maxBuyIn;
  @JsonKey(name: 'smallBlind', defaultValue: 0)
  final int? smallBlind;
  @JsonKey(name: 'bigBlind', defaultValue: 0)
  final int? bigBlind;
  static const fromJsonFactory = _$TableDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TableDto &&
            (identical(other.tableId, tableId) ||
                const DeepCollectionEquality()
                    .equals(other.tableId, tableId)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.difficultyLevel, difficultyLevel) ||
                const DeepCollectionEquality()
                    .equals(other.difficultyLevel, difficultyLevel)) &&
            (identical(other.maxPlayers, maxPlayers) ||
                const DeepCollectionEquality()
                    .equals(other.maxPlayers, maxPlayers)) &&
            (identical(other.minBuyIn, minBuyIn) ||
                const DeepCollectionEquality()
                    .equals(other.minBuyIn, minBuyIn)) &&
            (identical(other.maxBuyIn, maxBuyIn) ||
                const DeepCollectionEquality()
                    .equals(other.maxBuyIn, maxBuyIn)) &&
            (identical(other.smallBlind, smallBlind) ||
                const DeepCollectionEquality()
                    .equals(other.smallBlind, smallBlind)) &&
            (identical(other.bigBlind, bigBlind) ||
                const DeepCollectionEquality()
                    .equals(other.bigBlind, bigBlind)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(tableId) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(difficultyLevel) ^
      const DeepCollectionEquality().hash(maxPlayers) ^
      const DeepCollectionEquality().hash(minBuyIn) ^
      const DeepCollectionEquality().hash(maxBuyIn) ^
      const DeepCollectionEquality().hash(smallBlind) ^
      const DeepCollectionEquality().hash(bigBlind) ^
      runtimeType.hashCode;
}

extension $TableDtoExtension on TableDto {
  TableDto copyWith(
      {int? tableId,
      String? name,
      String? difficultyLevel,
      int? maxPlayers,
      int? minBuyIn,
      int? maxBuyIn,
      int? smallBlind,
      int? bigBlind}) {
    return TableDto(
        tableId: tableId ?? this.tableId,
        name: name ?? this.name,
        difficultyLevel: difficultyLevel ?? this.difficultyLevel,
        maxPlayers: maxPlayers ?? this.maxPlayers,
        minBuyIn: minBuyIn ?? this.minBuyIn,
        maxBuyIn: maxBuyIn ?? this.maxBuyIn,
        smallBlind: smallBlind ?? this.smallBlind,
        bigBlind: bigBlind ?? this.bigBlind);
  }

  TableDto copyWithWrapped(
      {Wrapped<int?>? tableId,
      Wrapped<String?>? name,
      Wrapped<String?>? difficultyLevel,
      Wrapped<int?>? maxPlayers,
      Wrapped<int?>? minBuyIn,
      Wrapped<int?>? maxBuyIn,
      Wrapped<int?>? smallBlind,
      Wrapped<int?>? bigBlind}) {
    return TableDto(
        tableId: (tableId != null ? tableId.value : this.tableId),
        name: (name != null ? name.value : this.name),
        difficultyLevel: (difficultyLevel != null
            ? difficultyLevel.value
            : this.difficultyLevel),
        maxPlayers: (maxPlayers != null ? maxPlayers.value : this.maxPlayers),
        minBuyIn: (minBuyIn != null ? minBuyIn.value : this.minBuyIn),
        maxBuyIn: (maxBuyIn != null ? maxBuyIn.value : this.maxBuyIn),
        smallBlind: (smallBlind != null ? smallBlind.value : this.smallBlind),
        bigBlind: (bigBlind != null ? bigBlind.value : this.bigBlind));
  }
}

@JsonSerializable(explicitToJson: true)
class UpdateProfileDto {
  const UpdateProfileDto({
    this.email,
    this.avatarImage,
  });

  factory UpdateProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileDtoFromJson(json);

  static const toJsonFactory = _$UpdateProfileDtoToJson;
  Map<String, dynamic> toJson() => _$UpdateProfileDtoToJson(this);

  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'avatarImage')
  final String? avatarImage;
  static const fromJsonFactory = _$UpdateProfileDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateProfileDto &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.avatarImage, avatarImage) ||
                const DeepCollectionEquality()
                    .equals(other.avatarImage, avatarImage)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(avatarImage) ^
      runtimeType.hashCode;
}

extension $UpdateProfileDtoExtension on UpdateProfileDto {
  UpdateProfileDto copyWith({String? email, String? avatarImage}) {
    return UpdateProfileDto(
        email: email ?? this.email,
        avatarImage: avatarImage ?? this.avatarImage);
  }

  UpdateProfileDto copyWithWrapped(
      {Wrapped<String?>? email, Wrapped<String?>? avatarImage}) {
    return UpdateProfileDto(
        email: (email != null ? email.value : this.email),
        avatarImage:
            (avatarImage != null ? avatarImage.value : this.avatarImage));
  }
}

@JsonSerializable(explicitToJson: true)
class UserDto {
  const UserDto({
    this.userId,
    this.username,
    this.email,
    this.chipsBalance,
    this.avatarImage,
    this.deckStyle,
    this.token,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  static const toJsonFactory = _$UserDtoToJson;
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  @JsonKey(name: 'userId', defaultValue: 0)
  final int? userId;
  @JsonKey(name: 'username')
  final String? username;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'chipsBalance', defaultValue: 0)
  final int? chipsBalance;
  @JsonKey(name: 'avatarImage')
  final String? avatarImage;
  @JsonKey(name: 'deckStyle')
  final String? deckStyle;
  @JsonKey(name: 'token')
  final String? token;
  static const fromJsonFactory = _$UserDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserDto &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.chipsBalance, chipsBalance) ||
                const DeepCollectionEquality()
                    .equals(other.chipsBalance, chipsBalance)) &&
            (identical(other.avatarImage, avatarImage) ||
                const DeepCollectionEquality()
                    .equals(other.avatarImage, avatarImage)) &&
            (identical(other.deckStyle, deckStyle) ||
                const DeepCollectionEquality()
                    .equals(other.deckStyle, deckStyle)) &&
            (identical(other.token, token) ||
                const DeepCollectionEquality().equals(other.token, token)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(chipsBalance) ^
      const DeepCollectionEquality().hash(avatarImage) ^
      const DeepCollectionEquality().hash(deckStyle) ^
      const DeepCollectionEquality().hash(token) ^
      runtimeType.hashCode;
}

extension $UserDtoExtension on UserDto {
  UserDto copyWith(
      {int? userId,
      String? username,
      String? email,
      int? chipsBalance,
      String? avatarImage,
      String? deckStyle,
      String? token}) {
    return UserDto(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        email: email ?? this.email,
        chipsBalance: chipsBalance ?? this.chipsBalance,
        avatarImage: avatarImage ?? this.avatarImage,
        deckStyle: deckStyle ?? this.deckStyle,
        token: token ?? this.token);
  }

  UserDto copyWithWrapped(
      {Wrapped<int?>? userId,
      Wrapped<String?>? username,
      Wrapped<String?>? email,
      Wrapped<int?>? chipsBalance,
      Wrapped<String?>? avatarImage,
      Wrapped<String?>? deckStyle,
      Wrapped<String?>? token}) {
    return UserDto(
        userId: (userId != null ? userId.value : this.userId),
        username: (username != null ? username.value : this.username),
        email: (email != null ? email.value : this.email),
        chipsBalance:
            (chipsBalance != null ? chipsBalance.value : this.chipsBalance),
        avatarImage:
            (avatarImage != null ? avatarImage.value : this.avatarImage),
        deckStyle: (deckStyle != null ? deckStyle.value : this.deckStyle),
        token: (token != null ? token.value : this.token));
  }
}

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
