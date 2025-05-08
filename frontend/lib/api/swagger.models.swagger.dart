// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:convert';

part 'swagger.models.swagger.g.dart';

@JsonSerializable(explicitToJson: true)
class Card {
  const Card({
    this.cardId,
    required this.suit,
    required this.$value,
  });

  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);

  static const toJsonFactory = _$CardToJson;
  Map<String, dynamic> toJson() => _$CardToJson(this);

  @JsonKey(name: 'cardId')
  final int? cardId;
  @JsonKey(name: 'suit')
  final String suit;
  @JsonKey(name: 'value')
  final String $value;
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
                const DeepCollectionEquality().equals(other.$value, $value)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(cardId) ^
      const DeepCollectionEquality().hash(suit) ^
      const DeepCollectionEquality().hash($value) ^
      runtimeType.hashCode;
}

extension $CardExtension on Card {
  Card copyWith({int? cardId, String? suit, String? $value}) {
    return Card(
        cardId: cardId ?? this.cardId,
        suit: suit ?? this.suit,
        $value: $value ?? this.$value);
  }

  Card copyWithWrapped(
      {Wrapped<int?>? cardId, Wrapped<String>? suit, Wrapped<String>? $value}) {
    return Card(
        cardId: (cardId != null ? cardId.value : this.cardId),
        suit: (suit != null ? suit.value : this.suit),
        $value: ($value != null ? $value.value : this.$value));
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
    this.user,
    this.amount,
    required this.transactionType,
    this.referenceId,
    this.transactionDate,
    this.description,
  });

  factory ChipTransaction.fromJson(Map<String, dynamic> json) =>
      _$ChipTransactionFromJson(json);

  static const toJsonFactory = _$ChipTransactionToJson;
  Map<String, dynamic> toJson() => _$ChipTransactionToJson(this);

  @JsonKey(name: 'transactionId')
  final int? transactionId;
  @JsonKey(name: 'userId')
  final int? userId;
  @JsonKey(name: 'user')
  final User? user;
  @JsonKey(name: 'amount')
  final int? amount;
  @JsonKey(name: 'transactionType')
  final String transactionType;
  @JsonKey(name: 'referenceId')
  final int? referenceId;
  @JsonKey(name: 'transactionDate')
  final DateTime? transactionDate;
  @JsonKey(name: 'description')
  final String? description;
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
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
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
                    .equals(other.description, description)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(transactionId) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(amount) ^
      const DeepCollectionEquality().hash(transactionType) ^
      const DeepCollectionEquality().hash(referenceId) ^
      const DeepCollectionEquality().hash(transactionDate) ^
      const DeepCollectionEquality().hash(description) ^
      runtimeType.hashCode;
}

extension $ChipTransactionExtension on ChipTransaction {
  ChipTransaction copyWith(
      {int? transactionId,
      int? userId,
      User? user,
      int? amount,
      String? transactionType,
      int? referenceId,
      DateTime? transactionDate,
      String? description}) {
    return ChipTransaction(
        transactionId: transactionId ?? this.transactionId,
        userId: userId ?? this.userId,
        user: user ?? this.user,
        amount: amount ?? this.amount,
        transactionType: transactionType ?? this.transactionType,
        referenceId: referenceId ?? this.referenceId,
        transactionDate: transactionDate ?? this.transactionDate,
        description: description ?? this.description);
  }

  ChipTransaction copyWithWrapped(
      {Wrapped<int?>? transactionId,
      Wrapped<int?>? userId,
      Wrapped<User?>? user,
      Wrapped<int?>? amount,
      Wrapped<String>? transactionType,
      Wrapped<int?>? referenceId,
      Wrapped<DateTime?>? transactionDate,
      Wrapped<String?>? description}) {
    return ChipTransaction(
        transactionId:
            (transactionId != null ? transactionId.value : this.transactionId),
        userId: (userId != null ? userId.value : this.userId),
        user: (user != null ? user.value : this.user),
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
            (description != null ? description.value : this.description));
  }
}

@JsonSerializable(explicitToJson: true)
class CommunityCard {
  const CommunityCard({
    this.communityCardId,
    this.gameId,
    this.game,
    this.cardId,
    this.card,
    this.position,
  });

  factory CommunityCard.fromJson(Map<String, dynamic> json) =>
      _$CommunityCardFromJson(json);

  static const toJsonFactory = _$CommunityCardToJson;
  Map<String, dynamic> toJson() => _$CommunityCardToJson(this);

  @JsonKey(name: 'communityCardId')
  final int? communityCardId;
  @JsonKey(name: 'gameId')
  final int? gameId;
  @JsonKey(name: 'game')
  final Game? game;
  @JsonKey(name: 'cardId')
  final int? cardId;
  @JsonKey(name: 'card')
  final Card? card;
  @JsonKey(name: 'position')
  final int? position;
  static const fromJsonFactory = _$CommunityCardFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CommunityCard &&
            (identical(other.communityCardId, communityCardId) ||
                const DeepCollectionEquality()
                    .equals(other.communityCardId, communityCardId)) &&
            (identical(other.gameId, gameId) ||
                const DeepCollectionEquality().equals(other.gameId, gameId)) &&
            (identical(other.game, game) ||
                const DeepCollectionEquality().equals(other.game, game)) &&
            (identical(other.cardId, cardId) ||
                const DeepCollectionEquality().equals(other.cardId, cardId)) &&
            (identical(other.card, card) ||
                const DeepCollectionEquality().equals(other.card, card)) &&
            (identical(other.position, position) ||
                const DeepCollectionEquality()
                    .equals(other.position, position)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(communityCardId) ^
      const DeepCollectionEquality().hash(gameId) ^
      const DeepCollectionEquality().hash(game) ^
      const DeepCollectionEquality().hash(cardId) ^
      const DeepCollectionEquality().hash(card) ^
      const DeepCollectionEquality().hash(position) ^
      runtimeType.hashCode;
}

extension $CommunityCardExtension on CommunityCard {
  CommunityCard copyWith(
      {int? communityCardId,
      int? gameId,
      Game? game,
      int? cardId,
      Card? card,
      int? position}) {
    return CommunityCard(
        communityCardId: communityCardId ?? this.communityCardId,
        gameId: gameId ?? this.gameId,
        game: game ?? this.game,
        cardId: cardId ?? this.cardId,
        card: card ?? this.card,
        position: position ?? this.position);
  }

