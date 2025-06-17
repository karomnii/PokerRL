// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:convert';

part 'swagger.models.swagger.g.dart';

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
class Card {
  const Card({
    this.cardId,
    this.suit,
    this.$value,
    this.communityCards,
    this.playerCards,
  });

  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);

  static const toJsonFactory = _$CardToJson;
  Map<String, dynamic> toJson() => _$CardToJson(this);

  @JsonKey(name: 'cardId', defaultValue: 0)
  final int? cardId;
  @JsonKey(name: 'suit')
  final String? suit;
  @JsonKey(name: 'value')
  final String? $value;
  @JsonKey(name: 'communityCards', defaultValue: <CommunityCard>[])
  final List<CommunityCard>? communityCards;
  @JsonKey(name: 'playerCards', defaultValue: <PlayerCard>[])
  final List<PlayerCard>? playerCards;
  static const fromJsonFactory = _$CardFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Card &&
            (identical(other.cardId, cardId) ||
                const DeepCollectionEquality().equals(other.cardId, cardId)) &&
            (identical(other.suit, suit) ||
                const DeepCollectionEquality().equals(other.suit, suit)) &&
            (identical(other.$value, $value) ||
                const DeepCollectionEquality().equals(other.$value, $value)) &&
            (identical(other.communityCards, communityCards) ||
                const DeepCollectionEquality()
                    .equals(other.communityCards, communityCards)) &&
            (identical(other.playerCards, playerCards) ||
                const DeepCollectionEquality()
                    .equals(other.playerCards, playerCards)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(cardId) ^
      const DeepCollectionEquality().hash(suit) ^
      const DeepCollectionEquality().hash($value) ^
      const DeepCollectionEquality().hash(communityCards) ^
      const DeepCollectionEquality().hash(playerCards) ^
      runtimeType.hashCode;
}

extension $CardExtension on Card {
  Card copyWith(
      {int? cardId,
      String? suit,
      String? $value,
      List<CommunityCard>? communityCards,
      List<PlayerCard>? playerCards}) {
    return Card(
        cardId: cardId ?? this.cardId,
        suit: suit ?? this.suit,
        $value: $value ?? this.$value,
        communityCards: communityCards ?? this.communityCards,
        playerCards: playerCards ?? this.playerCards);
  }

  Card copyWithWrapped(
      {Wrapped<int?>? cardId,
      Wrapped<String?>? suit,
      Wrapped<String?>? $value,
      Wrapped<List<CommunityCard>?>? communityCards,
      Wrapped<List<PlayerCard>?>? playerCards}) {
    return Card(
        cardId: (cardId != null ? cardId.value : this.cardId),
        suit: (suit != null ? suit.value : this.suit),
        $value: ($value != null ? $value.value : this.$value),
        communityCards: (communityCards != null
            ? communityCards.value
            : this.communityCards),
        playerCards:
            (playerCards != null ? playerCards.value : this.playerCards));
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
class ChipTransaction {
  const ChipTransaction({
    this.transactionId,
    this.userId,
    this.amount,
    this.transactionType,
    this.referenceId,
    this.transactionDate,
    this.description,
    this.user,
  });

  factory ChipTransaction.fromJson(Map<String, dynamic> json) =>
      _$ChipTransactionFromJson(json);

  static const toJsonFactory = _$ChipTransactionToJson;
  Map<String, dynamic> toJson() => _$ChipTransactionToJson(this);

  @JsonKey(name: 'transactionId', defaultValue: 0)
  final int? transactionId;
  @JsonKey(name: 'userId', defaultValue: 0)
  final int? userId;
  @JsonKey(name: 'amount', defaultValue: 0)
  final int? amount;
  @JsonKey(name: 'transactionType')
  final String? transactionType;
  @JsonKey(name: 'referenceId', defaultValue: 0)
  final int? referenceId;
  @JsonKey(name: 'transactionDate')
  final DateTime? transactionDate;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'user')
  final User? user;
  static const fromJsonFactory = _$ChipTransactionFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ChipTransaction &&
            (identical(other.transactionId, transactionId) ||
                const DeepCollectionEquality()
                    .equals(other.transactionId, transactionId)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.amount, amount) ||
                const DeepCollectionEquality().equals(other.amount, amount)) &&
            (identical(other.transactionType, transactionType) ||
                const DeepCollectionEquality()
                    .equals(other.transactionType, transactionType)) &&
            (identical(other.referenceId, referenceId) ||
                const DeepCollectionEquality()
                    .equals(other.referenceId, referenceId)) &&
            (identical(other.transactionDate, transactionDate) ||
                const DeepCollectionEquality()
                    .equals(other.transactionDate, transactionDate)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(transactionId) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(amount) ^
      const DeepCollectionEquality().hash(transactionType) ^
      const DeepCollectionEquality().hash(referenceId) ^
      const DeepCollectionEquality().hash(transactionDate) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(user) ^
      runtimeType.hashCode;
}

extension $ChipTransactionExtension on ChipTransaction {
  ChipTransaction copyWith(
      {int? transactionId,
      int? userId,
      int? amount,
      String? transactionType,
      int? referenceId,
      DateTime? transactionDate,
      String? description,
      User? user}) {
    return ChipTransaction(
        transactionId: transactionId ?? this.transactionId,
        userId: userId ?? this.userId,
        amount: amount ?? this.amount,
        transactionType: transactionType ?? this.transactionType,
        referenceId: referenceId ?? this.referenceId,
        transactionDate: transactionDate ?? this.transactionDate,
        description: description ?? this.description,
        user: user ?? this.user);
  }

  ChipTransaction copyWithWrapped(
      {Wrapped<int?>? transactionId,
      Wrapped<int?>? userId,
      Wrapped<int?>? amount,
      Wrapped<String?>? transactionType,
      Wrapped<int?>? referenceId,
      Wrapped<DateTime?>? transactionDate,
      Wrapped<String?>? description,
      Wrapped<User?>? user}) {
    return ChipTransaction(
        transactionId:
            (transactionId != null ? transactionId.value : this.transactionId),
        userId: (userId != null ? userId.value : this.userId),
        amount: (amount != null ? amount.value : this.amount),
        transactionType: (transactionType != null
            ? transactionType.value
            : this.transactionType),
        referenceId:
            (referenceId != null ? referenceId.value : this.referenceId),
        transactionDate: (transactionDate != null
            ? transactionDate.value
            : this.transactionDate),
        description:
            (description != null ? description.value : this.description),
        user: (user != null ? user.value : this.user));
  }
}

@JsonSerializable(explicitToJson: true)
class ChooseUsernameDto {
  const ChooseUsernameDto({
    this.username,
  });

  factory ChooseUsernameDto.fromJson(Map<String, dynamic> json) =>
      _$ChooseUsernameDtoFromJson(json);

  static const toJsonFactory = _$ChooseUsernameDtoToJson;
  Map<String, dynamic> toJson() => _$ChooseUsernameDtoToJson(this);

  @JsonKey(name: 'username')
  final String? username;
  static const fromJsonFactory = _$ChooseUsernameDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ChooseUsernameDto &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(username) ^ runtimeType.hashCode;
}

extension $ChooseUsernameDtoExtension on ChooseUsernameDto {
  ChooseUsernameDto copyWith({String? username}) {
    return ChooseUsernameDto(username: username ?? this.username);
  }

  ChooseUsernameDto copyWithWrapped({Wrapped<String?>? username}) {
    return ChooseUsernameDto(
        username: (username != null ? username.value : this.username));
  }
}

@JsonSerializable(explicitToJson: true)
class CommunityCard {
  const CommunityCard({
    this.communityCardId,
    this.gameRoundId,
    this.cardId,
    this.position,
    this.card,
    this.gameRound,
  });

  factory CommunityCard.fromJson(Map<String, dynamic> json) =>
      _$CommunityCardFromJson(json);

  static const toJsonFactory = _$CommunityCardToJson;
  Map<String, dynamic> toJson() => _$CommunityCardToJson(this);

