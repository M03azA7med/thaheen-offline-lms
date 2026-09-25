import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class VideoFailure extends Failure {
  const VideoFailure(super.message);
}

class AssetFailure extends Failure {
  const AssetFailure(super.message);
}