  CommunityCard copyWithWrapped(
      {Wrapped<int?>? communityCardId,
      Wrapped<int?>? gameId,
      Wrapped<Game?>? game,
      Wrapped<int?>? cardId,
      Wrapped<Card?>? card,
      Wrapped<int?>? position}) {
    return CommunityCard(
        communityCardId: (communityCardId != null
            ? communityCardId.value
            : this.communityCardId),
        gameId: (gameId != null ? gameId.value : this.gameId),
        game: (game != null ? game.value : this.game),
        cardId: (cardId != null ? cardId.value : this.cardId),
        card: (card != null ? card.value : this.card),
        position: (position != null ? position.value : this.position));
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

  @JsonKey(name: 'tableId')
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
    this.table,
    this.startTime,
    this.endTime,
    required this.currentState,
    this.potSize,
    this.currentTurnUserId,
    this.currentTurnUser,
    this.gamePlayers,
    this.moves,
    this.communityCards,
    this.gameRounds,
  });

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  static const toJsonFactory = _$GameToJson;
  Map<String, dynamic> toJson() => _$GameToJson(this);

  @JsonKey(name: 'gameId')
  final int? gameId;
  @JsonKey(name: 'tableId')
  final int? tableId;
  @JsonKey(name: 'table')
  final PokerTable? table;
  @JsonKey(name: 'startTime')
  final DateTime? startTime;
  @JsonKey(name: 'endTime')
  final DateTime? endTime;
  @JsonKey(name: 'currentState')
  final String currentState;
  @JsonKey(name: 'potSize')
  final int? potSize;
  @JsonKey(name: 'currentTurnUserId')
  final int? currentTurnUserId;
  @JsonKey(name: 'currentTurnUser')
  final User? currentTurnUser;
  @JsonKey(name: 'gamePlayers', defaultValue: <GamePlayer>[])
  final List<GamePlayer>? gamePlayers;
  @JsonKey(name: 'moves', defaultValue: <Move>[])
  final List<Move>? moves;
  @JsonKey(name: 'communityCards', defaultValue: <CommunityCard>[])
  final List<CommunityCard>? communityCards;
  @JsonKey(name: 'gameRounds', defaultValue: <GameRound>[])
  final List<GameRound>? gameRounds;
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
            (identical(other.table, table) ||
                const DeepCollectionEquality().equals(other.table, table)) &&
            (identical(other.startTime, startTime) ||
                const DeepCollectionEquality()
                    .equals(other.startTime, startTime)) &&
            (identical(other.endTime, endTime) ||
                const DeepCollectionEquality()
                    .equals(other.endTime, endTime)) &&
            (identical(other.currentState, currentState) ||
                const DeepCollectionEquality()
                    .equals(other.currentState, currentState)) &&
            (identical(other.potSize, potSize) ||
                const DeepCollectionEquality()
                    .equals(other.potSize, potSize)) &&
            (identical(other.currentTurnUserId, currentTurnUserId) ||
                const DeepCollectionEquality()
                    .equals(other.currentTurnUserId, currentTurnUserId)) &&
            (identical(other.currentTurnUser, currentTurnUser) ||
                const DeepCollectionEquality()
                    .equals(other.currentTurnUser, currentTurnUser)) &&
            (identical(other.gamePlayers, gamePlayers) ||
                const DeepCollectionEquality()
                    .equals(other.gamePlayers, gamePlayers)) &&
            (identical(other.moves, moves) ||
                const DeepCollectionEquality().equals(other.moves, moves)) &&
            (identical(other.communityCards, communityCards) ||
                const DeepCollectionEquality()
                    .equals(other.communityCards, communityCards)) &&
            (identical(other.gameRounds, gameRounds) ||
                const DeepCollectionEquality()
                    .equals(other.gameRounds, gameRounds)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(gameId) ^
      const DeepCollectionEquality().hash(tableId) ^
      const DeepCollectionEquality().hash(table) ^
      const DeepCollectionEquality().hash(startTime) ^
      const DeepCollectionEquality().hash(endTime) ^
      const DeepCollectionEquality().hash(currentState) ^
      const DeepCollectionEquality().hash(potSize) ^
      const DeepCollectionEquality().hash(currentTurnUserId) ^
      const DeepCollectionEquality().hash(currentTurnUser) ^
      const DeepCollectionEquality().hash(gamePlayers) ^
      const DeepCollectionEquality().hash(moves) ^
      const DeepCollectionEquality().hash(communityCards) ^
      const DeepCollectionEquality().hash(gameRounds) ^
      runtimeType.hashCode;
}

extension $GameExtension on Game {
  Game copyWith(
      {int? gameId,
      int? tableId,
      PokerTable? table,
      DateTime? startTime,
      DateTime? endTime,
      String? currentState,
      int? potSize,
      int? currentTurnUserId,
      User? currentTurnUser,
      List<GamePlayer>? gamePlayers,
      List<Move>? moves,
      List<CommunityCard>? communityCards,
      List<GameRound>? gameRounds}) {
    return Game(
        gameId: gameId ?? this.gameId,
        tableId: tableId ?? this.tableId,
        table: table ?? this.table,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        currentState: currentState ?? this.currentState,
        potSize: potSize ?? this.potSize,
        currentTurnUserId: currentTurnUserId ?? this.currentTurnUserId,
        currentTurnUser: currentTurnUser ?? this.currentTurnUser,
        gamePlayers: gamePlayers ?? this.gamePlayers,
        moves: moves ?? this.moves,
        communityCards: communityCards ?? this.communityCards,
        gameRounds: gameRounds ?? this.gameRounds);
  }

