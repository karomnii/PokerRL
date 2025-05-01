// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:convert';

part 'swagger.models.swagger.g.dart';

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

  @JsonKey(name: 'cardId')
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

  @JsonKey(name: 'transactionId')
  final int? transactionId;
  @JsonKey(name: 'userId')
  final int? userId;
  @JsonKey(name: 'amount')
  final int? amount;
  @JsonKey(name: 'transactionType')
  final String? transactionType;
  @JsonKey(name: 'referenceId')
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
class CommunityCard {
  const CommunityCard({
    this.communityCardId,
    this.gameId,
    this.cardId,
    this.position,
    this.game,
    this.card,
  });

  factory CommunityCard.fromJson(Map<String, dynamic> json) =>
      _$CommunityCardFromJson(json);

  static const toJsonFactory = _$CommunityCardToJson;
  Map<String, dynamic> toJson() => _$CommunityCardToJson(this);

  @JsonKey(name: 'communityCardId')
  final int? communityCardId;
  @JsonKey(name: 'gameId')
  final int? gameId;
  @JsonKey(name: 'cardId')
  final int? cardId;
  @JsonKey(name: 'position')
  final int? position;
  @JsonKey(name: 'game')
  final Game? game;
  @JsonKey(name: 'card')
  final Card? card;
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
            (identical(other.cardId, cardId) ||
                const DeepCollectionEquality().equals(other.cardId, cardId)) &&
            (identical(other.position, position) ||
                const DeepCollectionEquality()
                    .equals(other.position, position)) &&
            (identical(other.game, game) ||
                const DeepCollectionEquality().equals(other.game, game)) &&
            (identical(other.card, card) ||
                const DeepCollectionEquality().equals(other.card, card)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(communityCardId) ^
      const DeepCollectionEquality().hash(gameId) ^
      const DeepCollectionEquality().hash(cardId) ^
      const DeepCollectionEquality().hash(position) ^
      const DeepCollectionEquality().hash(game) ^
      const DeepCollectionEquality().hash(card) ^
      runtimeType.hashCode;
}

extension $CommunityCardExtension on CommunityCard {
  CommunityCard copyWith(
      {int? communityCardId,
      int? gameId,
      int? cardId,
      int? position,
      Game? game,
      Card? card}) {
    return CommunityCard(
        communityCardId: communityCardId ?? this.communityCardId,
        gameId: gameId ?? this.gameId,
        cardId: cardId ?? this.cardId,
        position: position ?? this.position,
        game: game ?? this.game,
        card: card ?? this.card);
  }

  CommunityCard copyWithWrapped(
      {Wrapped<int?>? communityCardId,
      Wrapped<int?>? gameId,
      Wrapped<int?>? cardId,
      Wrapped<int?>? position,
      Wrapped<Game?>? game,
      Wrapped<Card?>? card}) {
    return CommunityCard(
        communityCardId: (communityCardId != null
            ? communityCardId.value
            : this.communityCardId),
        gameId: (gameId != null ? gameId.value : this.gameId),
        cardId: (cardId != null ? cardId.value : this.cardId),
        position: (position != null ? position.value : this.position),
        game: (game != null ? game.value : this.game),
        card: (card != null ? card.value : this.card));
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
    this.startTime,
    this.endTime,
    this.currentState,
    this.potSize,
    this.winnerId,
    this.table,
    this.winner,
    this.gamePlayers,
    this.moves,
    this.communityCards,
  });

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  static const toJsonFactory = _$GameToJson;
  Map<String, dynamic> toJson() => _$GameToJson(this);

