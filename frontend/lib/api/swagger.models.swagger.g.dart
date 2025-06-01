// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swagger.models.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgentDto _$AgentDtoFromJson(Map<String, dynamic> json) => AgentDto(
      name: json['name'] as String?,
      difficulty: json['difficulty'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      username: json['username'] as String?,
    );

Map<String, dynamic> _$AgentDtoToJson(AgentDto instance) => <String, dynamic>{
      'name': instance.name,
      'difficulty': instance.difficulty,
      'userId': instance.userId,
      'username': instance.username,
    };

Card _$CardFromJson(Map<String, dynamic> json) => Card(
      cardId: (json['cardId'] as num?)?.toInt(),
      suit: json['suit'] as String?,
      $value: json['value'] as String?,
      communityCards: (json['communityCards'] as List<dynamic>?)
              ?.map((e) => CommunityCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      playerCards: (json['playerCards'] as List<dynamic>?)
              ?.map((e) => PlayerCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$CardToJson(Card instance) => <String, dynamic>{
      'cardId': instance.cardId,
      'suit': instance.suit,
      'value': instance.$value,
      'communityCards':
          instance.communityCards?.map((e) => e.toJson()).toList(),
      'playerCards': instance.playerCards?.map((e) => e.toJson()).toList(),
    };

CardDto _$CardDtoFromJson(Map<String, dynamic> json) => CardDto(
      suit: json['suit'] as String?,
      $value: json['value'] as String?,
    );

Map<String, dynamic> _$CardDtoToJson(CardDto instance) => <String, dynamic>{
      'suit': instance.suit,
      'value': instance.$value,
    };

ChipTransaction _$ChipTransactionFromJson(Map<String, dynamic> json) =>
    ChipTransaction(
      transactionId: (json['transactionId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toInt(),
      transactionType: json['transactionType'] as String?,
      referenceId: (json['referenceId'] as num?)?.toInt(),
      transactionDate: json['transactionDate'] == null
          ? null
          : DateTime.parse(json['transactionDate'] as String),
      description: json['description'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChipTransactionToJson(ChipTransaction instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'userId': instance.userId,
      'amount': instance.amount,
      'transactionType': instance.transactionType,
      'referenceId': instance.referenceId,
      'transactionDate': instance.transactionDate?.toIso8601String(),
      'description': instance.description,
      'user': instance.user?.toJson(),
    };

ChooseUsernameDto _$ChooseUsernameDtoFromJson(Map<String, dynamic> json) =>
    ChooseUsernameDto(
      username: json['username'] as String?,
    );

Map<String, dynamic> _$ChooseUsernameDtoToJson(ChooseUsernameDto instance) =>
    <String, dynamic>{
      'username': instance.username,
    };

CommunityCard _$CommunityCardFromJson(Map<String, dynamic> json) =>
    CommunityCard(
      communityCardId: (json['communityCardId'] as num?)?.toInt(),
      gameRoundId: (json['gameRoundId'] as num?)?.toInt(),
      cardId: (json['cardId'] as num?)?.toInt(),
      position: (json['position'] as num?)?.toInt(),
      card: json['card'] == null
          ? null
          : Card.fromJson(json['card'] as Map<String, dynamic>),
      gameRound: json['gameRound'] == null
          ? null
          : GameRound.fromJson(json['gameRound'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommunityCardToJson(CommunityCard instance) =>
    <String, dynamic>{
      'communityCardId': instance.communityCardId,
      'gameRoundId': instance.gameRoundId,
      'cardId': instance.cardId,
      'position': instance.position,
      'card': instance.card?.toJson(),
      'gameRound': instance.gameRound?.toJson(),
    };

CreateGameDto _$CreateGameDtoFromJson(Map<String, dynamic> json) =>
    CreateGameDto(
      tableId: (json['tableId'] as num).toInt(),
    );

Map<String, dynamic> _$CreateGameDtoToJson(CreateGameDto instance) =>
    <String, dynamic>{
      'tableId': instance.tableId,
    };

Game _$GameFromJson(Map<String, dynamic> json) => Game(
      gameId: (json['gameId'] as num?)?.toInt(),
      tableId: (json['tableId'] as num?)?.toInt(),
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      currentTurnPlayerId: (json['currentTurnPlayerId'] as num?)?.toInt(),
      potSize: (json['potSize'] as num?)?.toInt(),
      currentTurnPlayer: json['currentTurnPlayer'] == null
          ? null
          : GamePlayer.fromJson(
              json['currentTurnPlayer'] as Map<String, dynamic>),
      gamePlayers: (json['gamePlayers'] as List<dynamic>?)
              ?.map((e) => GamePlayer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      gameRounds: (json['gameRounds'] as List<dynamic>?)
              ?.map((e) => GameRound.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      table: json['table'] == null
          ? null
          : PokerTable.fromJson(json['table'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GameToJson(Game instance) => <String, dynamic>{
      'gameId': instance.gameId,
      'tableId': instance.tableId,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'currentTurnPlayerId': instance.currentTurnPlayerId,
      'potSize': instance.potSize,
      'currentTurnPlayer': instance.currentTurnPlayer?.toJson(),
      'gamePlayers': instance.gamePlayers?.map((e) => e.toJson()).toList(),
      'gameRounds': instance.gameRounds?.map((e) => e.toJson()).toList(),
      'table': instance.table?.toJson(),
    };

GamePlayer _$GamePlayerFromJson(Map<String, dynamic> json) => GamePlayer(
      gamePlayerId: (json['gamePlayerId'] as num?)?.toInt(),
      gameId: (json['gameId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      seatPosition: (json['seatPosition'] as num?)?.toInt(),
      initialChips: (json['initialChips'] as num?)?.toInt(),
      currentChips: (json['currentChips'] as num?)?.toInt(),
      isActive: json['isActive'] as bool?,
      isDealer: json['isDealer'] as bool?,
      isSmallBlind: json['isSmallBlind'] as bool?,
      isBigBlind: json['isBigBlind'] as bool?,
      game: json['game'] == null
          ? null
          : Game.fromJson(json['game'] as Map<String, dynamic>),
      games: (json['games'] as List<dynamic>?)
              ?.map((e) => Game.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      playerCards: (json['playerCards'] as List<dynamic>?)
              ?.map((e) => PlayerCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GamePlayerToJson(GamePlayer instance) =>
    <String, dynamic>{
      'gamePlayerId': instance.gamePlayerId,
      'gameId': instance.gameId,
      'userId': instance.userId,
      'seatPosition': instance.seatPosition,
      'initialChips': instance.initialChips,
      'currentChips': instance.currentChips,
      'isActive': instance.isActive,
      'isDealer': instance.isDealer,
      'isSmallBlind': instance.isSmallBlind,
      'isBigBlind': instance.isBigBlind,
      'game': instance.game?.toJson(),
      'games': instance.games?.map((e) => e.toJson()).toList(),
      'playerCards': instance.playerCards?.map((e) => e.toJson()).toList(),
      'user': instance.user?.toJson(),
    };

GameRound _$GameRoundFromJson(Map<String, dynamic> json) => GameRound(
      gameRoundId: (json['gameRoundId'] as num?)?.toInt(),
      gameId: (json['gameId'] as num?)?.toInt(),
      roundNumber: (json['roundNumber'] as num?)?.toInt(),
      currentState: json['currentState'] as String?,
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      potSize: (json['potSize'] as num?)?.toInt(),
      communityCards: (json['communityCards'] as List<dynamic>?)
              ?.map((e) => CommunityCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      game: json['game'] == null
          ? null
          : Game.fromJson(json['game'] as Map<String, dynamic>),
      gameRoundWinners: (json['gameRoundWinners'] as List<dynamic>?)
              ?.map((e) => GameRoundWinner.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      moves: (json['moves'] as List<dynamic>?)
              ?.map((e) => Move.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      playerCards: (json['playerCards'] as List<dynamic>?)
              ?.map((e) => PlayerCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$GameRoundToJson(GameRound instance) => <String, dynamic>{
      'gameRoundId': instance.gameRoundId,
      'gameId': instance.gameId,
      'roundNumber': instance.roundNumber,
      'currentState': instance.currentState,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'potSize': instance.potSize,
      'communityCards':
          instance.communityCards?.map((e) => e.toJson()).toList(),
      'game': instance.game?.toJson(),
      'gameRoundWinners':
          instance.gameRoundWinners?.map((e) => e.toJson()).toList(),
      'moves': instance.moves?.map((e) => e.toJson()).toList(),
      'playerCards': instance.playerCards?.map((e) => e.toJson()).toList(),
    };

GameRoundWinner _$GameRoundWinnerFromJson(Map<String, dynamic> json) =>
    GameRoundWinner(
      gameRoundWinnerId: (json['gameRoundWinnerId'] as num?)?.toInt(),
      gameRoundId: (json['gameRoundId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      amountWon: (json['amountWon'] as num?)?.toInt(),
      gameRound: json['gameRound'] == null
          ? null
          : GameRound.fromJson(json['gameRound'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GameRoundWinnerToJson(GameRoundWinner instance) =>
    <String, dynamic>{
      'gameRoundWinnerId': instance.gameRoundWinnerId,
      'gameRoundId': instance.gameRoundId,
      'userId': instance.userId,
      'amountWon': instance.amountWon,
      'gameRound': instance.gameRound?.toJson(),
      'user': instance.user?.toJson(),
    };

GameStateDto _$GameStateDtoFromJson(Map<String, dynamic> json) => GameStateDto(
      gameId: (json['gameId'] as num?)?.toInt(),
      tableId: (json['tableId'] as num?)?.toInt(),
      tableName: json['tableName'] as String?,
      currentState: json['currentState'] as String?,
      potSize: (json['potSize'] as num?)?.toInt(),
      currentTurnUserId: (json['currentTurnUserId'] as num?)?.toInt(),
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
      callAmount: (json['callAmount'] as num?)?.toInt(),
      minRaiseAmount: (json['minRaiseAmount'] as num?)?.toInt(),
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
      seatPosition: (json['seatPosition'] as num).toInt(),
      buyInAmount: (json['buyInAmount'] as num).toInt(),
    );

Map<String, dynamic> _$JoinGameDtoToJson(JoinGameDto instance) =>
    <String, dynamic>{
      'seatPosition': instance.seatPosition,
      'buyInAmount': instance.buyInAmount,
    };

LeaderboardView _$LeaderboardViewFromJson(Map<String, dynamic> json) =>
    LeaderboardView(
      userId: (json['userId'] as num?)?.toInt(),
      username: json['username'] as String?,
      chipsBalance: (json['chipsBalance'] as num?)?.toInt(),
      avatarImage: json['avatarImage'] as String?,
      gamesWon: (json['gamesWon'] as num?)?.toInt(),
      gamesPlayed: (json['gamesPlayed'] as num?)?.toInt(),
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
      amount: (json['amount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MakeMoveDtoToJson(MakeMoveDto instance) =>
    <String, dynamic>{
      'actionType': instance.actionType,
      'amount': instance.amount,
    };

Model _$ModelFromJson(Map<String, dynamic> json) => Model(
      modelId: (json['modelId'] as num?)?.toInt(),
      name: json['name'] as String?,
      path: json['path'] as String?,
      difficulty: json['difficulty'] as String?,
      userModels: (json['userModels'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ModelToJson(Model instance) => <String, dynamic>{
      'modelId': instance.modelId,
      'name': instance.name,
      'path': instance.path,
      'difficulty': instance.difficulty,
      'userModels': instance.userModels?.map((e) => e.toJson()).toList(),
    };

Move _$MoveFromJson(Map<String, dynamic> json) => Move(
      moveId: (json['moveId'] as num?)?.toInt(),
      gameRoundId: (json['gameRoundId'] as num?)?.toInt(),
      playerId: (json['playerId'] as num?)?.toInt(),
      actionType: json['actionType'] as String?,
      amount: (json['amount'] as num?)?.toInt(),
      moveTime: json['moveTime'] == null
          ? null
          : DateTime.parse(json['moveTime'] as String),
      round: json['round'] as String?,
      gameRound: json['gameRound'] == null
          ? null
          : GameRound.fromJson(json['gameRound'] as Map<String, dynamic>),
      player: json['player'] == null
          ? null
          : User.fromJson(json['player'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MoveToJson(Move instance) => <String, dynamic>{
      'moveId': instance.moveId,
      'gameRoundId': instance.gameRoundId,
      'playerId': instance.playerId,
      'actionType': instance.actionType,
      'amount': instance.amount,
      'moveTime': instance.moveTime?.toIso8601String(),
      'round': instance.round,
      'gameRound': instance.gameRound?.toJson(),
      'player': instance.player?.toJson(),
    };

MoveDto _$MoveDtoFromJson(Map<String, dynamic> json) => MoveDto(
      playerId: (json['playerId'] as num?)?.toInt(),
      actionType: json['actionType'] as String?,
      amount: (json['amount'] as num?)?.toInt(),
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

PlayerCard _$PlayerCardFromJson(Map<String, dynamic> json) => PlayerCard(
      playerCardId: (json['playerCardId'] as num?)?.toInt(),
      gamePlayerId: (json['gamePlayerId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      gameRoundId: (json['gameRoundId'] as num?)?.toInt(),
      cardId: (json['cardId'] as num?)?.toInt(),
      position: (json['position'] as num?)?.toInt(),
      card: json['card'] == null
          ? null
          : Card.fromJson(json['card'] as Map<String, dynamic>),
      gamePlayer: json['gamePlayer'] == null
          ? null
          : GamePlayer.fromJson(json['gamePlayer'] as Map<String, dynamic>),
      gameRound: json['gameRound'] == null
          ? null
          : GameRound.fromJson(json['gameRound'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlayerCardToJson(PlayerCard instance) =>
    <String, dynamic>{
      'playerCardId': instance.playerCardId,
      'gamePlayerId': instance.gamePlayerId,
      'userId': instance.userId,
      'gameRoundId': instance.gameRoundId,
      'cardId': instance.cardId,
      'position': instance.position,
      'card': instance.card?.toJson(),
      'gamePlayer': instance.gamePlayer?.toJson(),
      'gameRound': instance.gameRound?.toJson(),
      'user': instance.user?.toJson(),
    };

PlayerStateDto _$PlayerStateDtoFromJson(Map<String, dynamic> json) =>
    PlayerStateDto(
      userId: (json['userId'] as num?)?.toInt(),
      username: json['username'] as String?,
      currentChips: (json['currentChips'] as num?)?.toInt(),
      isActive: json['isActive'] as bool?,
      isDealer: json['isDealer'] as bool?,
      isSmallBlind: json['isSmallBlind'] as bool?,
      isBigBlind: json['isBigBlind'] as bool?,
      seatPosition: (json['seatPosition'] as num?)?.toInt(),
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

PokerTable _$PokerTableFromJson(Map<String, dynamic> json) => PokerTable(
      tableId: (json['tableId'] as num?)?.toInt(),
      name: json['name'] as String?,
      entryFee: (json['entryFee'] as num?)?.toInt(),
      minBuyIn: (json['minBuyIn'] as num?)?.toInt(),
      maxBuyIn: (json['maxBuyIn'] as num?)?.toInt(),
      smallBlind: (json['smallBlind'] as num?)?.toInt(),
      bigBlind: (json['bigBlind'] as num?)?.toInt(),
      maxPlayers: (json['maxPlayers'] as num?)?.toInt(),
      difficultyLevel: json['difficultyLevel'] as String?,
      isActive: json['isActive'] as bool?,
      games: (json['games'] as List<dynamic>?)
              ?.map((e) => Game.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$PokerTableToJson(PokerTable instance) =>
    <String, dynamic>{
      'tableId': instance.tableId,
      'name': instance.name,
      'entryFee': instance.entryFee,
      'minBuyIn': instance.minBuyIn,
      'maxBuyIn': instance.maxBuyIn,
      'smallBlind': instance.smallBlind,
      'bigBlind': instance.bigBlind,
      'maxPlayers': instance.maxPlayers,
      'difficultyLevel': instance.difficultyLevel,
      'isActive': instance.isActive,
      'games': instance.games?.map((e) => e.toJson()).toList(),
    };

Purchase _$PurchaseFromJson(Map<String, dynamic> json) => Purchase(
      purchaseId: (json['purchaseId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      itemId: (json['itemId'] as num?)?.toInt(),
      purchaseDate: json['purchaseDate'] == null
          ? null
          : DateTime.parse(json['purchaseDate'] as String),
      price: (json['price'] as num?)?.toDouble(),
      paymentMethod: json['paymentMethod'] as String?,
      transactionId: json['transactionId'] as String?,
      item: json['item'] == null
          ? null
          : ShopItem.fromJson(json['item'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PurchaseToJson(Purchase instance) => <String, dynamic>{
      'purchaseId': instance.purchaseId,
      'userId': instance.userId,
      'itemId': instance.itemId,
      'purchaseDate': instance.purchaseDate?.toIso8601String(),
      'price': instance.price,
      'paymentMethod': instance.paymentMethod,
      'transactionId': instance.transactionId,
      'item': instance.item?.toJson(),
      'user': instance.user?.toJson(),
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
      userId: (json['userId'] as num?)?.toInt(),
      username: json['username'] as String?,
      amountWon: (json['amountWon'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RoundWinnerDtoToJson(RoundWinnerDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'amountWon': instance.amountWon,
    };

ShopItem _$ShopItemFromJson(Map<String, dynamic> json) => ShopItem(
      itemId: (json['itemId'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      itemType: json['itemType'] as String?,
      isActive: json['isActive'] as bool?,
      purchases: (json['purchases'] as List<dynamic>?)
              ?.map((e) => Purchase.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ShopItemToJson(ShopItem instance) => <String, dynamic>{
      'itemId': instance.itemId,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'currency': instance.currency,
      'itemType': instance.itemType,
      'isActive': instance.isActive,
      'purchases': instance.purchases?.map((e) => e.toJson()).toList(),
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

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: (json['userId'] as num?)?.toInt(),
      username: json['username'] as String?,
      email: json['email'] as String?,
      passwordHash: json['passwordHash'] as String?,
      chipsBalance: (json['chipsBalance'] as num?)?.toInt(),
      avatarImage: json['avatarImage'] as String?,
      avatarType: json['avatarType'] as String?,
      registrationDate: json['registrationDate'] == null
          ? null
          : DateTime.parse(json['registrationDate'] as String),
      lastLoginDate: json['lastLoginDate'] == null
          ? null
          : DateTime.parse(json['lastLoginDate'] as String),
      isActive: json['isActive'] as bool?,
      isBot: json['isBot'] as bool?,
      chipTransactions: (json['chipTransactions'] as List<dynamic>?)
              ?.map((e) => ChipTransaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      gamePlayers: (json['gamePlayers'] as List<dynamic>?)
              ?.map((e) => GamePlayer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      gameRoundWinners: (json['gameRoundWinners'] as List<dynamic>?)
              ?.map((e) => GameRoundWinner.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      moves: (json['moves'] as List<dynamic>?)
              ?.map((e) => Move.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      playerCards: (json['playerCards'] as List<dynamic>?)
              ?.map((e) => PlayerCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      purchases: (json['purchases'] as List<dynamic>?)
              ?.map((e) => Purchase.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      userModels: (json['userModels'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'email': instance.email,
      'passwordHash': instance.passwordHash,
      'chipsBalance': instance.chipsBalance,
      'avatarImage': instance.avatarImage,
      'avatarType': instance.avatarType,
      'registrationDate': instance.registrationDate?.toIso8601String(),
      'lastLoginDate': instance.lastLoginDate?.toIso8601String(),
      'isActive': instance.isActive,
      'isBot': instance.isBot,
      'chipTransactions':
          instance.chipTransactions?.map((e) => e.toJson()).toList(),
      'gamePlayers': instance.gamePlayers?.map((e) => e.toJson()).toList(),
      'gameRoundWinners':
          instance.gameRoundWinners?.map((e) => e.toJson()).toList(),
      'moves': instance.moves?.map((e) => e.toJson()).toList(),
      'playerCards': instance.playerCards?.map((e) => e.toJson()).toList(),
      'purchases': instance.purchases?.map((e) => e.toJson()).toList(),
      'userModels': instance.userModels?.map((e) => e.toJson()).toList(),
    };

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
      userId: (json['userId'] as num?)?.toInt(),
      username: json['username'] as String?,
      email: json['email'] as String?,
      chipsBalance: (json['chipsBalance'] as num?)?.toInt(),
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

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userModelId: (json['userModelId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      modelId: (json['modelId'] as num?)?.toInt(),
      model: json['model'] == null
          ? null
          : Model.fromJson(json['model'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'userModelId': instance.userModelId,
      'userId': instance.userId,
      'modelId': instance.modelId,
      'model': instance.model?.toJson(),
      'user': instance.user?.toJson(),
    };