  Game copyWithWrapped(
      {Wrapped<int?>? gameId,
      Wrapped<int?>? tableId,
      Wrapped<PokerTable?>? table,
      Wrapped<DateTime?>? startTime,
      Wrapped<DateTime?>? endTime,
      Wrapped<String>? currentState,
      Wrapped<int?>? potSize,
      Wrapped<int?>? currentTurnUserId,
      Wrapped<User?>? currentTurnUser,
      Wrapped<List<GamePlayer>?>? gamePlayers,
      Wrapped<List<Move>?>? moves,
      Wrapped<List<CommunityCard>?>? communityCards,
      Wrapped<List<GameRound>?>? gameRounds}) {
    return Game(
        gameId: (gameId != null ? gameId.value : this.gameId),
        tableId: (tableId != null ? tableId.value : this.tableId),
        table: (table != null ? table.value : this.table),
        startTime: (startTime != null ? startTime.value : this.startTime),
        endTime: (endTime != null ? endTime.value : this.endTime),
        currentState:
            (currentState != null ? currentState.value : this.currentState),
        potSize: (potSize != null ? potSize.value : this.potSize),
        currentTurnUserId: (currentTurnUserId != null
            ? currentTurnUserId.value
            : this.currentTurnUserId),
        currentTurnUser: (currentTurnUser != null
            ? currentTurnUser.value
            : this.currentTurnUser),
        gamePlayers:
            (gamePlayers != null ? gamePlayers.value : this.gamePlayers),
        moves: (moves != null ? moves.value : this.moves),
        communityCards: (communityCards != null
            ? communityCards.value
            : this.communityCards),
        gameRounds: (gameRounds != null ? gameRounds.value : this.gameRounds));
  }
}

@JsonSerializable(explicitToJson: true)
class GamePlayer {
  const GamePlayer({
    this.gamePlayerId,
    this.gameId,
    this.game,
    this.userId,
    this.user,
    this.seatPosition,
    this.initialChips,
    this.currentChips,
    this.isActive,
    this.isDealer,
    this.isSmallBlind,
    this.isBigBlind,
    this.playerCards,
  });

  factory GamePlayer.fromJson(Map<String, dynamic> json) =>
      _$GamePlayerFromJson(json);

  static const toJsonFactory = _$GamePlayerToJson;
  Map<String, dynamic> toJson() => _$GamePlayerToJson(this);

