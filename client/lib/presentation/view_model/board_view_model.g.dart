// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$clientIdHash() => r'3175dc61529896be6972e9356c14f638a4bb650e';

/// クライアントIDを生成するProvider
///
/// Copied from [clientId].
@ProviderFor(clientId)
final clientIdProvider = AutoDisposeProvider<String>.internal(
  clientId,
  name: r'clientIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$clientIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ClientIdRef = AutoDisposeProviderRef<String>;
String _$serverUrlHash() => r'6a448e42c6ec8836391ef087e3c80ede54f1004c';

/// WebSocketのURLを提供するProvider
///
/// Copied from [serverUrl].
@ProviderFor(serverUrl)
final serverUrlProvider = AutoDisposeProvider<String>.internal(
  serverUrl,
  name: r'serverUrlProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$serverUrlHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ServerUrlRef = AutoDisposeProviderRef<String>;
String _$boardRepositoryHash() => r'8ccb9f716be1c560ccdbaf8e7769fb981833dd7c';

/// BoardRepositoryのProvider
///
/// Copied from [boardRepository].
@ProviderFor(boardRepository)
final boardRepositoryProvider = AutoDisposeProvider<BoardRepository>.internal(
  boardRepository,
  name: r'boardRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$boardRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BoardRepositoryRef = AutoDisposeProviderRef<BoardRepository>;
String _$connectionStateHash() => r'0ca4a82b2bab002a5481d193b7f2a0951cd58bad';

/// 接続状態を監視するProvider
///
/// Copied from [connectionState].
@ProviderFor(connectionState)
final connectionStateProvider = AutoDisposeStreamProvider<bool>.internal(
  connectionState,
  name: r'connectionStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectionStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConnectionStateRef = AutoDisposeStreamProviderRef<bool>;
String _$boardNotifierHash() => r'd49f528179f9a9839c088acbd789d8bcafba02f8';

/// CRDT状態を管理するNotifier
///
/// Copied from [BoardNotifier].
@ProviderFor(BoardNotifier)
final boardNotifierProvider =
    AutoDisposeNotifierProvider<BoardNotifier, CrdtState>.internal(
      BoardNotifier.new,
      name: r'boardNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$boardNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BoardNotifier = AutoDisposeNotifier<CrdtState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
