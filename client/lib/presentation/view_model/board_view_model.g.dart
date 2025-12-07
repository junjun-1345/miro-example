// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$clientIdHash() => r'd0e9f9dacc6fd8f565c3a5e70d63d086c10969f9';

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
String _$serverUrlHash() => r'2f008efd1cb21f511c129632f024145681a8dfab';

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
String _$boardRepositoryHash() => r'f3fef47f66e7b9da4bf115b29e2e471a220b9f7b';

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
String _$connectionStateHash() => r'bc8ead49b32e1bf9d2c22ac5918874e9d4072ccf';

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
