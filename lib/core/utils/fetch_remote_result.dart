import 'package:dartz/dartz.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/utils/failure_mapper.dart';

Future<Either<Failure, E>> fetchRemoteResult<T extends E, E>(
  Future<T> Function() fetch,
) async {
  try {
    return Right(await fetch());
  } on Object catch (error) {
    return Left(FailureMapper.fromException(error));
  }
}