  @JsonKey(name: 'gameId')
  final int? gameId;
  @JsonKey(name: 'tableId')
  final int? tableId;
  @JsonKey(name: 'startTime')
  final DateTime? startTime;
  @JsonKey(name: 'endTime')
  final DateTime? endTime;
  @JsonKey(name: 'currentState')
  final String? currentState;
  @JsonKey(name: 'potSize')
  final int? potSize;
  @JsonKey(name: 'winnerId')
  final int? winnerId;
  @JsonKey(name: 'table')
  final PokerTable? table;
  @JsonKey(name: 'winner')
  final User? winner;
  @JsonKey(name: 'gamePlayers', defaultValue: <GamePlayer>[])
  final List<GamePlayer>? gamePlayers;
  @JsonKey(name: 'moves', defaultValue: <Move>[])
  final List<Move>? moves;
  @JsonKey(name: 'communityCards', defaultValue: <CommunityCard>[])
  final List<CommunityCard>? communityCards;
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
            (identical(other.currentState, currentState) ||
                const DeepCollectionEquality()
                    .equals(other.currentState, currentState)) &&
            (identical(other.potSize, potSize) ||
                const DeepCollectionEquality()
                    .equals(other.potSize, potSize)) &&
            (identical(other.winnerId, winnerId) ||
                const DeepCollectionEquality()
                    .equals(other.winnerId, winnerId)) &&
            (identical(other.table, table) ||
                const DeepCollectionEquality().equals(other.table, table)) &&
            (identical(other.winner, winner) ||
                const DeepCollectionEquality().equals(other.winner, winner)) &&
            (identical(other.gamePlayers, gamePlayers) ||
                const DeepCollectionEquality()
                    .equals(other.gamePlayers, gamePlayers)) &&
            (identical(other.moves, moves) ||
                const DeepCollectionEquality().equals(other.moves, moves)) &&
            (identical(other.communityCards, communityCards) ||
                const DeepCollectionEquality()
                    .equals(other.communityCards, communityCards)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(gameId) ^
      const DeepCollectionEquality().hash(tableId) ^
      const DeepCollectionEquality().hash(startTime) ^
      const DeepCollectionEquality().hash(endTime) ^
      const DeepCollectionEquality().hash(currentState) ^
      const DeepCollectionEquality().hash(potSize) ^
      const DeepCollectionEquality().hash(winnerId) ^
      const DeepCollectionEquality().hash(table) ^
      const DeepCollectionEquality().hash(winner) ^
      const DeepCollectionEquality().hash(gamePlayers) ^
      const DeepCollectionEquality().hash(moves) ^
      const DeepCollectionEquality().hash(communityCards) ^
      runtimeType.hashCode;
}

extension $GameExtension on Game {
  Game copyWith(
      {int? gameId,
      int? tableId,
      DateTime? startTime,
      DateTime? endTime,
      String? currentState,
      int? potSize,
      int? winnerId,
      PokerTable? table,
      User? winner,
      List<GamePlayer>? gamePlayers,
      List<Move>? moves,
      List<CommunityCard>? communityCards}) {
    return Game(
        gameId: gameId ?? this.gameId,
        tableId: tableId ?? this.tableId,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        currentState: currentState ?? this.currentState,
        potSize: potSize ?? this.potSize,
        winnerId: winnerId ?? this.winnerId,
        table: table ?? this.table,
        winner: winner ?? this.winner,
        gamePlayers: gamePlayers ?? this.gamePlayers,
        moves: moves ?? this.moves,
        communityCards: communityCards ?? this.communityCards);
  }

  Game copyWithWrapped(
      {Wrapped<int?>? gameId,
      Wrapped<int?>? tableId,
      Wrapped<DateTime?>? startTime,
      Wrapped<DateTime?>? endTime,
      Wrapped<String?>? currentState,
      Wrapped<int?>? potSize,
      Wrapped<int?>? winnerId,
      Wrapped<PokerTable?>? table,
      Wrapped<User?>? winner,
      Wrapped<List<GamePlayer>?>? gamePlayers,
      Wrapped<List<Move>?>? moves,
      Wrapped<List<CommunityCard>?>? communityCards}) {
    return Game(
        gameId: (gameId != null ? gameId.value : this.gameId),
        tableId: (tableId != null ? tableId.value : this.tableId),
        startTime: (startTime != null ? startTime.value : this.startTime),
        endTime: (endTime != null ? endTime.value : this.endTime),
        currentState:
            (currentState != null ? currentState.value : this.currentState),
        potSize: (potSize != null ? potSize.value : this.potSize),
        winnerId: (winnerId != null ? winnerId.value : this.winnerId),
        table: (table != null ? table.value : this.table),
        winner: (winner != null ? winner.value : this.winner),
        gamePlayers:
            (gamePlayers != null ? gamePlayers.value : this.gamePlayers),
        moves: (moves != null ? moves.value : this.moves),
        communityCards: (communityCards != null
            ? communityCards.value
            : this.communityCards));
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
    this.user,
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
  @JsonKey(name: 'userId')
  final int? userId;
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
  @JsonKey(name: 'game')
  final Game? game;
  @JsonKey(name: 'user')
  final User? user;
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
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
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
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(seatPosition) ^
      const DeepCollectionEquality().hash(initialChips) ^
      const DeepCollectionEquality().hash(currentChips) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(isDealer) ^
      const DeepCollectionEquality().hash(isSmallBlind) ^
      const DeepCollectionEquality().hash(isBigBlind) ^
      const DeepCollectionEquality().hash(game) ^
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(playerCards) ^
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
      User? user,
      List<PlayerCard>? playerCards}) {
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
        user: user ?? this.user,
        playerCards: playerCards ?? this.playerCards);
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
      Wrapped<User?>? user,
      Wrapped<List<PlayerCard>?>? playerCards}) {
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
        user: (user != null ? user.value : this.user),
        playerCards:
            (playerCards != null ? playerCards.value : this.playerCards));
  }
}

