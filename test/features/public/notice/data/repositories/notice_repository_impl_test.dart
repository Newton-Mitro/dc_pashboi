import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/public/notice/data/data_sources/remote_notice_datasource.dart';
import 'package:pashboi/features/public/notice/data/models/notice_model.dart';
import 'package:pashboi/features/public/notice/data/repositories/notice_repository_impl.dart';
import 'package:pashboi/features/public/notice/domain/enities/notice_entity.dart';

class MockNoticeRemoteDataSource extends Mock
    implements NoticeRemoteDataSource {}

void main() {
  late MockNoticeRemoteDataSource mockRemoteDataSource;
  late NoticeRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockNoticeRemoteDataSource();
    repository = NoticeRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final noticeModelList = [
    NoticeModel.fromJson({
      "id": "01jy1k4sfytxshv2gqkj97fxc3",
      "title": "Job Circular of Dance Teacher for Nadda",
      "slug": "job-circular-of-dance-teacher-for-nadda",
      "order": 99,
      "short_description": "<p>Job Circular of Dance Teacher for Nadda</p>",
      "description": "<p>Job Circular of Dance Teacher for Nadda</p>",
      "attachment_url": "https://www.cccul.com/attachments/1750252807.jpg",
      "attachment_path": "attachments",
      "attachment_name": "1750252807.jpg",
      "attachment_mime": "image/jpeg",
      "publish_status": "Published",
      "created_at": "2025-06-18T13:20:07.000000Z",
      "updated_at": "2025-06-18T13:20:17.000000Z",
    }),
  ];

  group('NoticeRepositoryImpl', () {
    test('fetches notice data from the remote data source', () async {
      when(
        () => mockRemoteDataSource.findNotice(),
      ).thenAnswer((_) async => noticeModelList);

      final result = await repository.findNotice();

      verify(() => mockRemoteDataSource.findNotice()).called(1);
      expect(result, Right<Failure, List<NoticeEntity>>(noticeModelList));
    });

    test('returns a network failure when the remote request fails', () async {
      when(
        () => mockRemoteDataSource.findNotice(),
      ).thenThrow(const SocketException('No route to host'));

      final result = await repository.findNotice();

      expect(
        result.fold((failure) => failure, (_) => null),
        isA<NetworkFailure>(),
      );
    });
  });
}