  @JsonKey(name: 'communityCardId', defaultValue: 0)
  final int? communityCardId;
  @JsonKey(name: 'gameRoundId', defaultValue: 0)
  final int? gameRoundId;
  @JsonKey(name: 'cardId', defaultValue: 0)
  final int? cardId;
  @JsonKey(name: 'position', defaultValue: 0)
  final int? position;
  @JsonKey(name: 'card')
  final Card? card;
  @JsonKey(name: 'gameRound')
  final GameRound? gameRound;
  static const fromJsonFactory = _$CommunityCardFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CommunityCard &&
            (identical(other.communityCardId, communityCardId) ||
                const DeepCollectionEquality()
                    .equals(other.communityCardId, communityCardId)) &&
            (identical(other.gameRoundId, gameRoundId) ||
                const DeepCollectionEquality()
                    .equals(other.gameRoundId, gameRoundId)) &&
            (identical(other.cardId, cardId) ||
                const DeepCollectionEquality().equals(other.cardId, cardId)) &&
            (identical(other.position, position) ||
                const DeepCollectionEquality()
                    .equals(other.position, position)) &&
            (identical(other.card, card) ||
                const DeepCollectionEquality().equals(other.card, card)) &&
            (identical(other.gameRound, gameRound) ||
                const DeepCollectionEquality()
                    .equals(other.gameRound, gameRound)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(communityCardId) ^
      const DeepCollectionEquality().hash(gameRoundId) ^
      const DeepCollectionEquality().hash(cardId) ^
      const DeepCollectionEquality().hash(position) ^
      const DeepCollectionEquality().hash(card) ^
      const DeepCollectionEquality().hash(gameRound) ^
      runtimeType.hashCode;
}

extension $CommunityCardExtension on CommunityCard {
  CommunityCard copyWith(
      {int? communityCardId,
      int? gameRoundId,
      int? cardId,
      int? position,
      Card? card,
      GameRound? gameRound}) {
    return CommunityCard(
        communityCardId: communityCardId ?? this.communityCardId,
        gameRoundId: gameRoundId ?? this.gameRoundId,
        cardId: cardId ?? this.cardId,
        position: position ?? this.position,
        card: card ?? this.card,
        gameRound: gameRound ?? this.gameRound);
  }