@JsonSerializable(explicitToJson: true)
class GameState {
  const GameState({
    this.gameId,
    this.tableId,
    this.tableName,
    this.currentState,
    this.potSize,
    this.communityCards,
    this.playerCards,
    this.players,
    this.lastMoves,
    this.winnerId,
  });

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  static const toJsonFactory = _$GameStateToJson;
  Map<String, dynamic> toJson() => _$GameStateToJson(this);

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
  @JsonKey(name: 'communityCards', defaultValue: <Card>[])
  final List<Card>? communityCards;
  @JsonKey(name: 'playerCards', defaultValue: <Card>[])
  final List<Card>? playerCards;
  @JsonKey(name: 'players', defaultValue: <PlayerState>[])
  final List<PlayerState>? players;
  @JsonKey(name: 'lastMoves', defaultValue: <Move>[])
  final List<Move>? lastMoves;
  @JsonKey(name: 'winnerId')
  final int? winnerId;
  static const fromJsonFactory = _$GameStateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GameState &&
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
            (identical(other.communityCards, communityCards) ||
                const DeepCollectionEquality()
                    .equals(other.communityCards, communityCards)) &&
            (identical(other.playerCards, playerCards) ||
                const DeepCollectionEquality()
                    .equals(other.playerCards, playerCards)) &&
            (identical(other.players, players) ||
                const DeepCollectionEquality()
                    .equals(other.players, players)) &&
            (identical(other.lastMoves, lastMoves) ||
                const DeepCollectionEquality()
                    .equals(other.lastMoves, lastMoves)) &&
            (identical(other.winnerId, winnerId) ||
                const DeepCollectionEquality()
                    .equals(other.winnerId, winnerId)));
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
      const DeepCollectionEquality().hash(communityCards) ^
      const DeepCollectionEquality().hash(playerCards) ^
      const DeepCollectionEquality().hash(players) ^
      const DeepCollectionEquality().hash(lastMoves) ^
      const DeepCollectionEquality().hash(winnerId) ^
      runtimeType.hashCode;
}

extension $GameStateExtension on GameState {
  GameState copyWith(
      {int? gameId,
      int? tableId,
      String? tableName,
      String? currentState,
      int? potSize,
      List<Card>? communityCards,
      List<Card>? playerCards,
      List<PlayerState>? players,
      List<Move>? lastMoves,
      int? winnerId}) {
    return GameState(
        gameId: gameId ?? this.gameId,
        tableId: tableId ?? this.tableId,
        tableName: tableName ?? this.tableName,
        currentState: currentState ?? this.currentState,
        potSize: potSize ?? this.potSize,
        communityCards: communityCards ?? this.communityCards,
        playerCards: playerCards ?? this.playerCards,
        players: players ?? this.players,
        lastMoves: lastMoves ?? this.lastMoves,
        winnerId: winnerId ?? this.winnerId);
  }