  @JsonKey(name: 'gamePlayerId')
  final int? gamePlayerId;
  @JsonKey(name: 'gameId')
  final int? gameId;
  @JsonKey(name: 'game')
  final Game? game;
  @JsonKey(name: 'userId')
  final int? userId;
  @JsonKey(name: 'user')
  final User? user;
  @JsonKey(name: 'seatPosition')
  final int? seatPosition;
  @JsonKey(name: 'initialChips')
  final int? initialChips;
  @JsonKey(name: 'currentChips')
  final int? currentChips;
  @JsonKey(name: 'isActive')
  final bool? isActive;
  @JsonKey(name: 'isDealer')
  final bool? isDealer;
  @JsonKey(name: 'isSmallBlind')
  final bool? isSmallBlind;
  @JsonKey(name: 'isBigBlind')
  final bool? isBigBlind;
  @JsonKey(name: 'playerCards', defaultValue: <PlayerCard>[])
  final List<PlayerCard>? playerCards;
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
            (identical(other.game, game) ||
                const DeepCollectionEquality().equals(other.game, game)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
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
            (identical(other.playerCards, playerCards) ||
                const DeepCollectionEquality()
                    .equals(other.playerCards, playerCards)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(gamePlayerId) ^
      const DeepCollectionEquality().hash(gameId) ^
      const DeepCollectionEquality().hash(game) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(seatPosition) ^
      const DeepCollectionEquality().hash(initialChips) ^
      const DeepCollectionEquality().hash(currentChips) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(isDealer) ^
      const DeepCollectionEquality().hash(isSmallBlind) ^
      const DeepCollectionEquality().hash(isBigBlind) ^
      const DeepCollectionEquality().hash(playerCards) ^
      runtimeType.hashCode;
}

extension $GamePlayerExtension on GamePlayer {
  GamePlayer copyWith(
      {int? gamePlayerId,
      int? gameId,
      Game? game,
      int? userId,
      User? user,
      int? seatPosition,
      int? initialChips,
      int? currentChips,
      bool? isActive,
      bool? isDealer,
      bool? isSmallBlind,
      bool? isBigBlind,
      List<PlayerCard>? playerCards}) {
    return GamePlayer(
        gamePlayerId: gamePlayerId ?? this.gamePlayerId,
        gameId: gameId ?? this.gameId,
        game: game ?? this.game,
        userId: userId ?? this.userId,
        user: user ?? this.user,
        seatPosition: seatPosition ?? this.seatPosition,
        initialChips: initialChips ?? this.initialChips,
        currentChips: currentChips ?? this.currentChips,
        isActive: isActive ?? this.isActive,
        isDealer: isDealer ?? this.isDealer,
        isSmallBlind: isSmallBlind ?? this.isSmallBlind,
        isBigBlind: isBigBlind ?? this.isBigBlind,
        playerCards: playerCards ?? this.playerCards);
  }

  GamePlayer copyWithWrapped(
      {Wrapped<int?>? gamePlayerId,
      Wrapped<int?>? gameId,
      Wrapped<Game?>? game,
      Wrapped<int?>? userId,
      Wrapped<User?>? user,
      Wrapped<int?>? seatPosition,
      Wrapped<int?>? initialChips,
      Wrapped<int?>? currentChips,
      Wrapped<bool?>? isActive,
      Wrapped<bool?>? isDealer,
      Wrapped<bool?>? isSmallBlind,
      Wrapped<bool?>? isBigBlind,
      Wrapped<List<PlayerCard>?>? playerCards}) {
    return GamePlayer(
        gamePlayerId:
            (gamePlayerId != null ? gamePlayerId.value : this.gamePlayerId),
        gameId: (gameId != null ? gameId.value : this.gameId),
        game: (game != null ? game.value : this.game),
        userId: (userId != null ? userId.value : this.userId),
        user: (user != null ? user.value : this.user),
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
        playerCards:
            (playerCards != null ? playerCards.value : this.playerCards));
  }
}

@JsonSerializable(explicitToJson: true)
class GameRound {
  const GameRound({
    this.gameRoundId,
    this.gameId,
    this.game,
    this.roundNumber,
    this.startTime,
    this.endTime,
    this.potSize,
    this.winners,
  });

  factory GameRound.fromJson(Map<String, dynamic> json) =>
      _$GameRoundFromJson(json);

  static const toJsonFactory = _$GameRoundToJson;
  Map<String, dynamic> toJson() => _$GameRoundToJson(this);

  @JsonKey(name: 'gameRoundId')
  final int? gameRoundId;
  @JsonKey(name: 'gameId')
  final int? gameId;
  @JsonKey(name: 'game')
  final Game? game;
  @JsonKey(name: 'roundNumber')
  final int? roundNumber;
  @JsonKey(name: 'startTime')
  final DateTime? startTime;
  @JsonKey(name: 'endTime')
  final DateTime? endTime;
  @JsonKey(name: 'potSize')
  final int? potSize;
  @JsonKey(name: 'winners', defaultValue: <GameRoundWinner>[])
  final List<GameRoundWinner>? winners;
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
            (identical(other.game, game) ||
                const DeepCollectionEquality().equals(other.game, game)) &&
            (identical(other.roundNumber, roundNumber) ||
                const DeepCollectionEquality()
                    .equals(other.roundNumber, roundNumber)) &&
            (identical(other.startTime, startTime) ||
                const DeepCollectionEquality()
                    .equals(other.startTime, startTime)) &&
            (identical(other.endTime, endTime) ||
                const DeepCollectionEquality()
                    .equals(other.endTime, endTime)) &&
            (identical(other.potSize, potSize) ||
                const DeepCollectionEquality()
                    .equals(other.potSize, potSize)) &&
            (identical(other.winners, winners) ||
                const DeepCollectionEquality().equals(other.winners, winners)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(gameRoundId) ^
      const DeepCollectionEquality().hash(gameId) ^
      const DeepCollectionEquality().hash(game) ^
      const DeepCollectionEquality().hash(roundNumber) ^
      const DeepCollectionEquality().hash(startTime) ^
      const DeepCollectionEquality().hash(endTime) ^
      const DeepCollectionEquality().hash(potSize) ^
      const DeepCollectionEquality().hash(winners) ^
      runtimeType.hashCode;
}

extension $GameRoundExtension on GameRound {
  GameRound copyWith(
      {int? gameRoundId,
      int? gameId,
      Game? game,
      int? roundNumber,
      DateTime? startTime,
      DateTime? endTime,
      int? potSize,
      List<GameRoundWinner>? winners}) {
    return GameRound(
        gameRoundId: gameRoundId ?? this.gameRoundId,
        gameId: gameId ?? this.gameId,
        game: game ?? this.game,
        roundNumber: roundNumber ?? this.roundNumber,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        potSize: potSize ?? this.potSize,
        winners: winners ?? this.winners);
  }

  GameRound copyWithWrapped(
      {Wrapped<int?>? gameRoundId,
      Wrapped<int?>? gameId,
      Wrapped<Game?>? game,
      Wrapped<int?>? roundNumber,
      Wrapped<DateTime?>? startTime,
      Wrapped<DateTime?>? endTime,
      Wrapped<int?>? potSize,
      Wrapped<List<GameRoundWinner>?>? winners}) {
    return GameRound(
        gameRoundId:
            (gameRoundId != null ? gameRoundId.value : this.gameRoundId),
        gameId: (gameId != null ? gameId.value : this.gameId),
        game: (game != null ? game.value : this.game),
        roundNumber:
            (roundNumber != null ? roundNumber.value : this.roundNumber),
        startTime: (startTime != null ? startTime.value : this.startTime),
        endTime: (endTime != null ? endTime.value : this.endTime),
        potSize: (potSize != null ? potSize.value : this.potSize),
        winners: (winners != null ? winners.value : this.winners));
  }
}

@JsonSerializable(explicitToJson: true)
class GameRoundWinner {
  const GameRoundWinner({
    this.gameRoundWinnerId,
    this.gameRoundId,
    this.gameRound,
    this.userId,
    this.user,
    this.amountWon,
  });

  factory GameRoundWinner.fromJson(Map<String, dynamic> json) =>
      _$GameRoundWinnerFromJson(json);

  static const toJsonFactory = _$GameRoundWinnerToJson;
  Map<String, dynamic> toJson() => _$GameRoundWinnerToJson(this);

  @JsonKey(name: 'gameRoundWinnerId')
  final int? gameRoundWinnerId;
  @JsonKey(name: 'gameRoundId')
  final int? gameRoundId;
  @JsonKey(name: 'gameRound')
  final GameRound? gameRound;
  @JsonKey(name: 'userId')
  final int? userId;
  @JsonKey(name: 'user')
  final User? user;
  @JsonKey(name: 'amountWon')
  final int? amountWon;
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
            (identical(other.gameRound, gameRound) ||
                const DeepCollectionEquality()
                    .equals(other.gameRound, gameRound)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
            (identical(other.amountWon, amountWon) ||
                const DeepCollectionEquality()
                    .equals(other.amountWon, amountWon)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(gameRoundWinnerId) ^
      const DeepCollectionEquality().hash(gameRoundId) ^
      const DeepCollectionEquality().hash(gameRound) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(amountWon) ^
      runtimeType.hashCode;
}

extension $GameRoundWinnerExtension on GameRoundWinner {
  GameRoundWinner copyWith(
      {int? gameRoundWinnerId,
      int? gameRoundId,
      GameRound? gameRound,
      int? userId,
      User? user,
      int? amountWon}) {
    return GameRoundWinner(
        gameRoundWinnerId: gameRoundWinnerId ?? this.gameRoundWinnerId,
        gameRoundId: gameRoundId ?? this.gameRoundId,
        gameRound: gameRound ?? this.gameRound,
        userId: userId ?? this.userId,
        user: user ?? this.user,
        amountWon: amountWon ?? this.amountWon);
  }

  GameRoundWinner copyWithWrapped(
      {Wrapped<int?>? gameRoundWinnerId,
      Wrapped<int?>? gameRoundId,
      Wrapped<GameRound?>? gameRound,
      Wrapped<int?>? userId,
      Wrapped<User?>? user,
      Wrapped<int?>? amountWon}) {
    return GameRoundWinner(
        gameRoundWinnerId: (gameRoundWinnerId != null
            ? gameRoundWinnerId.value
            : this.gameRoundWinnerId),
        gameRoundId:
            (gameRoundId != null ? gameRoundId.value : this.gameRoundId),
        gameRound: (gameRound != null ? gameRound.value : this.gameRound),
        userId: (userId != null ? userId.value : this.userId),
        user: (user != null ? user.value : this.user),
        amountWon: (amountWon != null ? amountWon.value : this.amountWon));
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

  @JsonKey(name: 'gameId')
  final int? gameId;
  @JsonKey(name: 'tableId')
  final int? tableId;
  @JsonKey(name: 'tableName')
  final String? tableName;
  @JsonKey(name: 'currentState')
  final String? currentState;
  @JsonKey(name: 'potSize')
  final int? potSize;
  @JsonKey(name: 'currentTurnUserId')
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
  @JsonKey(name: 'callAmount')
  final int? callAmount;
  @JsonKey(name: 'minRaiseAmount')
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

  @JsonKey(name: 'seatPosition')
  final int seatPosition;
  @JsonKey(name: 'buyInAmount')
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
  @JsonKey(name: 'amount')
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
class Move {
  const Move({
    this.moveId,
    this.gameId,
    this.game,
    this.gameRoundId,
    this.gameRound,
    this.playerId,
    this.player,
    required this.actionType,
    this.amount,
    this.moveTime,
    required this.round,
  });

  factory Move.fromJson(Map<String, dynamic> json) => _$MoveFromJson(json);

  static const toJsonFactory = _$MoveToJson;
  Map<String, dynamic> toJson() => _$MoveToJson(this);

  @JsonKey(name: 'moveId')
  final int? moveId;
  @JsonKey(name: 'gameId')
  final int? gameId;
  @JsonKey(name: 'game')
  final Game? game;
  @JsonKey(name: 'gameRoundId')
  final int? gameRoundId;
  @JsonKey(name: 'gameRound')
  final GameRound? gameRound;
  @JsonKey(name: 'playerId')
  final int? playerId;
  @JsonKey(name: 'player')
  final User? player;
  @JsonKey(name: 'actionType')
  final String actionType;
  @JsonKey(name: 'amount')
  final int? amount;
  @JsonKey(name: 'moveTime')
  final DateTime? moveTime;
  @JsonKey(name: 'round')
  final String round;
  static const fromJsonFactory = _$MoveFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Move &&
            (identical(other.moveId, moveId) ||
                const DeepCollectionEquality().equals(other.moveId, moveId)) &&
            (identical(other.gameId, gameId) ||
                const DeepCollectionEquality().equals(other.gameId, gameId)) &&
            (identical(other.game, game) ||
                const DeepCollectionEquality().equals(other.game, game)) &&
            (identical(other.gameRoundId, gameRoundId) ||
                const DeepCollectionEquality()
                    .equals(other.gameRoundId, gameRoundId)) &&
            (identical(other.gameRound, gameRound) ||
                const DeepCollectionEquality()
                    .equals(other.gameRound, gameRound)) &&
            (identical(other.playerId, playerId) ||
                const DeepCollectionEquality()
                    .equals(other.playerId, playerId)) &&
            (identical(other.player, player) ||
                const DeepCollectionEquality().equals(other.player, player)) &&
            (identical(other.actionType, actionType) ||
                const DeepCollectionEquality()
                    .equals(other.actionType, actionType)) &&
            (identical(other.amount, amount) ||
                const DeepCollectionEquality().equals(other.amount, amount)) &&
            (identical(other.moveTime, moveTime) ||
                const DeepCollectionEquality()
                    .equals(other.moveTime, moveTime)) &&
            (identical(other.round, round) ||
                const DeepCollectionEquality().equals(other.round, round)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(moveId) ^
      const DeepCollectionEquality().hash(gameId) ^
      const DeepCollectionEquality().hash(game) ^
      const DeepCollectionEquality().hash(gameRoundId) ^
      const DeepCollectionEquality().hash(gameRound) ^
      const DeepCollectionEquality().hash(playerId) ^
      const DeepCollectionEquality().hash(player) ^
      const DeepCollectionEquality().hash(actionType) ^
      const DeepCollectionEquality().hash(amount) ^
      const DeepCollectionEquality().hash(moveTime) ^
      const DeepCollectionEquality().hash(round) ^
      runtimeType.hashCode;
}

extension $MoveExtension on Move {
  Move copyWith(
      {int? moveId,
      int? gameId,
      Game? game,
      int? gameRoundId,
      GameRound? gameRound,
      int? playerId,
      User? player,
      String? actionType,
      int? amount,
      DateTime? moveTime,
      String? round}) {
    return Move(
        moveId: moveId ?? this.moveId,
        gameId: gameId ?? this.gameId,
        game: game ?? this.game,
        gameRoundId: gameRoundId ?? this.gameRoundId,
        gameRound: gameRound ?? this.gameRound,
        playerId: playerId ?? this.playerId,
        player: player ?? this.player,
        actionType: actionType ?? this.actionType,
        amount: amount ?? this.amount,
        moveTime: moveTime ?? this.moveTime,
        round: round ?? this.round);
  }

  Move copyWithWrapped(
      {Wrapped<int?>? moveId,
      Wrapped<int?>? gameId,
      Wrapped<Game?>? game,
      Wrapped<int?>? gameRoundId,
      Wrapped<GameRound?>? gameRound,
      Wrapped<int?>? playerId,
      Wrapped<User?>? player,
      Wrapped<String>? actionType,
      Wrapped<int?>? amount,
      Wrapped<DateTime?>? moveTime,
      Wrapped<String>? round}) {
    return Move(
        moveId: (moveId != null ? moveId.value : this.moveId),
        gameId: (gameId != null ? gameId.value : this.gameId),
        game: (game != null ? game.value : this.game),
        gameRoundId:
            (gameRoundId != null ? gameRoundId.value : this.gameRoundId),
        gameRound: (gameRound != null ? gameRound.value : this.gameRound),
        playerId: (playerId != null ? playerId.value : this.playerId),
        player: (player != null ? player.value : this.player),
        actionType: (actionType != null ? actionType.value : this.actionType),
        amount: (amount != null ? amount.value : this.amount),
        moveTime: (moveTime != null ? moveTime.value : this.moveTime),
        round: (round != null ? round.value : this.round));
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

  @JsonKey(name: 'playerId')
  final int? playerId;
  @JsonKey(name: 'actionType')
  final String? actionType;
  @JsonKey(name: 'amount')
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
    this.gamePlayer,
    this.cardId,
    this.card,
    this.position,
  });

  factory PlayerCard.fromJson(Map<String, dynamic> json) =>
      _$PlayerCardFromJson(json);

  static const toJsonFactory = _$PlayerCardToJson;
  Map<String, dynamic> toJson() => _$PlayerCardToJson(this);

  @JsonKey(name: 'playerCardId')
  final int? playerCardId;
  @JsonKey(name: 'gamePlayerId')
  final int? gamePlayerId;
  @JsonKey(name: 'gamePlayer')
  final GamePlayer? gamePlayer;
  @JsonKey(name: 'cardId')
  final int? cardId;
  @JsonKey(name: 'card')
  final Card? card;
  @JsonKey(name: 'position')
  final int? position;
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
            (identical(other.gamePlayer, gamePlayer) ||
                const DeepCollectionEquality()
                    .equals(other.gamePlayer, gamePlayer)) &&
            (identical(other.cardId, cardId) ||
                const DeepCollectionEquality().equals(other.cardId, cardId)) &&
            (identical(other.card, card) ||
                const DeepCollectionEquality().equals(other.card, card)) &&
            (identical(other.position, position) ||
                const DeepCollectionEquality()
                    .equals(other.position, position)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(playerCardId) ^
      const DeepCollectionEquality().hash(gamePlayerId) ^
      const DeepCollectionEquality().hash(gamePlayer) ^
      const DeepCollectionEquality().hash(cardId) ^
      const DeepCollectionEquality().hash(card) ^
      const DeepCollectionEquality().hash(position) ^
      runtimeType.hashCode;
}

extension $PlayerCardExtension on PlayerCard {
  PlayerCard copyWith(
      {int? playerCardId,
      int? gamePlayerId,
      GamePlayer? gamePlayer,
      int? cardId,
      Card? card,
      int? position}) {
    return PlayerCard(
        playerCardId: playerCardId ?? this.playerCardId,
        gamePlayerId: gamePlayerId ?? this.gamePlayerId,
        gamePlayer: gamePlayer ?? this.gamePlayer,
        cardId: cardId ?? this.cardId,
        card: card ?? this.card,
        position: position ?? this.position);
  }

  PlayerCard copyWithWrapped(
      {Wrapped<int?>? playerCardId,
      Wrapped<int?>? gamePlayerId,
      Wrapped<GamePlayer?>? gamePlayer,
      Wrapped<int?>? cardId,
      Wrapped<Card?>? card,
      Wrapped<int?>? position}) {
    return PlayerCard(
        playerCardId:
            (playerCardId != null ? playerCardId.value : this.playerCardId),
        gamePlayerId:
            (gamePlayerId != null ? gamePlayerId.value : this.gamePlayerId),
        gamePlayer: (gamePlayer != null ? gamePlayer.value : this.gamePlayer),
        cardId: (cardId != null ? cardId.value : this.cardId),
        card: (card != null ? card.value : this.card),
        position: (position != null ? position.value : this.position));
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

  @JsonKey(name: 'userId')
  final int? userId;
  @JsonKey(name: 'username')
  final String? username;
  @JsonKey(name: 'currentChips')
  final int? currentChips;
  @JsonKey(name: 'isActive')
  final bool? isActive;
  @JsonKey(name: 'isDealer')
  final bool? isDealer;
  @JsonKey(name: 'isSmallBlind')
  final bool? isSmallBlind;
  @JsonKey(name: 'isBigBlind')
  final bool? isBigBlind;
  @JsonKey(name: 'seatPosition')
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
    required this.name,
    this.entryFee,
    this.minBuyIn,
    this.maxBuyIn,
    this.smallBlind,
    this.bigBlind,
    this.maxPlayers,
    required this.difficultyLevel,
    this.isActive,
    this.games,
  });

  factory PokerTable.fromJson(Map<String, dynamic> json) =>
      _$PokerTableFromJson(json);

  static const toJsonFactory = _$PokerTableToJson;
  Map<String, dynamic> toJson() => _$PokerTableToJson(this);

  @JsonKey(name: 'tableId')
  final int? tableId;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'entryFee')
  final int? entryFee;
  @JsonKey(name: 'minBuyIn')
  final int? minBuyIn;
  @JsonKey(name: 'maxBuyIn')
  final int? maxBuyIn;
  @JsonKey(name: 'smallBlind')
  final int? smallBlind;
  @JsonKey(name: 'bigBlind')
  final int? bigBlind;
  @JsonKey(name: 'maxPlayers')
  final int? maxPlayers;
  @JsonKey(name: 'difficultyLevel')
  final String difficultyLevel;
  @JsonKey(name: 'isActive')
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
      Wrapped<String>? name,
      Wrapped<int?>? entryFee,
      Wrapped<int?>? minBuyIn,
      Wrapped<int?>? maxBuyIn,
      Wrapped<int?>? smallBlind,
      Wrapped<int?>? bigBlind,
      Wrapped<int?>? maxPlayers,
      Wrapped<String>? difficultyLevel,
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
    this.user,
    this.itemId,
    this.shopItem,
    this.purchaseDate,
    this.price,
    this.paymentMethod,
    this.transactionId,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) =>
      _$PurchaseFromJson(json);

  static const toJsonFactory = _$PurchaseToJson;
  Map<String, dynamic> toJson() => _$PurchaseToJson(this);

  @JsonKey(name: 'purchaseId')
  final int? purchaseId;
  @JsonKey(name: 'userId')
  final int? userId;
  @JsonKey(name: 'user')
  final User? user;
  @JsonKey(name: 'itemId')
  final int? itemId;
  @JsonKey(name: 'shopItem')
  final ShopItem? shopItem;
  @JsonKey(name: 'purchaseDate')
  final DateTime? purchaseDate;
  @JsonKey(name: 'price')
  final double? price;
  @JsonKey(name: 'paymentMethod')
  final String? paymentMethod;
  @JsonKey(name: 'transactionId')
  final String? transactionId;
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
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
            (identical(other.itemId, itemId) ||
                const DeepCollectionEquality().equals(other.itemId, itemId)) &&
            (identical(other.shopItem, shopItem) ||
                const DeepCollectionEquality()
                    .equals(other.shopItem, shopItem)) &&
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
                    .equals(other.transactionId, transactionId)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(purchaseId) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(itemId) ^
      const DeepCollectionEquality().hash(shopItem) ^
      const DeepCollectionEquality().hash(purchaseDate) ^
      const DeepCollectionEquality().hash(price) ^
      const DeepCollectionEquality().hash(paymentMethod) ^
      const DeepCollectionEquality().hash(transactionId) ^
      runtimeType.hashCode;
}

extension $PurchaseExtension on Purchase {
  Purchase copyWith(
      {int? purchaseId,
      int? userId,
      User? user,
      int? itemId,
      ShopItem? shopItem,
      DateTime? purchaseDate,
      double? price,
      String? paymentMethod,
      String? transactionId}) {
    return Purchase(
        purchaseId: purchaseId ?? this.purchaseId,
        userId: userId ?? this.userId,
        user: user ?? this.user,
        itemId: itemId ?? this.itemId,
        shopItem: shopItem ?? this.shopItem,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        price: price ?? this.price,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        transactionId: transactionId ?? this.transactionId);
  }

  Purchase copyWithWrapped(
      {Wrapped<int?>? purchaseId,
      Wrapped<int?>? userId,
      Wrapped<User?>? user,
      Wrapped<int?>? itemId,
      Wrapped<ShopItem?>? shopItem,
      Wrapped<DateTime?>? purchaseDate,
      Wrapped<double?>? price,
      Wrapped<String?>? paymentMethod,
      Wrapped<String?>? transactionId}) {
    return Purchase(
        purchaseId: (purchaseId != null ? purchaseId.value : this.purchaseId),
        userId: (userId != null ? userId.value : this.userId),
        user: (user != null ? user.value : this.user),
        itemId: (itemId != null ? itemId.value : this.itemId),
        shopItem: (shopItem != null ? shopItem.value : this.shopItem),
        purchaseDate:
            (purchaseDate != null ? purchaseDate.value : this.purchaseDate),
        price: (price != null ? price.value : this.price),
        paymentMethod:
            (paymentMethod != null ? paymentMethod.value : this.paymentMethod),
        transactionId:
            (transactionId != null ? transactionId.value : this.transactionId));
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

  @JsonKey(name: 'userId')
  final int? userId;
  @JsonKey(name: 'username')
  final String? username;
  @JsonKey(name: 'amountWon')
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
    required this.name,
    this.description,
    this.price,
    required this.itemType,
    this.isActive,
    this.purchases,
  });

  factory ShopItem.fromJson(Map<String, dynamic> json) =>
      _$ShopItemFromJson(json);

  static const toJsonFactory = _$ShopItemToJson;
  Map<String, dynamic> toJson() => _$ShopItemToJson(this);

  @JsonKey(name: 'itemId')
  final int? itemId;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'price')
  final double? price;
  @JsonKey(name: 'itemType')
  final String itemType;
  @JsonKey(name: 'isActive')
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
      String? itemType,
      bool? isActive,
      List<Purchase>? purchases}) {
    return ShopItem(
        itemId: itemId ?? this.itemId,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        itemType: itemType ?? this.itemType,
        isActive: isActive ?? this.isActive,
        purchases: purchases ?? this.purchases);
  }

  ShopItem copyWithWrapped(
      {Wrapped<int?>? itemId,
      Wrapped<String>? name,
      Wrapped<String?>? description,
      Wrapped<double?>? price,
      Wrapped<String>? itemType,
      Wrapped<bool?>? isActive,
      Wrapped<List<Purchase>?>? purchases}) {
    return ShopItem(
        itemId: (itemId != null ? itemId.value : this.itemId),
        name: (name != null ? name.value : this.name),
        description:
            (description != null ? description.value : this.description),
        price: (price != null ? price.value : this.price),
        itemType: (itemType != null ? itemType.value : this.itemType),
        isActive: (isActive != null ? isActive.value : this.isActive),
        purchases: (purchases != null ? purchases.value : this.purchases));
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
    required this.username,
    required this.email,
    required this.passwordHash,
    this.chipsBalance,
    this.avatarImage,
    this.registrationDate,
    this.lastLoginDate,
    this.isActive,
    this.gamePlayers,
    this.purchases,
    this.chipTransactions,
    this.gameRoundWinners,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  static const toJsonFactory = _$UserToJson;
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @JsonKey(name: 'userId')
  final int? userId;
  @JsonKey(name: 'username')
  final String username;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'passwordHash')
  final String passwordHash;
  @JsonKey(name: 'chipsBalance')
  final int? chipsBalance;
  @JsonKey(name: 'avatarImage')
  final String? avatarImage;
  @JsonKey(name: 'registrationDate')
  final DateTime? registrationDate;
  @JsonKey(name: 'lastLoginDate')
  final DateTime? lastLoginDate;
  @JsonKey(name: 'isActive')
  final bool? isActive;
  @JsonKey(name: 'gamePlayers', defaultValue: <GamePlayer>[])
  final List<GamePlayer>? gamePlayers;
  @JsonKey(name: 'purchases', defaultValue: <Purchase>[])
  final List<Purchase>? purchases;
  @JsonKey(name: 'chipTransactions', defaultValue: <ChipTransaction>[])
  final List<ChipTransaction>? chipTransactions;
  @JsonKey(name: 'gameRoundWinners', defaultValue: <GameRoundWinner>[])
  final List<GameRoundWinner>? gameRoundWinners;
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
            (identical(other.registrationDate, registrationDate) ||
                const DeepCollectionEquality()
                    .equals(other.registrationDate, registrationDate)) &&
            (identical(other.lastLoginDate, lastLoginDate) ||
                const DeepCollectionEquality()
                    .equals(other.lastLoginDate, lastLoginDate)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.gamePlayers, gamePlayers) ||
                const DeepCollectionEquality()
                    .equals(other.gamePlayers, gamePlayers)) &&
            (identical(other.purchases, purchases) ||
                const DeepCollectionEquality()
                    .equals(other.purchases, purchases)) &&
            (identical(other.chipTransactions, chipTransactions) ||
                const DeepCollectionEquality()
                    .equals(other.chipTransactions, chipTransactions)) &&
            (identical(other.gameRoundWinners, gameRoundWinners) ||
                const DeepCollectionEquality()
                    .equals(other.gameRoundWinners, gameRoundWinners)));
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
      const DeepCollectionEquality().hash(registrationDate) ^
      const DeepCollectionEquality().hash(lastLoginDate) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(gamePlayers) ^
      const DeepCollectionEquality().hash(purchases) ^
      const DeepCollectionEquality().hash(chipTransactions) ^
      const DeepCollectionEquality().hash(gameRoundWinners) ^
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
      DateTime? registrationDate,
      DateTime? lastLoginDate,
      bool? isActive,
      List<GamePlayer>? gamePlayers,
      List<Purchase>? purchases,
      List<ChipTransaction>? chipTransactions,
      List<GameRoundWinner>? gameRoundWinners}) {
    return User(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        email: email ?? this.email,
        passwordHash: passwordHash ?? this.passwordHash,
        chipsBalance: chipsBalance ?? this.chipsBalance,
        avatarImage: avatarImage ?? this.avatarImage,
        registrationDate: registrationDate ?? this.registrationDate,
        lastLoginDate: lastLoginDate ?? this.lastLoginDate,
        isActive: isActive ?? this.isActive,
        gamePlayers: gamePlayers ?? this.gamePlayers,
        purchases: purchases ?? this.purchases,
        chipTransactions: chipTransactions ?? this.chipTransactions,
        gameRoundWinners: gameRoundWinners ?? this.gameRoundWinners);
  }

  User copyWithWrapped(
      {Wrapped<int?>? userId,
      Wrapped<String>? username,
      Wrapped<String>? email,
      Wrapped<String>? passwordHash,
      Wrapped<int?>? chipsBalance,
      Wrapped<String?>? avatarImage,
      Wrapped<DateTime?>? registrationDate,
      Wrapped<DateTime?>? lastLoginDate,
      Wrapped<bool?>? isActive,
      Wrapped<List<GamePlayer>?>? gamePlayers,
      Wrapped<List<Purchase>?>? purchases,
      Wrapped<List<ChipTransaction>?>? chipTransactions,
      Wrapped<List<GameRoundWinner>?>? gameRoundWinners}) {
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
        registrationDate: (registrationDate != null
            ? registrationDate.value
            : this.registrationDate),
        lastLoginDate:
            (lastLoginDate != null ? lastLoginDate.value : this.lastLoginDate),
        isActive: (isActive != null ? isActive.value : this.isActive),
        gamePlayers:
            (gamePlayers != null ? gamePlayers.value : this.gamePlayers),
        purchases: (purchases != null ? purchases.value : this.purchases),
        chipTransactions: (chipTransactions != null
            ? chipTransactions.value
            : this.chipTransactions),
        gameRoundWinners: (gameRoundWinners != null
            ? gameRoundWinners.value
            : this.gameRoundWinners));
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

  @JsonKey(name: 'userId')
  final int? userId;
  @JsonKey(name: 'username')
  final String? username;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'chipsBalance')
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