  CommunityCard copyWithWrapped(
      {Wrapped<int?>? communityCardId,
      Wrapped<int?>? gameRoundId,
      Wrapped<int?>? cardId,
      Wrapped<int?>? position,
      Wrapped<Card?>? card,
      Wrapped<GameRound?>? gameRound}) {
    return CommunityCard(
        communityCardId: (communityCardId != null
            ? communityCardId.value
            : this.communityCardId),
        gameRoundId:
            (gameRoundId != null ? gameRoundId.value : this.gameRoundId),
        cardId: (cardId != null ? cardId.value : this.cardId),
        position: (position != null ? position.value : this.position),
        card: (card != null ? card.value : this.card),
        gameRound: (gameRound != null ? gameRound.value : this.gameRound));
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
class Game {
  const Game({
    this.gameId,
    this.tableId,
    this.startTime,
    this.endTime,
    this.currentTurnPlayerId,
    this.potSize,
    this.currentTurnPlayer,
    this.gamePlayers,
    this.gameRounds,
    this.table,
  });

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  static const toJsonFactory = _$GameToJson;
  Map<String, dynamic> toJson() => _$GameToJson(this);

  @JsonKey(name: 'gameId', defaultValue: 0)
  final int? gameId;
  @JsonKey(name: 'tableId', defaultValue: 0)
  final int? tableId;
  @JsonKey(name: 'startTime')
  final DateTime? startTime;
  @JsonKey(name: 'endTime')
  final DateTime? endTime;
  @JsonKey(name: 'currentTurnPlayerId', defaultValue: 0)
  final int? currentTurnPlayerId;
  @JsonKey(name: 'potSize', defaultValue: 0)
  final int? potSize;
  @JsonKey(name: 'currentTurnPlayer')
  final GamePlayer? currentTurnPlayer;
  @JsonKey(name: 'gamePlayers', defaultValue: <GamePlayer>[])
  final List<GamePlayer>? gamePlayers;
  @JsonKey(name: 'gameRounds', defaultValue: <GameRound>[])
  final List<GameRound>? gameRounds;
  @JsonKey(name: 'table')
  final PokerTable? table;
  static const fromJsonFactory = _$GameFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Game &&
            (identical(other.gameId, gameId) ||
                const DeepCollectionEquality().equals(other.gameId, gameId)) &&
            (identical(other.tableId, tableId) ||
                const DeepCollectionEquality()
                    .equals(other.tableId, tableId)) &&
            (identical(other.startTime, startTime) ||
                const DeepCollectionEquality()
                    .equals(other.startTime, startTime)) &&
            (identical(other.endTime, endTime) ||
                const DeepCollectionEquality()
                    .equals(other.endTime, endTime)) &&
            (identical(other.currentTurnPlayerId, currentTurnPlayerId) ||
                const DeepCollectionEquality()
                    .equals(other.currentTurnPlayerId, currentTurnPlayerId)) &&
            (identical(other.potSize, potSize) ||
                const DeepCollectionEquality()
                    .equals(other.potSize, potSize)) &&
            (identical(other.currentTurnPlayer, currentTurnPlayer) ||
                const DeepCollectionEquality()
                    .equals(other.currentTurnPlayer, currentTurnPlayer)) &&
            (identical(other.gamePlayers, gamePlayers) ||
                const DeepCollectionEquality()
                    .equals(other.gamePlayers, gamePlayers)) &&
            (identical(other.gameRounds, gameRounds) ||
                const DeepCollectionEquality()
                    .equals(other.gameRounds, gameRounds)) &&
            (identical(other.table, table) ||
                const DeepCollectionEquality().equals(other.table, table)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(gameId) ^
      const DeepCollectionEquality().hash(tableId) ^
      const DeepCollectionEquality().hash(startTime) ^
      const DeepCollectionEquality().hash(endTime) ^
      const DeepCollectionEquality().hash(currentTurnPlayerId) ^
      const DeepCollectionEquality().hash(potSize) ^
      const DeepCollectionEquality().hash(currentTurnPlayer) ^
      const DeepCollectionEquality().hash(gamePlayers) ^
      const DeepCollectionEquality().hash(gameRounds) ^
      const DeepCollectionEquality().hash(table) ^
      runtimeType.hashCode;
}

extension $GameExtension on Game {
  Game copyWith(
      {int? gameId,
      int? tableId,
      DateTime? startTime,
      DateTime? endTime,
      int? currentTurnPlayerId,
      int? potSize,
      GamePlayer? currentTurnPlayer,
      List<GamePlayer>? gamePlayers,
      List<GameRound>? gameRounds,
      PokerTable? table}) {
    return Game(
        gameId: gameId ?? this.gameId,
        tableId: tableId ?? this.tableId,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        currentTurnPlayerId: currentTurnPlayerId ?? this.currentTurnPlayerId,
        potSize: potSize ?? this.potSize,
        currentTurnPlayer: currentTurnPlayer ?? this.currentTurnPlayer,
        gamePlayers: gamePlayers ?? this.gamePlayers,
        gameRounds: gameRounds ?? this.gameRounds,
        table: table ?? this.table);
  }

  Game copyWithWrapped(
      {Wrapped<int?>? gameId,
      Wrapped<int?>? tableId,
      Wrapped<DateTime?>? startTime,
      Wrapped<DateTime?>? endTime,
      Wrapped<int?>? currentTurnPlayerId,
      Wrapped<int?>? potSize,
      Wrapped<GamePlayer?>? currentTurnPlayer,
      Wrapped<List<GamePlayer>?>? gamePlayers,
      Wrapped<List<GameRound>?>? gameRounds,
      Wrapped<PokerTable?>? table}) {
    return Game(
        gameId: (gameId != null ? gameId.value : this.gameId),
        tableId: (tableId != null ? tableId.value : this.tableId),
        startTime: (startTime != null ? startTime.value : this.startTime),
        endTime: (endTime != null ? endTime.value : this.endTime),
        currentTurnPlayerId: (currentTurnPlayerId != null
            ? currentTurnPlayerId.value
            : this.currentTurnPlayerId),
        potSize: (potSize != null ? potSize.value : this.potSize),
        currentTurnPlayer: (currentTurnPlayer != null
            ? currentTurnPlayer.value
            : this.currentTurnPlayer),
        gamePlayers:
            (gamePlayers != null ? gamePlayers.value : this.gamePlayers),
        gameRounds: (gameRounds != null ? gameRounds.value : this.gameRounds),
        table: (table != null ? table.value : this.table));
  }
}

@JsonSerializable(explicitToJson: true)
class GamePlayer {
  const GamePlayer({
    this.gamePlayerId,
    this.gameId,
    this.userId,
    this.seatPosition,
    this.initialChips,
    this.currentChips,
    this.isActive,
    this.isDealer,
    this.isSmallBlind,
    this.isBigBlind,
    this.game,
    this.games,
    this.playerCards,
    this.user,
  });

  factory GamePlayer.fromJson(Map<String, dynamic> json) =>
      _$GamePlayerFromJson(json);

  static const toJsonFactory = _$GamePlayerToJson;
  Map<String, dynamic> toJson() => _$GamePlayerToJson(this);

  @JsonKey(name: 'gamePlayerId', defaultValue: 0)
  final int? gamePlayerId;
  @JsonKey(name: 'gameId', defaultValue: 0)
  final int? gameId;
  @JsonKey(name: 'userId', defaultValue: 0)
  final int? userId;
  @JsonKey(name: 'seatPosition', defaultValue: 0)
  final int? seatPosition;
  @JsonKey(name: 'initialChips', defaultValue: 0)
  final int? initialChips;
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
  @JsonKey(name: 'game')
  final Game? game;
  @JsonKey(name: 'games', defaultValue: <Game>[])
  final List<Game>? games;
  @JsonKey(name: 'playerCards', defaultValue: <PlayerCard>[])
  final List<PlayerCard>? playerCards;
  @JsonKey(name: 'user')
  final User? user;
  static const fromJsonFactory = _$GamePlayerFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GamePlayer &&
            (identical(other.gamePlayerId, gamePlayerId) ||
                const DeepCollectionEquality()
                    .equals(other.gamePlayerId, gamePlayerId)) &&
            (identical(other.gameId, gameId) ||
                const DeepCollectionEquality().equals(other.gameId, gameId)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.seatPosition, seatPosition) ||
                const DeepCollectionEquality()
                    .equals(other.seatPosition, seatPosition)) &&
            (identical(other.initialChips, initialChips) ||
                const DeepCollectionEquality()
                    .equals(other.initialChips, initialChips)) &&
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
            (identical(other.game, game) ||
                const DeepCollectionEquality().equals(other.game, game)) &&
            (identical(other.games, games) ||
                const DeepCollectionEquality().equals(other.games, games)) &&
            (identical(other.playerCards, playerCards) ||
                const DeepCollectionEquality()
                    .equals(other.playerCards, playerCards)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(gamePlayerId) ^
      const DeepCollectionEquality().hash(gameId) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(seatPosition) ^
      const DeepCollectionEquality().hash(initialChips) ^
      const DeepCollectionEquality().hash(currentChips) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(isDealer) ^
      const DeepCollectionEquality().hash(isSmallBlind) ^
      const DeepCollectionEquality().hash(isBigBlind) ^
      const DeepCollectionEquality().hash(game) ^
      const DeepCollectionEquality().hash(games) ^
      const DeepCollectionEquality().hash(playerCards) ^
      const DeepCollectionEquality().hash(user) ^
      runtimeType.hashCode;
}

extension $GamePlayerExtension on GamePlayer {
  GamePlayer copyWith(
      {int? gamePlayerId,
      int? gameId,
      int? userId,
      int? seatPosition,
      int? initialChips,
      int? currentChips,
      bool? isActive,
      bool? isDealer,
      bool? isSmallBlind,
      bool? isBigBlind,
      Game? game,
      List<Game>? games,
      List<PlayerCard>? playerCards,
      User? user}) {
    return GamePlayer(
        gamePlayerId: gamePlayerId ?? this.gamePlayerId,
        gameId: gameId ?? this.gameId,
        userId: userId ?? this.userId,
        seatPosition: seatPosition ?? this.seatPosition,
        initialChips: initialChips ?? this.initialChips,
        currentChips: currentChips ?? this.currentChips,
        isActive: isActive ?? this.isActive,
        isDealer: isDealer ?? this.isDealer,
        isSmallBlind: isSmallBlind ?? this.isSmallBlind,
        isBigBlind: isBigBlind ?? this.isBigBlind,
        game: game ?? this.game,
        games: games ?? this.games,
        playerCards: playerCards ?? this.playerCards,
        user: user ?? this.user);
  }

  GamePlayer copyWithWrapped(
      {Wrapped<int?>? gamePlayerId,
      Wrapped<int?>? gameId,
      Wrapped<int?>? userId,
      Wrapped<int?>? seatPosition,
      Wrapped<int?>? initialChips,
      Wrapped<int?>? currentChips,
      Wrapped<bool?>? isActive,
      Wrapped<bool?>? isDealer,
      Wrapped<bool?>? isSmallBlind,
      Wrapped<bool?>? isBigBlind,
      Wrapped<Game?>? game,
      Wrapped<List<Game>?>? games,
      Wrapped<List<PlayerCard>?>? playerCards,
      Wrapped<User?>? user}) {
    return GamePlayer(
        gamePlayerId:
            (gamePlayerId != null ? gamePlayerId.value : this.gamePlayerId),
        gameId: (gameId != null ? gameId.value : this.gameId),
        userId: (userId != null ? userId.value : this.userId),
        seatPosition:
            (seatPosition != null ? seatPosition.value : this.seatPosition),
        initialChips:
            (initialChips != null ? initialChips.value : this.initialChips),
        currentChips:
            (currentChips != null ? currentChips.value : this.currentChips),
        isActive: (isActive != null ? isActive.value : this.isActive),
        isDealer: (isDealer != null ? isDealer.value : this.isDealer),
        isSmallBlind:
            (isSmallBlind != null ? isSmallBlind.value : this.isSmallBlind),
        isBigBlind: (isBigBlind != null ? isBigBlind.value : this.isBigBlind),
        game: (game != null ? game.value : this.game),
        games: (games != null ? games.value : this.games),
        playerCards:
            (playerCards != null ? playerCards.value : this.playerCards),
        user: (user != null ? user.value : this.user));
  }
}

@JsonSerializable(explicitToJson: true)
class GameRound {
  const GameRound({
    this.gameRoundId,
    this.gameId,
    this.roundNumber,
    this.currentState,
    this.startTime,
    this.endTime,
    this.potSize,
    this.communityCards,
    this.game,
    this.gameRoundWinners,
    this.moves,
    this.playerCards,
  });

  factory GameRound.fromJson(Map<String, dynamic> json) =>
      _$GameRoundFromJson(json);

  static const toJsonFactory = _$GameRoundToJson;
  Map<String, dynamic> toJson() => _$GameRoundToJson(this);

  @JsonKey(name: 'gameRoundId', defaultValue: 0)
  final int? gameRoundId;
  @JsonKey(name: 'gameId', defaultValue: 0)
  final int? gameId;
  @JsonKey(name: 'roundNumber', defaultValue: 0)
  final int? roundNumber;
  @JsonKey(name: 'currentState')
  final String? currentState;
  @JsonKey(name: 'startTime')
  final DateTime? startTime;
  @JsonKey(name: 'endTime')
  final DateTime? endTime;
  @JsonKey(name: 'potSize', defaultValue: 0)
  final int? potSize;
  @JsonKey(name: 'communityCards', defaultValue: <CommunityCard>[])
  final List<CommunityCard>? communityCards;
  @JsonKey(name: 'game')
  final Game? game;
  @JsonKey(name: 'gameRoundWinners', defaultValue: <GameRoundWinner>[])
  final List<GameRoundWinner>? gameRoundWinners;
  @JsonKey(name: 'moves', defaultValue: <Move>[])
  final List<Move>? moves;
  @JsonKey(name: 'playerCards', defaultValue: <PlayerCard>[])
  final List<PlayerCard>? playerCards;
  static const fromJsonFactory = _$GameRoundFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GameRound &&
            (identical(other.gameRoundId, gameRoundId) ||
                const DeepCollectionEquality()
                    .equals(other.gameRoundId, gameRoundId)) &&
            (identical(other.gameId, gameId) ||
                const DeepCollectionEquality().equals(other.gameId, gameId)) &&
            (identical(other.roundNumber, roundNumber) ||
                const DeepCollectionEquality()
                    .equals(other.roundNumber, roundNumber)) &&
            (identical(other.currentState, currentState) ||
                const DeepCollectionEquality()
                    .equals(other.currentState, currentState)) &&
            (identical(other.startTime, startTime) ||
                const DeepCollectionEquality()
                    .equals(other.startTime, startTime)) &&
            (identical(other.endTime, endTime) ||
                const DeepCollectionEquality()
                    .equals(other.endTime, endTime)) &&
            (identical(other.potSize, potSize) ||
                const DeepCollectionEquality()
                    .equals(other.potSize, potSize)) &&
            (identical(other.communityCards, communityCards) ||
                const DeepCollectionEquality()
                    .equals(other.communityCards, communityCards)) &&
            (identical(other.game, game) ||
                const DeepCollectionEquality().equals(other.game, game)) &&
            (identical(other.gameRoundWinners, gameRoundWinners) ||
                const DeepCollectionEquality()
                    .equals(other.gameRoundWinners, gameRoundWinners)) &&
            (identical(other.moves, moves) ||
                const DeepCollectionEquality().equals(other.moves, moves)) &&
            (identical(other.playerCards, playerCards) ||
                const DeepCollectionEquality()
                    .equals(other.playerCards, playerCards)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(gameRoundId) ^
      const DeepCollectionEquality().hash(gameId) ^
      const DeepCollectionEquality().hash(roundNumber) ^
      const DeepCollectionEquality().hash(currentState) ^
      const DeepCollectionEquality().hash(startTime) ^
      const DeepCollectionEquality().hash(endTime) ^
      const DeepCollectionEquality().hash(potSize) ^
      const DeepCollectionEquality().hash(communityCards) ^
      const DeepCollectionEquality().hash(game) ^
      const DeepCollectionEquality().hash(gameRoundWinners) ^
      const DeepCollectionEquality().hash(moves) ^
      const DeepCollectionEquality().hash(playerCards) ^
      runtimeType.hashCode;
}

extension $GameRoundExtension on GameRound {
  GameRound copyWith(
      {int? gameRoundId,
      int? gameId,
      int? roundNumber,
      String? currentState,
      DateTime? startTime,
      DateTime? endTime,
      int? potSize,
      List<CommunityCard>? communityCards,
      Game? game,
      List<GameRoundWinner>? gameRoundWinners,
      List<Move>? moves,
      List<PlayerCard>? playerCards}) {
    return GameRound(
        gameRoundId: gameRoundId ?? this.gameRoundId,
        gameId: gameId ?? this.gameId,
        roundNumber: roundNumber ?? this.roundNumber,
        currentState: currentState ?? this.currentState,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        potSize: potSize ?? this.potSize,
        communityCards: communityCards ?? this.communityCards,
        game: game ?? this.game,
        gameRoundWinners: gameRoundWinners ?? this.gameRoundWinners,
        moves: moves ?? this.moves,
        playerCards: playerCards ?? this.playerCards);
  }

  GameRound copyWithWrapped(
      {Wrapped<int?>? gameRoundId,
      Wrapped<int?>? gameId,
      Wrapped<int?>? roundNumber,
      Wrapped<String?>? currentState,
      Wrapped<DateTime?>? startTime,
      Wrapped<DateTime?>? endTime,
      Wrapped<int?>? potSize,
      Wrapped<List<CommunityCard>?>? communityCards,
      Wrapped<Game?>? game,
      Wrapped<List<GameRoundWinner>?>? gameRoundWinners,
      Wrapped<List<Move>?>? moves,
      Wrapped<List<PlayerCard>?>? playerCards}) {
    return GameRound(
        gameRoundId:
            (gameRoundId != null ? gameRoundId.value : this.gameRoundId),
        gameId: (gameId != null ? gameId.value : this.gameId),
        roundNumber:
            (roundNumber != null ? roundNumber.value : this.roundNumber),
        currentState:
            (currentState != null ? currentState.value : this.currentState),
        startTime: (startTime != null ? startTime.value : this.startTime),
        endTime: (endTime != null ? endTime.value : this.endTime),
        potSize: (potSize != null ? potSize.value : this.potSize),
        communityCards: (communityCards != null
            ? communityCards.value
            : this.communityCards),
        game: (game != null ? game.value : this.game),
        gameRoundWinners: (gameRoundWinners != null
            ? gameRoundWinners.value
            : this.gameRoundWinners),
        moves: (moves != null ? moves.value : this.moves),
        playerCards:
            (playerCards != null ? playerCards.value : this.playerCards));
  }
}

@JsonSerializable(explicitToJson: true)
class GameRoundWinner {
  const GameRoundWinner({
    this.gameRoundWinnerId,
    this.gameRoundId,
    this.userId,
    this.amountWon,
    this.gameRound,
    this.user,
  });

  factory GameRoundWinner.fromJson(Map<String, dynamic> json) =>
      _$GameRoundWinnerFromJson(json);

  static const toJsonFactory = _$GameRoundWinnerToJson;
  Map<String, dynamic> toJson() => _$GameRoundWinnerToJson(this);

  @JsonKey(name: 'gameRoundWinnerId', defaultValue: 0)
  final int? gameRoundWinnerId;
  @JsonKey(name: 'gameRoundId', defaultValue: 0)
  final int? gameRoundId;
  @JsonKey(name: 'userId', defaultValue: 0)
  final int? userId;
  @JsonKey(name: 'amountWon', defaultValue: 0)
  final int? amountWon;
  @JsonKey(name: 'gameRound')
  final GameRound? gameRound;
  @JsonKey(name: 'user')
  final User? user;
  static const fromJsonFactory = _$GameRoundWinnerFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GameRoundWinner &&
            (identical(other.gameRoundWinnerId, gameRoundWinnerId) ||
                const DeepCollectionEquality()
                    .equals(other.gameRoundWinnerId, gameRoundWinnerId)) &&
            (identical(other.gameRoundId, gameRoundId) ||
                const DeepCollectionEquality()
                    .equals(other.gameRoundId, gameRoundId)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.amountWon, amountWon) ||
                const DeepCollectionEquality()
                    .equals(other.amountWon, amountWon)) &&
            (identical(other.gameRound, gameRound) ||
                const DeepCollectionEquality()
                    .equals(other.gameRound, gameRound)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(gameRoundWinnerId) ^
      const DeepCollectionEquality().hash(gameRoundId) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(amountWon) ^
      const DeepCollectionEquality().hash(gameRound) ^
      const DeepCollectionEquality().hash(user) ^
      runtimeType.hashCode;
}

extension $GameRoundWinnerExtension on GameRoundWinner {
  GameRoundWinner copyWith(
      {int? gameRoundWinnerId,
      int? gameRoundId,
      int? userId,
      int? amountWon,
      GameRound? gameRound,
      User? user}) {
    return GameRoundWinner(
        gameRoundWinnerId: gameRoundWinnerId ?? this.gameRoundWinnerId,
        gameRoundId: gameRoundId ?? this.gameRoundId,
        userId: userId ?? this.userId,
        amountWon: amountWon ?? this.amountWon,
        gameRound: gameRound ?? this.gameRound,
        user: user ?? this.user);
  }

  GameRoundWinner copyWithWrapped(
      {Wrapped<int?>? gameRoundWinnerId,
      Wrapped<int?>? gameRoundId,
      Wrapped<int?>? userId,
      Wrapped<int?>? amountWon,
      Wrapped<GameRound?>? gameRound,
      Wrapped<User?>? user}) {
    return GameRoundWinner(
        gameRoundWinnerId: (gameRoundWinnerId != null
            ? gameRoundWinnerId.value
            : this.gameRoundWinnerId),
        gameRoundId:
            (gameRoundId != null ? gameRoundId.value : this.gameRoundId),
        userId: (userId != null ? userId.value : this.userId),
        amountWon: (amountWon != null ? amountWon.value : this.amountWon),
        gameRound: (gameRound != null ? gameRound.value : this.gameRound),
        user: (user != null ? user.value : this.user));
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
class Model {
  const Model({
    this.modelId,
    this.name,
    this.path,
    this.difficulty,
    this.userModels,
  });

  factory Model.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);

  static const toJsonFactory = _$ModelToJson;
  Map<String, dynamic> toJson() => _$ModelToJson(this);

  @JsonKey(name: 'modelId', defaultValue: 0)
  final int? modelId;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'path')
  final String? path;
  @JsonKey(name: 'difficulty')
  final String? difficulty;
  @JsonKey(name: 'userModels', defaultValue: <UserModel>[])
  final List<UserModel>? userModels;
  static const fromJsonFactory = _$ModelFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Model &&
            (identical(other.modelId, modelId) ||
                const DeepCollectionEquality()
                    .equals(other.modelId, modelId)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.path, path) ||
                const DeepCollectionEquality().equals(other.path, path)) &&
            (identical(other.difficulty, difficulty) ||
                const DeepCollectionEquality()
                    .equals(other.difficulty, difficulty)) &&
            (identical(other.userModels, userModels) ||
                const DeepCollectionEquality()
                    .equals(other.userModels, userModels)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(modelId) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(path) ^
      const DeepCollectionEquality().hash(difficulty) ^
      const DeepCollectionEquality().hash(userModels) ^
      runtimeType.hashCode;
}

extension $ModelExtension on Model {
  Model copyWith(
      {int? modelId,
      String? name,
      String? path,
      String? difficulty,
      List<UserModel>? userModels}) {
    return Model(
        modelId: modelId ?? this.modelId,
        name: name ?? this.name,
        path: path ?? this.path,
        difficulty: difficulty ?? this.difficulty,
        userModels: userModels ?? this.userModels);
  }

  Model copyWithWrapped(
      {Wrapped<int?>? modelId,
      Wrapped<String?>? name,
      Wrapped<String?>? path,
      Wrapped<String?>? difficulty,
      Wrapped<List<UserModel>?>? userModels}) {
    return Model(
        modelId: (modelId != null ? modelId.value : this.modelId),
        name: (name != null ? name.value : this.name),
        path: (path != null ? path.value : this.path),
        difficulty: (difficulty != null ? difficulty.value : this.difficulty),
        userModels: (userModels != null ? userModels.value : this.userModels));
  }
}

@JsonSerializable(explicitToJson: true)
class Move {
  const Move({
    this.moveId,
    this.gameRoundId,
    this.playerId,
    this.actionType,
    this.amount,
    this.moveTime,
    this.round,
    this.gameRound,
    this.player,
  });

  factory Move.fromJson(Map<String, dynamic> json) => _$MoveFromJson(json);

  static const toJsonFactory = _$MoveToJson;
  Map<String, dynamic> toJson() => _$MoveToJson(this);

  @JsonKey(name: 'moveId', defaultValue: 0)
  final int? moveId;
  @JsonKey(name: 'gameRoundId', defaultValue: 0)
  final int? gameRoundId;
  @JsonKey(name: 'playerId', defaultValue: 0)
  final int? playerId;
  @JsonKey(name: 'actionType')
  final String? actionType;
  @JsonKey(name: 'amount', defaultValue: 0)
  final int? amount;
  @JsonKey(name: 'moveTime')
  final DateTime? moveTime;
  @JsonKey(name: 'round')
  final String? round;
  @JsonKey(name: 'gameRound')
  final GameRound? gameRound;
  @JsonKey(name: 'player')
  final User? player;
  static const fromJsonFactory = _$MoveFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Move &&
            (identical(other.moveId, moveId) ||
                const DeepCollectionEquality().equals(other.moveId, moveId)) &&
            (identical(other.gameRoundId, gameRoundId) ||
                const DeepCollectionEquality()
                    .equals(other.gameRoundId, gameRoundId)) &&
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
                    .equals(other.moveTime, moveTime)) &&
            (identical(other.round, round) ||
                const DeepCollectionEquality().equals(other.round, round)) &&
            (identical(other.gameRound, gameRound) ||
                const DeepCollectionEquality()
                    .equals(other.gameRound, gameRound)) &&
            (identical(other.player, player) ||
                const DeepCollectionEquality().equals(other.player, player)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(moveId) ^
      const DeepCollectionEquality().hash(gameRoundId) ^
      const DeepCollectionEquality().hash(playerId) ^
      const DeepCollectionEquality().hash(actionType) ^
      const DeepCollectionEquality().hash(amount) ^
      const DeepCollectionEquality().hash(moveTime) ^
      const DeepCollectionEquality().hash(round) ^
      const DeepCollectionEquality().hash(gameRound) ^
      const DeepCollectionEquality().hash(player) ^
      runtimeType.hashCode;
}

extension $MoveExtension on Move {
  Move copyWith(
      {int? moveId,
      int? gameRoundId,
      int? playerId,
      String? actionType,
      int? amount,
      DateTime? moveTime,
      String? round,
      GameRound? gameRound,
      User? player}) {
    return Move(
        moveId: moveId ?? this.moveId,
        gameRoundId: gameRoundId ?? this.gameRoundId,
        playerId: playerId ?? this.playerId,
        actionType: actionType ?? this.actionType,
        amount: amount ?? this.amount,
        moveTime: moveTime ?? this.moveTime,
        round: round ?? this.round,
        gameRound: gameRound ?? this.gameRound,
        player: player ?? this.player);
  }

  Move copyWithWrapped(
      {Wrapped<int?>? moveId,
      Wrapped<int?>? gameRoundId,
      Wrapped<int?>? playerId,
      Wrapped<String?>? actionType,
      Wrapped<int?>? amount,
      Wrapped<DateTime?>? moveTime,
      Wrapped<String?>? round,
      Wrapped<GameRound?>? gameRound,
      Wrapped<User?>? player}) {
    return Move(
        moveId: (moveId != null ? moveId.value : this.moveId),
        gameRoundId:
            (gameRoundId != null ? gameRoundId.value : this.gameRoundId),
        playerId: (playerId != null ? playerId.value : this.playerId),
        actionType: (actionType != null ? actionType.value : this.actionType),
        amount: (amount != null ? amount.value : this.amount),
        moveTime: (moveTime != null ? moveTime.value : this.moveTime),
        round: (round != null ? round.value : this.round),
        gameRound: (gameRound != null ? gameRound.value : this.gameRound),
        player: (player != null ? player.value : this.player));
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
class PlayerCard {
  const PlayerCard({
    this.playerCardId,
    this.gamePlayerId,
    this.userId,
    this.gameRoundId,
    this.cardId,
    this.position,
    this.card,
    this.gamePlayer,
    this.gameRound,
    this.user,
  });

  factory PlayerCard.fromJson(Map<String, dynamic> json) =>
      _$PlayerCardFromJson(json);

  static const toJsonFactory = _$PlayerCardToJson;
  Map<String, dynamic> toJson() => _$PlayerCardToJson(this);

  @JsonKey(name: 'playerCardId', defaultValue: 0)
  final int? playerCardId;
  @JsonKey(name: 'gamePlayerId', defaultValue: 0)
  final int? gamePlayerId;
  @JsonKey(name: 'userId', defaultValue: 0)
  final int? userId;
  @JsonKey(name: 'gameRoundId', defaultValue: 0)
  final int? gameRoundId;
  @JsonKey(name: 'cardId', defaultValue: 0)
  final int? cardId;
  @JsonKey(name: 'position', defaultValue: 0)
  final int? position;
  @JsonKey(name: 'card')
  final Card? card;
  @JsonKey(name: 'gamePlayer')
  final GamePlayer? gamePlayer;
  @JsonKey(name: 'gameRound')
  final GameRound? gameRound;
  @JsonKey(name: 'user')
  final User? user;
  static const fromJsonFactory = _$PlayerCardFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PlayerCard &&
            (identical(other.playerCardId, playerCardId) ||
                const DeepCollectionEquality()
                    .equals(other.playerCardId, playerCardId)) &&
            (identical(other.gamePlayerId, gamePlayerId) ||
                const DeepCollectionEquality()
                    .equals(other.gamePlayerId, gamePlayerId)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.gameRoundId, gameRoundId) ||
                const DeepCollectionEquality()
                    .equals(other.gameRoundId, gameRoundId)) &&
            (identical(other.cardId, cardId) ||
                const DeepCollectionEquality().equals(other.cardId, cardId)) &&
            (identical(other.position, position) ||
                const DeepCollectionEquality()
                    .equals(other.position, position)) &&
            (identical(other.card, card) ||
                const DeepCollectionEquality().equals(other.card, card)) &&
            (identical(other.gamePlayer, gamePlayer) ||
                const DeepCollectionEquality()
                    .equals(other.gamePlayer, gamePlayer)) &&
            (identical(other.gameRound, gameRound) ||
                const DeepCollectionEquality()
                    .equals(other.gameRound, gameRound)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(playerCardId) ^
      const DeepCollectionEquality().hash(gamePlayerId) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(gameRoundId) ^
      const DeepCollectionEquality().hash(cardId) ^
      const DeepCollectionEquality().hash(position) ^
      const DeepCollectionEquality().hash(card) ^
      const DeepCollectionEquality().hash(gamePlayer) ^
      const DeepCollectionEquality().hash(gameRound) ^
      const DeepCollectionEquality().hash(user) ^
      runtimeType.hashCode;
}

extension $PlayerCardExtension on PlayerCard {
  PlayerCard copyWith(
      {int? playerCardId,
      int? gamePlayerId,
      int? userId,
      int? gameRoundId,
      int? cardId,
      int? position,
      Card? card,
      GamePlayer? gamePlayer,
      GameRound? gameRound,
      User? user}) {
    return PlayerCard(
        playerCardId: playerCardId ?? this.playerCardId,
        gamePlayerId: gamePlayerId ?? this.gamePlayerId,
        userId: userId ?? this.userId,
        gameRoundId: gameRoundId ?? this.gameRoundId,
        cardId: cardId ?? this.cardId,
        position: position ?? this.position,
        card: card ?? this.card,
        gamePlayer: gamePlayer ?? this.gamePlayer,
        gameRound: gameRound ?? this.gameRound,
        user: user ?? this.user);
  }

  PlayerCard copyWithWrapped(
      {Wrapped<int?>? playerCardId,
      Wrapped<int?>? gamePlayerId,
      Wrapped<int?>? userId,
      Wrapped<int?>? gameRoundId,
      Wrapped<int?>? cardId,
      Wrapped<int?>? position,
      Wrapped<Card?>? card,
      Wrapped<GamePlayer?>? gamePlayer,
      Wrapped<GameRound?>? gameRound,
      Wrapped<User?>? user}) {
    return PlayerCard(
        playerCardId:
            (playerCardId != null ? playerCardId.value : this.playerCardId),
        gamePlayerId:
            (gamePlayerId != null ? gamePlayerId.value : this.gamePlayerId),
        userId: (userId != null ? userId.value : this.userId),
        gameRoundId:
            (gameRoundId != null ? gameRoundId.value : this.gameRoundId),
        cardId: (cardId != null ? cardId.value : this.cardId),
        position: (position != null ? position.value : this.position),
        card: (card != null ? card.value : this.card),
        gamePlayer: (gamePlayer != null ? gamePlayer.value : this.gamePlayer),
        gameRound: (gameRound != null ? gameRound.value : this.gameRound),
        user: (user != null ? user.value : this.user));
  }
}

@JsonSerializable(explicitToJson: true)
class PlayerStateDto {
  const PlayerStateDto({
    this.userId,
    this.username,
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
class PokerTable {
  const PokerTable({
    this.tableId,
    this.name,
    this.entryFee,
    this.minBuyIn,
    this.maxBuyIn,
    this.smallBlind,
    this.bigBlind,
    this.maxPlayers,
    this.difficultyLevel,
    this.isActive,
    this.games,
  });

  factory PokerTable.fromJson(Map<String, dynamic> json) =>
      _$PokerTableFromJson(json);

  static const toJsonFactory = _$PokerTableToJson;
  Map<String, dynamic> toJson() => _$PokerTableToJson(this);

  @JsonKey(name: 'tableId', defaultValue: 0)
  final int? tableId;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'entryFee', defaultValue: 0)
  final int? entryFee;
  @JsonKey(name: 'minBuyIn', defaultValue: 0)
  final int? minBuyIn;
  @JsonKey(name: 'maxBuyIn', defaultValue: 0)
  final int? maxBuyIn;
  @JsonKey(name: 'smallBlind', defaultValue: 0)
  final int? smallBlind;
  @JsonKey(name: 'bigBlind', defaultValue: 0)
  final int? bigBlind;
  @JsonKey(name: 'maxPlayers', defaultValue: 0)
  final int? maxPlayers;
  @JsonKey(name: 'difficultyLevel')
  final String? difficultyLevel;
  @JsonKey(name: 'isActive', defaultValue: false)
  final bool? isActive;
  @JsonKey(name: 'games', defaultValue: <Game>[])
  final List<Game>? games;
  static const fromJsonFactory = _$PokerTableFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PokerTable &&
            (identical(other.tableId, tableId) ||
                const DeepCollectionEquality()
                    .equals(other.tableId, tableId)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.entryFee, entryFee) ||
                const DeepCollectionEquality()
                    .equals(other.entryFee, entryFee)) &&
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
                    .equals(other.bigBlind, bigBlind)) &&
            (identical(other.maxPlayers, maxPlayers) ||
                const DeepCollectionEquality()
                    .equals(other.maxPlayers, maxPlayers)) &&
            (identical(other.difficultyLevel, difficultyLevel) ||
                const DeepCollectionEquality()
                    .equals(other.difficultyLevel, difficultyLevel)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.games, games) ||
                const DeepCollectionEquality().equals(other.games, games)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(tableId) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(entryFee) ^
      const DeepCollectionEquality().hash(minBuyIn) ^
      const DeepCollectionEquality().hash(maxBuyIn) ^
      const DeepCollectionEquality().hash(smallBlind) ^
      const DeepCollectionEquality().hash(bigBlind) ^
      const DeepCollectionEquality().hash(maxPlayers) ^
      const DeepCollectionEquality().hash(difficultyLevel) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(games) ^
      runtimeType.hashCode;
}

extension $PokerTableExtension on PokerTable {
  PokerTable copyWith(
      {int? tableId,
      String? name,
      int? entryFee,
      int? minBuyIn,
      int? maxBuyIn,
      int? smallBlind,
      int? bigBlind,
      int? maxPlayers,
      String? difficultyLevel,
      bool? isActive,
      List<Game>? games}) {
    return PokerTable(
        tableId: tableId ?? this.tableId,
        name: name ?? this.name,
        entryFee: entryFee ?? this.entryFee,
        minBuyIn: minBuyIn ?? this.minBuyIn,
        maxBuyIn: maxBuyIn ?? this.maxBuyIn,
        smallBlind: smallBlind ?? this.smallBlind,
        bigBlind: bigBlind ?? this.bigBlind,
        maxPlayers: maxPlayers ?? this.maxPlayers,
        difficultyLevel: difficultyLevel ?? this.difficultyLevel,
        isActive: isActive ?? this.isActive,
        games: games ?? this.games);
  }

  PokerTable copyWithWrapped(
      {Wrapped<int?>? tableId,
      Wrapped<String?>? name,
      Wrapped<int?>? entryFee,
      Wrapped<int?>? minBuyIn,
      Wrapped<int?>? maxBuyIn,
      Wrapped<int?>? smallBlind,
      Wrapped<int?>? bigBlind,
      Wrapped<int?>? maxPlayers,
      Wrapped<String?>? difficultyLevel,
      Wrapped<bool?>? isActive,
      Wrapped<List<Game>?>? games}) {
    return PokerTable(
        tableId: (tableId != null ? tableId.value : this.tableId),
        name: (name != null ? name.value : this.name),
        entryFee: (entryFee != null ? entryFee.value : this.entryFee),
        minBuyIn: (minBuyIn != null ? minBuyIn.value : this.minBuyIn),
        maxBuyIn: (maxBuyIn != null ? maxBuyIn.value : this.maxBuyIn),
        smallBlind: (smallBlind != null ? smallBlind.value : this.smallBlind),
        bigBlind: (bigBlind != null ? bigBlind.value : this.bigBlind),
        maxPlayers: (maxPlayers != null ? maxPlayers.value : this.maxPlayers),
        difficultyLevel: (difficultyLevel != null
            ? difficultyLevel.value
            : this.difficultyLevel),
        isActive: (isActive != null ? isActive.value : this.isActive),
        games: (games != null ? games.value : this.games));
  }
}

@JsonSerializable(explicitToJson: true)
class Purchase {
  const Purchase({
    this.purchaseId,
    this.userId,
    this.itemId,
    this.purchaseDate,
    this.price,
    this.paymentMethod,
    this.transactionId,
    this.item,
    this.user,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) =>
      _$PurchaseFromJson(json);

  static const toJsonFactory = _$PurchaseToJson;
  Map<String, dynamic> toJson() => _$PurchaseToJson(this);

  @JsonKey(name: 'purchaseId', defaultValue: 0)
  final int? purchaseId;
  @JsonKey(name: 'userId', defaultValue: 0)
  final int? userId;
  @JsonKey(name: 'itemId', defaultValue: 0)
  final int? itemId;
  @JsonKey(name: 'purchaseDate')
  final DateTime? purchaseDate;
  @JsonKey(name: 'price')
  final double? price;
  @JsonKey(name: 'paymentMethod')
  final String? paymentMethod;
  @JsonKey(name: 'transactionId')
  final String? transactionId;
  @JsonKey(name: 'item')
  final ShopItem? item;
  @JsonKey(name: 'user')
  final User? user;
  static const fromJsonFactory = _$PurchaseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Purchase &&
            (identical(other.purchaseId, purchaseId) ||
                const DeepCollectionEquality()
                    .equals(other.purchaseId, purchaseId)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.itemId, itemId) ||
                const DeepCollectionEquality().equals(other.itemId, itemId)) &&
            (identical(other.purchaseDate, purchaseDate) ||
                const DeepCollectionEquality()
                    .equals(other.purchaseDate, purchaseDate)) &&
            (identical(other.price, price) ||
                const DeepCollectionEquality().equals(other.price, price)) &&
            (identical(other.paymentMethod, paymentMethod) ||
                const DeepCollectionEquality()
                    .equals(other.paymentMethod, paymentMethod)) &&
            (identical(other.transactionId, transactionId) ||
                const DeepCollectionEquality()
                    .equals(other.transactionId, transactionId)) &&
            (identical(other.item, item) ||
                const DeepCollectionEquality().equals(other.item, item)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(purchaseId) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(itemId) ^
      const DeepCollectionEquality().hash(purchaseDate) ^
      const DeepCollectionEquality().hash(price) ^
      const DeepCollectionEquality().hash(paymentMethod) ^
      const DeepCollectionEquality().hash(transactionId) ^
      const DeepCollectionEquality().hash(item) ^
      const DeepCollectionEquality().hash(user) ^
      runtimeType.hashCode;
}

extension $PurchaseExtension on Purchase {
  Purchase copyWith(
      {int? purchaseId,
      int? userId,
      int? itemId,
      DateTime? purchaseDate,
      double? price,
      String? paymentMethod,
      String? transactionId,
      ShopItem? item,
      User? user}) {
    return Purchase(
        purchaseId: purchaseId ?? this.purchaseId,
        userId: userId ?? this.userId,
        itemId: itemId ?? this.itemId,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        price: price ?? this.price,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        transactionId: transactionId ?? this.transactionId,
        item: item ?? this.item,
        user: user ?? this.user);
  }

  Purchase copyWithWrapped(
      {Wrapped<int?>? purchaseId,
      Wrapped<int?>? userId,
      Wrapped<int?>? itemId,
      Wrapped<DateTime?>? purchaseDate,
      Wrapped<double?>? price,
      Wrapped<String?>? paymentMethod,
      Wrapped<String?>? transactionId,
      Wrapped<ShopItem?>? item,
      Wrapped<User?>? user}) {
    return Purchase(
        purchaseId: (purchaseId != null ? purchaseId.value : this.purchaseId),
        userId: (userId != null ? userId.value : this.userId),
        itemId: (itemId != null ? itemId.value : this.itemId),
        purchaseDate:
            (purchaseDate != null ? purchaseDate.value : this.purchaseDate),
        price: (price != null ? price.value : this.price),
        paymentMethod:
            (paymentMethod != null ? paymentMethod.value : this.paymentMethod),
        transactionId:
            (transactionId != null ? transactionId.value : this.transactionId),
        item: (item != null ? item.value : this.item),
        user: (user != null ? user.value : this.user));
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
class ShopItem {
  const ShopItem({
    this.itemId,
    this.name,
    this.description,
    this.price,
    this.currency,
    this.itemType,
    this.isActive,
    this.purchases,
  });

  factory ShopItem.fromJson(Map<String, dynamic> json) =>
      _$ShopItemFromJson(json);

  static const toJsonFactory = _$ShopItemToJson;
  Map<String, dynamic> toJson() => _$ShopItemToJson(this);

  @JsonKey(name: 'itemId', defaultValue: 0)
  final int? itemId;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'price')
  final double? price;
  @JsonKey(name: 'currency')
  final String? currency;
  @JsonKey(name: 'itemType')
  final String? itemType;
  @JsonKey(name: 'isActive', defaultValue: false)
  final bool? isActive;
  @JsonKey(name: 'purchases', defaultValue: <Purchase>[])
  final List<Purchase>? purchases;
  static const fromJsonFactory = _$ShopItemFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ShopItem &&
            (identical(other.itemId, itemId) ||
                const DeepCollectionEquality().equals(other.itemId, itemId)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.price, price) ||
                const DeepCollectionEquality().equals(other.price, price)) &&
            (identical(other.currency, currency) ||
                const DeepCollectionEquality()
                    .equals(other.currency, currency)) &&
            (identical(other.itemType, itemType) ||
                const DeepCollectionEquality()
                    .equals(other.itemType, itemType)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.purchases, purchases) ||
                const DeepCollectionEquality()
                    .equals(other.purchases, purchases)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(itemId) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(price) ^
      const DeepCollectionEquality().hash(currency) ^
      const DeepCollectionEquality().hash(itemType) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(purchases) ^
      runtimeType.hashCode;
}

extension $ShopItemExtension on ShopItem {
  ShopItem copyWith(
      {int? itemId,
      String? name,
      String? description,
      double? price,
      String? currency,
      String? itemType,
      bool? isActive,
      List<Purchase>? purchases}) {
    return ShopItem(
        itemId: itemId ?? this.itemId,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        currency: currency ?? this.currency,
        itemType: itemType ?? this.itemType,
        isActive: isActive ?? this.isActive,
        purchases: purchases ?? this.purchases);
  }

  ShopItem copyWithWrapped(
      {Wrapped<int?>? itemId,
      Wrapped<String?>? name,
      Wrapped<String?>? description,
      Wrapped<double?>? price,
      Wrapped<String?>? currency,
      Wrapped<String?>? itemType,
      Wrapped<bool?>? isActive,
      Wrapped<List<Purchase>?>? purchases}) {
    return ShopItem(
        itemId: (itemId != null ? itemId.value : this.itemId),
        name: (name != null ? name.value : this.name),
        description:
            (description != null ? description.value : this.description),
        price: (price != null ? price.value : this.price),
        currency: (currency != null ? currency.value : this.currency),
        itemType: (itemType != null ? itemType.value : this.itemType),
        isActive: (isActive != null ? isActive.value : this.isActive),
        purchases: (purchases != null ? purchases.value : this.purchases));
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
class User {
  const User({
    this.userId,
    this.username,
    this.email,
    this.passwordHash,
    this.chipsBalance,
    this.avatarImage,
    this.avatarType,
    this.registrationDate,
    this.lastLoginDate,
    this.isActive,
    this.isBot,
    this.chipTransactions,
    this.gamePlayers,
    this.gameRoundWinners,
    this.moves,
    this.playerCards,
    this.purchases,
    this.userModels,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  static const toJsonFactory = _$UserToJson;
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @JsonKey(name: 'userId', defaultValue: 0)
  final int? userId;
  @JsonKey(name: 'username')
  final String? username;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'passwordHash')
  final String? passwordHash;
  @JsonKey(name: 'chipsBalance', defaultValue: 0)
  final int? chipsBalance;
  @JsonKey(name: 'avatarImage')
  final String? avatarImage;
  @JsonKey(name: 'avatarType')
  final String? avatarType;
  @JsonKey(name: 'registrationDate')
  final DateTime? registrationDate;
  @JsonKey(name: 'lastLoginDate')
  final DateTime? lastLoginDate;
  @JsonKey(name: 'isActive', defaultValue: false)
  final bool? isActive;
  @JsonKey(name: 'isBot', defaultValue: false)
  final bool? isBot;
  @JsonKey(name: 'chipTransactions', defaultValue: <ChipTransaction>[])
  final List<ChipTransaction>? chipTransactions;
  @JsonKey(name: 'gamePlayers', defaultValue: <GamePlayer>[])
  final List<GamePlayer>? gamePlayers;
  @JsonKey(name: 'gameRoundWinners', defaultValue: <GameRoundWinner>[])
  final List<GameRoundWinner>? gameRoundWinners;
  @JsonKey(name: 'moves', defaultValue: <Move>[])
  final List<Move>? moves;
  @JsonKey(name: 'playerCards', defaultValue: <PlayerCard>[])
  final List<PlayerCard>? playerCards;
  @JsonKey(name: 'purchases', defaultValue: <Purchase>[])
  final List<Purchase>? purchases;
  @JsonKey(name: 'userModels', defaultValue: <UserModel>[])
  final List<UserModel>? userModels;
  static const fromJsonFactory = _$UserFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is User &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.passwordHash, passwordHash) ||
                const DeepCollectionEquality()
                    .equals(other.passwordHash, passwordHash)) &&
            (identical(other.chipsBalance, chipsBalance) ||
                const DeepCollectionEquality()
                    .equals(other.chipsBalance, chipsBalance)) &&
            (identical(other.avatarImage, avatarImage) ||
                const DeepCollectionEquality()
                    .equals(other.avatarImage, avatarImage)) &&
            (identical(other.avatarType, avatarType) ||
                const DeepCollectionEquality()
                    .equals(other.avatarType, avatarType)) &&
            (identical(other.registrationDate, registrationDate) ||
                const DeepCollectionEquality()
                    .equals(other.registrationDate, registrationDate)) &&
            (identical(other.lastLoginDate, lastLoginDate) ||
                const DeepCollectionEquality()
                    .equals(other.lastLoginDate, lastLoginDate)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.isBot, isBot) ||
                const DeepCollectionEquality().equals(other.isBot, isBot)) &&
            (identical(other.chipTransactions, chipTransactions) ||
                const DeepCollectionEquality()
                    .equals(other.chipTransactions, chipTransactions)) &&
            (identical(other.gamePlayers, gamePlayers) ||
                const DeepCollectionEquality()
                    .equals(other.gamePlayers, gamePlayers)) &&
            (identical(other.gameRoundWinners, gameRoundWinners) ||
                const DeepCollectionEquality()
                    .equals(other.gameRoundWinners, gameRoundWinners)) &&
            (identical(other.moves, moves) ||
                const DeepCollectionEquality().equals(other.moves, moves)) &&
            (identical(other.playerCards, playerCards) ||
                const DeepCollectionEquality()
                    .equals(other.playerCards, playerCards)) &&
            (identical(other.purchases, purchases) ||
                const DeepCollectionEquality()
                    .equals(other.purchases, purchases)) &&
            (identical(other.userModels, userModels) ||
                const DeepCollectionEquality()
                    .equals(other.userModels, userModels)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(passwordHash) ^
      const DeepCollectionEquality().hash(chipsBalance) ^
      const DeepCollectionEquality().hash(avatarImage) ^
      const DeepCollectionEquality().hash(avatarType) ^
      const DeepCollectionEquality().hash(registrationDate) ^
      const DeepCollectionEquality().hash(lastLoginDate) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(isBot) ^
      const DeepCollectionEquality().hash(chipTransactions) ^
      const DeepCollectionEquality().hash(gamePlayers) ^
      const DeepCollectionEquality().hash(gameRoundWinners) ^
      const DeepCollectionEquality().hash(moves) ^
      const DeepCollectionEquality().hash(playerCards) ^
      const DeepCollectionEquality().hash(purchases) ^
      const DeepCollectionEquality().hash(userModels) ^
      runtimeType.hashCode;
}

extension $UserExtension on User {
  User copyWith(
      {int? userId,
      String? username,
      String? email,
      String? passwordHash,
      int? chipsBalance,
      String? avatarImage,
      String? avatarType,
      DateTime? registrationDate,
      DateTime? lastLoginDate,
      bool? isActive,
      bool? isBot,
      List<ChipTransaction>? chipTransactions,
      List<GamePlayer>? gamePlayers,
      List<GameRoundWinner>? gameRoundWinners,
      List<Move>? moves,
      List<PlayerCard>? playerCards,
      List<Purchase>? purchases,
      List<UserModel>? userModels}) {
    return User(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        email: email ?? this.email,
        passwordHash: passwordHash ?? this.passwordHash,
        chipsBalance: chipsBalance ?? this.chipsBalance,
        avatarImage: avatarImage ?? this.avatarImage,
        avatarType: avatarType ?? this.avatarType,
        registrationDate: registrationDate ?? this.registrationDate,
        lastLoginDate: lastLoginDate ?? this.lastLoginDate,
        isActive: isActive ?? this.isActive,
        isBot: isBot ?? this.isBot,
        chipTransactions: chipTransactions ?? this.chipTransactions,
        gamePlayers: gamePlayers ?? this.gamePlayers,
        gameRoundWinners: gameRoundWinners ?? this.gameRoundWinners,
        moves: moves ?? this.moves,
        playerCards: playerCards ?? this.playerCards,
        purchases: purchases ?? this.purchases,
        userModels: userModels ?? this.userModels);
  }

  User copyWithWrapped(
      {Wrapped<int?>? userId,
      Wrapped<String?>? username,
      Wrapped<String?>? email,
      Wrapped<String?>? passwordHash,
      Wrapped<int?>? chipsBalance,
      Wrapped<String?>? avatarImage,
      Wrapped<String?>? avatarType,
      Wrapped<DateTime?>? registrationDate,
      Wrapped<DateTime?>? lastLoginDate,
      Wrapped<bool?>? isActive,
      Wrapped<bool?>? isBot,
      Wrapped<List<ChipTransaction>?>? chipTransactions,
      Wrapped<List<GamePlayer>?>? gamePlayers,
      Wrapped<List<GameRoundWinner>?>? gameRoundWinners,
      Wrapped<List<Move>?>? moves,
      Wrapped<List<PlayerCard>?>? playerCards,
      Wrapped<List<Purchase>?>? purchases,
      Wrapped<List<UserModel>?>? userModels}) {
    return User(
        userId: (userId != null ? userId.value : this.userId),
        username: (username != null ? username.value : this.username),
        email: (email != null ? email.value : this.email),
        passwordHash:
            (passwordHash != null ? passwordHash.value : this.passwordHash),
        chipsBalance:
            (chipsBalance != null ? chipsBalance.value : this.chipsBalance),
        avatarImage:
            (avatarImage != null ? avatarImage.value : this.avatarImage),
        avatarType: (avatarType != null ? avatarType.value : this.avatarType),
        registrationDate: (registrationDate != null
            ? registrationDate.value
            : this.registrationDate),
        lastLoginDate:
            (lastLoginDate != null ? lastLoginDate.value : this.lastLoginDate),
        isActive: (isActive != null ? isActive.value : this.isActive),
        isBot: (isBot != null ? isBot.value : this.isBot),
        chipTransactions: (chipTransactions != null
            ? chipTransactions.value
            : this.chipTransactions),
        gamePlayers:
            (gamePlayers != null ? gamePlayers.value : this.gamePlayers),
        gameRoundWinners: (gameRoundWinners != null
            ? gameRoundWinners.value
            : this.gameRoundWinners),
        moves: (moves != null ? moves.value : this.moves),
        playerCards:
            (playerCards != null ? playerCards.value : this.playerCards),
        purchases: (purchases != null ? purchases.value : this.purchases),
        userModels: (userModels != null ? userModels.value : this.userModels));
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
      String? token}) {
    return UserDto(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        email: email ?? this.email,
        chipsBalance: chipsBalance ?? this.chipsBalance,
        avatarImage: avatarImage ?? this.avatarImage,
        token: token ?? this.token);
  }

  UserDto copyWithWrapped(
      {Wrapped<int?>? userId,
      Wrapped<String?>? username,
      Wrapped<String?>? email,
      Wrapped<int?>? chipsBalance,
      Wrapped<String?>? avatarImage,
      Wrapped<String?>? token}) {
    return UserDto(
        userId: (userId != null ? userId.value : this.userId),
        username: (username != null ? username.value : this.username),
        email: (email != null ? email.value : this.email),
        chipsBalance:
            (chipsBalance != null ? chipsBalance.value : this.chipsBalance),
        avatarImage:
            (avatarImage != null ? avatarImage.value : this.avatarImage),
        token: (token != null ? token.value : this.token));
  }
}

@JsonSerializable(explicitToJson: true)
class UserModel {
  const UserModel({
    this.userModelId,
    this.userId,
    this.modelId,
    this.model,
    this.user,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  static const toJsonFactory = _$UserModelToJson;
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @JsonKey(name: 'userModelId', defaultValue: 0)
  final int? userModelId;
  @JsonKey(name: 'userId', defaultValue: 0)
  final int? userId;
  @JsonKey(name: 'modelId', defaultValue: 0)
  final int? modelId;
  @JsonKey(name: 'model')
  final Model? model;
  @JsonKey(name: 'user')
  final User? user;
  static const fromJsonFactory = _$UserModelFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserModel &&
            (identical(other.userModelId, userModelId) ||
                const DeepCollectionEquality()
                    .equals(other.userModelId, userModelId)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.modelId, modelId) ||
                const DeepCollectionEquality()
                    .equals(other.modelId, modelId)) &&
            (identical(other.model, model) ||
                const DeepCollectionEquality().equals(other.model, model)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(userModelId) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(modelId) ^
      const DeepCollectionEquality().hash(model) ^
      const DeepCollectionEquality().hash(user) ^
      runtimeType.hashCode;
}

extension $UserModelExtension on UserModel {
  UserModel copyWith(
      {int? userModelId, int? userId, int? modelId, Model? model, User? user}) {
    return UserModel(
        userModelId: userModelId ?? this.userModelId,
        userId: userId ?? this.userId,
        modelId: modelId ?? this.modelId,
        model: model ?? this.model,
        user: user ?? this.user);
  }

  UserModel copyWithWrapped(
      {Wrapped<int?>? userModelId,
      Wrapped<int?>? userId,
      Wrapped<int?>? modelId,
      Wrapped<Model?>? model,
      Wrapped<User?>? user}) {
    return UserModel(
        userModelId:
            (userModelId != null ? userModelId.value : this.userModelId),
        userId: (userId != null ? userId.value : this.userId),
        modelId: (modelId != null ? modelId.value : this.modelId),
        model: (model != null ? model.value : this.model),
        user: (user != null ? user.value : this.user));
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