  GameState copyWithWrapped(
      {Wrapped<int?>? gameId,
      Wrapped<int?>? tableId,
      Wrapped<String?>? tableName,
      Wrapped<String?>? currentState,
      Wrapped<int?>? potSize,
      Wrapped<List<Card>?>? communityCards,
      Wrapped<List<Card>?>? playerCards,
      Wrapped<List<PlayerState>?>? players,
      Wrapped<List<Move>?>? lastMoves,
      Wrapped<int?>? winnerId}) {
    return GameState(
        gameId: (gameId != null ? gameId.value : this.gameId),
        tableId: (tableId != null ? tableId.value : this.tableId),
        tableName: (tableName != null ? tableName.value : this.tableName),
        currentState:
            (currentState != null ? currentState.value : this.currentState),
        potSize: (potSize != null ? potSize.value : this.potSize),
        communityCards: (communityCards != null
            ? communityCards.value
            : this.communityCards),
        playerCards:
            (playerCards != null ? playerCards.value : this.playerCards),
        players: (players != null ? players.value : this.players),
        lastMoves: (lastMoves != null ? lastMoves.value : this.lastMoves),
        winnerId: (winnerId != null ? winnerId.value : this.winnerId));
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
class LeaderboardEntry {
  const LeaderboardEntry({
    this.userId,
    this.username,
    this.chipsBalance,
    this.avatarImage,
    this.gamesWon,
    this.gamesPlayed,
    this.winRatio,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryFromJson(json);

  static const toJsonFactory = _$LeaderboardEntryToJson;
  Map<String, dynamic> toJson() => _$LeaderboardEntryToJson(this);

  @JsonKey(name: 'userId')
  final int? userId;
  @JsonKey(name: 'username')
  final String? username;
  @JsonKey(name: 'chipsBalance')
  final int? chipsBalance;
  @JsonKey(name: 'avatarImage')
  final String? avatarImage;
  @JsonKey(name: 'gamesWon')
  final int? gamesWon;
  @JsonKey(name: 'gamesPlayed')
  final int? gamesPlayed;
  @JsonKey(name: 'winRatio')
  final double? winRatio;
  static const fromJsonFactory = _$LeaderboardEntryFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LeaderboardEntry &&
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

extension $LeaderboardEntryExtension on LeaderboardEntry {
  LeaderboardEntry copyWith(
      {int? userId,
      String? username,
      int? chipsBalance,
      String? avatarImage,
      int? gamesWon,
      int? gamesPlayed,
      double? winRatio}) {
    return LeaderboardEntry(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        chipsBalance: chipsBalance ?? this.chipsBalance,
        avatarImage: avatarImage ?? this.avatarImage,
        gamesWon: gamesWon ?? this.gamesWon,
        gamesPlayed: gamesPlayed ?? this.gamesPlayed,
        winRatio: winRatio ?? this.winRatio);
  }

  LeaderboardEntry copyWithWrapped(
      {Wrapped<int?>? userId,
      Wrapped<String?>? username,
      Wrapped<int?>? chipsBalance,
      Wrapped<String?>? avatarImage,
      Wrapped<int?>? gamesWon,
      Wrapped<int?>? gamesPlayed,
      Wrapped<double?>? winRatio}) {
    return LeaderboardEntry(
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
    this.playerId,
    this.actionType,
    this.amount,
    this.moveTime,
    this.round,
    this.game,
    this.player,
  });

  factory Move.fromJson(Map<String, dynamic> json) => _$MoveFromJson(json);

  static const toJsonFactory = _$MoveToJson;
  Map<String, dynamic> toJson() => _$MoveToJson(this);

  @JsonKey(name: 'moveId')
  final int? moveId;
  @JsonKey(name: 'gameId')
  final int? gameId;
  @JsonKey(name: 'playerId')
  final int? playerId;
  @JsonKey(name: 'actionType')
  final String? actionType;
  @JsonKey(name: 'amount')
  final int? amount;
  @JsonKey(name: 'moveTime')
  final DateTime? moveTime;
  @JsonKey(name: 'round')
  final String? round;
  @JsonKey(name: 'game')
  final Game? game;
  @JsonKey(name: 'player')
  final User? player;
  static const fromJsonFactory = _$MoveFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Move &&
            (identical(other.moveId, moveId) ||
                const DeepCollectionEquality().equals(other.moveId, moveId)) &&
            (identical(other.gameId, gameId) ||
                const DeepCollectionEquality().equals(other.gameId, gameId)) &&
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
            (identical(other.game, game) ||
                const DeepCollectionEquality().equals(other.game, game)) &&
            (identical(other.player, player) ||
                const DeepCollectionEquality().equals(other.player, player)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(moveId) ^
      const DeepCollectionEquality().hash(gameId) ^
      const DeepCollectionEquality().hash(playerId) ^
      const DeepCollectionEquality().hash(actionType) ^
      const DeepCollectionEquality().hash(amount) ^
      const DeepCollectionEquality().hash(moveTime) ^
      const DeepCollectionEquality().hash(round) ^
      const DeepCollectionEquality().hash(game) ^
      const DeepCollectionEquality().hash(player) ^
      runtimeType.hashCode;
}

extension $MoveExtension on Move {
  Move copyWith(
      {int? moveId,
      int? gameId,
      int? playerId,
      String? actionType,
      int? amount,
      DateTime? moveTime,
      String? round,
      Game? game,
      User? player}) {
    return Move(
        moveId: moveId ?? this.moveId,
        gameId: gameId ?? this.gameId,
        playerId: playerId ?? this.playerId,
        actionType: actionType ?? this.actionType,
        amount: amount ?? this.amount,
        moveTime: moveTime ?? this.moveTime,
        round: round ?? this.round,
        game: game ?? this.game,
        player: player ?? this.player);
  }

  Move copyWithWrapped(
      {Wrapped<int?>? moveId,
      Wrapped<int?>? gameId,
      Wrapped<int?>? playerId,
      Wrapped<String?>? actionType,
      Wrapped<int?>? amount,
      Wrapped<DateTime?>? moveTime,
      Wrapped<String?>? round,
      Wrapped<Game?>? game,
      Wrapped<User?>? player}) {
    return Move(
        moveId: (moveId != null ? moveId.value : this.moveId),
        gameId: (gameId != null ? gameId.value : this.gameId),
        playerId: (playerId != null ? playerId.value : this.playerId),
        actionType: (actionType != null ? actionType.value : this.actionType),
        amount: (amount != null ? amount.value : this.amount),
        moveTime: (moveTime != null ? moveTime.value : this.moveTime),
        round: (round != null ? round.value : this.round),
        game: (game != null ? game.value : this.game),
        player: (player != null ? player.value : this.player));
  }
}

@JsonSerializable(explicitToJson: true)
class PlayerCard {
  const PlayerCard({
    this.playerCardId,
    this.gamePlayerId,
    this.cardId,
    this.position,
    this.gamePlayer,
    this.card,
  });

  factory PlayerCard.fromJson(Map<String, dynamic> json) =>
      _$PlayerCardFromJson(json);

  static const toJsonFactory = _$PlayerCardToJson;
  Map<String, dynamic> toJson() => _$PlayerCardToJson(this);

  @JsonKey(name: 'playerCardId')
  final int? playerCardId;
  @JsonKey(name: 'gamePlayerId')
  final int? gamePlayerId;
  @JsonKey(name: 'cardId')
  final int? cardId;
  @JsonKey(name: 'position')
  final int? position;
  @JsonKey(name: 'gamePlayer')
  final GamePlayer? gamePlayer;
  @JsonKey(name: 'card')
  final Card? card;
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
            (identical(other.cardId, cardId) ||
                const DeepCollectionEquality().equals(other.cardId, cardId)) &&
            (identical(other.position, position) ||
                const DeepCollectionEquality()
                    .equals(other.position, position)) &&
            (identical(other.gamePlayer, gamePlayer) ||
                const DeepCollectionEquality()
                    .equals(other.gamePlayer, gamePlayer)) &&
            (identical(other.card, card) ||
                const DeepCollectionEquality().equals(other.card, card)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(playerCardId) ^
      const DeepCollectionEquality().hash(gamePlayerId) ^
      const DeepCollectionEquality().hash(cardId) ^
      const DeepCollectionEquality().hash(position) ^
      const DeepCollectionEquality().hash(gamePlayer) ^
      const DeepCollectionEquality().hash(card) ^
      runtimeType.hashCode;
}

extension $PlayerCardExtension on PlayerCard {
  PlayerCard copyWith(
      {int? playerCardId,
      int? gamePlayerId,
      int? cardId,
      int? position,
      GamePlayer? gamePlayer,
      Card? card}) {
    return PlayerCard(
        playerCardId: playerCardId ?? this.playerCardId,
        gamePlayerId: gamePlayerId ?? this.gamePlayerId,
        cardId: cardId ?? this.cardId,
        position: position ?? this.position,
        gamePlayer: gamePlayer ?? this.gamePlayer,
        card: card ?? this.card);
  }

  PlayerCard copyWithWrapped(
      {Wrapped<int?>? playerCardId,
      Wrapped<int?>? gamePlayerId,
      Wrapped<int?>? cardId,
      Wrapped<int?>? position,
      Wrapped<GamePlayer?>? gamePlayer,
      Wrapped<Card?>? card}) {
    return PlayerCard(
        playerCardId:
            (playerCardId != null ? playerCardId.value : this.playerCardId),
        gamePlayerId:
            (gamePlayerId != null ? gamePlayerId.value : this.gamePlayerId),
        cardId: (cardId != null ? cardId.value : this.cardId),
        position: (position != null ? position.value : this.position),
        gamePlayer: (gamePlayer != null ? gamePlayer.value : this.gamePlayer),
        card: (card != null ? card.value : this.card));
  }
}

@JsonSerializable(explicitToJson: true)
class PlayerState {
  const PlayerState({
    this.userId,
    this.username,
    this.seatPosition,
    this.chipCount,
    this.isActive,
    this.isDealer,
    this.isSmallBlind,
    this.isBigBlind,
    this.cards,
  });

  factory PlayerState.fromJson(Map<String, dynamic> json) =>
      _$PlayerStateFromJson(json);

  static const toJsonFactory = _$PlayerStateToJson;
  Map<String, dynamic> toJson() => _$PlayerStateToJson(this);

  @JsonKey(name: 'userId')
  final int? userId;
  @JsonKey(name: 'username')
  final String? username;
  @JsonKey(name: 'seatPosition')
  final int? seatPosition;
  @JsonKey(name: 'chipCount')
  final int? chipCount;
  @JsonKey(name: 'isActive')
  final bool? isActive;
  @JsonKey(name: 'isDealer')
  final bool? isDealer;
  @JsonKey(name: 'isSmallBlind')
  final bool? isSmallBlind;
  @JsonKey(name: 'isBigBlind')
  final bool? isBigBlind;
  @JsonKey(name: 'cards', defaultValue: <Card>[])
  final List<Card>? cards;
  static const fromJsonFactory = _$PlayerStateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PlayerState &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)) &&
            (identical(other.seatPosition, seatPosition) ||
                const DeepCollectionEquality()
                    .equals(other.seatPosition, seatPosition)) &&
            (identical(other.chipCount, chipCount) ||
                const DeepCollectionEquality()
                    .equals(other.chipCount, chipCount)) &&
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
            (identical(other.cards, cards) ||
                const DeepCollectionEquality().equals(other.cards, cards)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(seatPosition) ^
      const DeepCollectionEquality().hash(chipCount) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(isDealer) ^
      const DeepCollectionEquality().hash(isSmallBlind) ^
      const DeepCollectionEquality().hash(isBigBlind) ^
      const DeepCollectionEquality().hash(cards) ^
      runtimeType.hashCode;
}

extension $PlayerStateExtension on PlayerState {
  PlayerState copyWith(
      {int? userId,
      String? username,
      int? seatPosition,
      int? chipCount,
      bool? isActive,
      bool? isDealer,
      bool? isSmallBlind,
      bool? isBigBlind,
      List<Card>? cards}) {
    return PlayerState(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        seatPosition: seatPosition ?? this.seatPosition,
        chipCount: chipCount ?? this.chipCount,
        isActive: isActive ?? this.isActive,
        isDealer: isDealer ?? this.isDealer,
        isSmallBlind: isSmallBlind ?? this.isSmallBlind,
        isBigBlind: isBigBlind ?? this.isBigBlind,
        cards: cards ?? this.cards);
  }

  PlayerState copyWithWrapped(
      {Wrapped<int?>? userId,
      Wrapped<String?>? username,
      Wrapped<int?>? seatPosition,
      Wrapped<int?>? chipCount,
      Wrapped<bool?>? isActive,
      Wrapped<bool?>? isDealer,
      Wrapped<bool?>? isSmallBlind,
      Wrapped<bool?>? isBigBlind,
      Wrapped<List<Card>?>? cards}) {
    return PlayerState(
        userId: (userId != null ? userId.value : this.userId),
        username: (username != null ? username.value : this.username),
        seatPosition:
            (seatPosition != null ? seatPosition.value : this.seatPosition),
        chipCount: (chipCount != null ? chipCount.value : this.chipCount),
        isActive: (isActive != null ? isActive.value : this.isActive),
        isDealer: (isDealer != null ? isDealer.value : this.isDealer),
        isSmallBlind:
            (isSmallBlind != null ? isSmallBlind.value : this.isSmallBlind),
        isBigBlind: (isBigBlind != null ? isBigBlind.value : this.isBigBlind),
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

  @JsonKey(name: 'tableId')
  final int? tableId;
  @JsonKey(name: 'name')
  final String? name;
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
  final String? difficultyLevel;
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
    this.user,
    this.item,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) =>
      _$PurchaseFromJson(json);

  static const toJsonFactory = _$PurchaseToJson;
  Map<String, dynamic> toJson() => _$PurchaseToJson(this);

  @JsonKey(name: 'purchaseId')
  final int? purchaseId;
  @JsonKey(name: 'userId')
  final int? userId;
  @JsonKey(name: 'itemId')
  final int? itemId;
  @JsonKey(name: 'purchaseDate')
  final DateTime? purchaseDate;
  @JsonKey(name: 'price')
  final double? price;
  @JsonKey(name: 'paymentMethod')
  final String? paymentMethod;
  @JsonKey(name: 'transactionId')
  final String? transactionId;
  @JsonKey(name: 'user')
  final User? user;
  @JsonKey(name: 'item')
  final ShopItem? item;
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
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
            (identical(other.item, item) ||
                const DeepCollectionEquality().equals(other.item, item)));
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
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(item) ^
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
      User? user,
      ShopItem? item}) {
    return Purchase(
        purchaseId: purchaseId ?? this.purchaseId,
        userId: userId ?? this.userId,
        itemId: itemId ?? this.itemId,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        price: price ?? this.price,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        transactionId: transactionId ?? this.transactionId,
        user: user ?? this.user,
        item: item ?? this.item);
  }

  Purchase copyWithWrapped(
      {Wrapped<int?>? purchaseId,
      Wrapped<int?>? userId,
      Wrapped<int?>? itemId,
      Wrapped<DateTime?>? purchaseDate,
      Wrapped<double?>? price,
      Wrapped<String?>? paymentMethod,
      Wrapped<String?>? transactionId,
      Wrapped<User?>? user,
      Wrapped<ShopItem?>? item}) {
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
        user: (user != null ? user.value : this.user),
        item: (item != null ? item.value : this.item));
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
class ShopItem {
  const ShopItem({
    this.itemId,
    this.name,
    this.description,
    this.price,
    this.itemType,
    this.isActive,
    this.currency,
    this.purchases,
  });

  factory ShopItem.fromJson(Map<String, dynamic> json) =>
      _$ShopItemFromJson(json);

  static const toJsonFactory = _$ShopItemToJson;
  Map<String, dynamic> toJson() => _$ShopItemToJson(this);

  @JsonKey(name: 'itemId')
  final int? itemId;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'price')
  final double? price;
  @JsonKey(name: 'itemType')
  final String? itemType;
  @JsonKey(name: 'isActive')
  final bool? isActive;
  @JsonKey(name: 'currency')
  final String? currency;
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
            (identical(other.currency, currency) ||
                const DeepCollectionEquality()
                    .equals(other.currency, currency)) &&
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
      const DeepCollectionEquality().hash(currency) ^
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
      String? currency,
      List<Purchase>? purchases}) {
    return ShopItem(
        itemId: itemId ?? this.itemId,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        itemType: itemType ?? this.itemType,
        isActive: isActive ?? this.isActive,
        currency: currency ?? this.currency,
        purchases: purchases ?? this.purchases);
  }

  ShopItem copyWithWrapped(
      {Wrapped<int?>? itemId,
      Wrapped<String?>? name,
      Wrapped<String?>? description,
      Wrapped<double?>? price,
      Wrapped<String?>? itemType,
      Wrapped<bool?>? isActive,
      Wrapped<String?>? currency,
      Wrapped<List<Purchase>?>? purchases}) {
    return ShopItem(
        itemId: (itemId != null ? itemId.value : this.itemId),
        name: (name != null ? name.value : this.name),
        description:
            (description != null ? description.value : this.description),
        price: (price != null ? price.value : this.price),
        itemType: (itemType != null ? itemType.value : this.itemType),
        isActive: (isActive != null ? isActive.value : this.isActive),
        currency: (currency != null ? currency.value : this.currency),
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
    this.username,
    this.email,
    this.passwordHash,
    this.chipsBalance,
    this.avatarImage,
    this.registrationDate,
    this.lastLoginDate,
    this.isActive,
    this.avatarType,
    this.gamePlayers,
    this.wonGames,
    this.moves,
    this.purchases,
    this.chipTransactions,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  static const toJsonFactory = _$UserToJson;
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @JsonKey(name: 'userId')
  final int? userId;
  @JsonKey(name: 'username')
  final String? username;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'passwordHash')
  final String? passwordHash;
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
  @JsonKey(name: 'avatarType')
  final String? avatarType;
  @JsonKey(name: 'gamePlayers', defaultValue: <GamePlayer>[])
  final List<GamePlayer>? gamePlayers;
  @JsonKey(name: 'wonGames', defaultValue: <Game>[])
  final List<Game>? wonGames;
  @JsonKey(name: 'moves', defaultValue: <Move>[])
  final List<Move>? moves;
  @JsonKey(name: 'purchases', defaultValue: <Purchase>[])
  final List<Purchase>? purchases;
  @JsonKey(name: 'chipTransactions', defaultValue: <ChipTransaction>[])
  final List<ChipTransaction>? chipTransactions;
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
            (identical(other.avatarType, avatarType) ||
                const DeepCollectionEquality()
                    .equals(other.avatarType, avatarType)) &&
            (identical(other.gamePlayers, gamePlayers) ||
                const DeepCollectionEquality()
                    .equals(other.gamePlayers, gamePlayers)) &&
            (identical(other.wonGames, wonGames) ||
                const DeepCollectionEquality()
                    .equals(other.wonGames, wonGames)) &&
            (identical(other.moves, moves) ||
                const DeepCollectionEquality().equals(other.moves, moves)) &&
            (identical(other.purchases, purchases) ||
                const DeepCollectionEquality()
                    .equals(other.purchases, purchases)) &&
            (identical(other.chipTransactions, chipTransactions) ||
                const DeepCollectionEquality()
                    .equals(other.chipTransactions, chipTransactions)));
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
      const DeepCollectionEquality().hash(avatarType) ^
      const DeepCollectionEquality().hash(gamePlayers) ^
      const DeepCollectionEquality().hash(wonGames) ^
      const DeepCollectionEquality().hash(moves) ^
      const DeepCollectionEquality().hash(purchases) ^
      const DeepCollectionEquality().hash(chipTransactions) ^
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
      String? avatarType,
      List<GamePlayer>? gamePlayers,
      List<Game>? wonGames,
      List<Move>? moves,
      List<Purchase>? purchases,
      List<ChipTransaction>? chipTransactions}) {
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
        avatarType: avatarType ?? this.avatarType,
        gamePlayers: gamePlayers ?? this.gamePlayers,
        wonGames: wonGames ?? this.wonGames,
        moves: moves ?? this.moves,
        purchases: purchases ?? this.purchases,
        chipTransactions: chipTransactions ?? this.chipTransactions);
  }

  User copyWithWrapped(
      {Wrapped<int?>? userId,
      Wrapped<String?>? username,
      Wrapped<String?>? email,
      Wrapped<String?>? passwordHash,
      Wrapped<int?>? chipsBalance,
      Wrapped<String?>? avatarImage,
      Wrapped<DateTime?>? registrationDate,
      Wrapped<DateTime?>? lastLoginDate,
      Wrapped<bool?>? isActive,
      Wrapped<String?>? avatarType,
      Wrapped<List<GamePlayer>?>? gamePlayers,
      Wrapped<List<Game>?>? wonGames,
      Wrapped<List<Move>?>? moves,
      Wrapped<List<Purchase>?>? purchases,
      Wrapped<List<ChipTransaction>?>? chipTransactions}) {
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
        avatarType: (avatarType != null ? avatarType.value : this.avatarType),
        gamePlayers:
            (gamePlayers != null ? gamePlayers.value : this.gamePlayers),
        wonGames: (wonGames != null ? wonGames.value : this.wonGames),
        moves: (moves != null ? moves.value : this.moves),
        purchases: (purchases != null ? purchases.value : this.purchases),
        chipTransactions: (chipTransactions != null
            ? chipTransactions.value
            : this.chipTransactions));
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
