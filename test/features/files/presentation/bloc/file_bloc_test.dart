import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/features/files/domain/entities/file_item.dart';
import 'package:nexus_ai/features/files/domain/repositories/i_file_repository.dart';
import 'package:nexus_ai/features/files/domain/usecases/delete_file_usecase.dart';
import 'package:nexus_ai/features/files/domain/usecases/get_files_usecase.dart';
import 'package:nexus_ai/features/files/domain/usecases/rename_file_usecase.dart';
import 'package:nexus_ai/features/files/presentation/bloc/file_bloc.dart';

class MockGetFilesUseCase extends Mock implements GetFilesUseCase {}
class MockRenameFileUseCase extends Mock implements RenameFileUseCase {}
class MockDeleteFileUseCase extends Mock implements DeleteFileUseCase {}
class MockFileRepository extends Mock implements IFileRepository {}

void main() {
  late FileBloc bloc;
  late MockGetFilesUseCase mockGetFilesUseCase;
  late MockRenameFileUseCase mockRenameFileUseCase;
  late MockDeleteFileUseCase mockDeleteFileUseCase;
  late MockFileRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const GetFilesParams());
  });

  setUp(() {
    mockGetFilesUseCase = MockGetFilesUseCase();
    mockRenameFileUseCase = MockRenameFileUseCase();
    mockDeleteFileUseCase = MockDeleteFileUseCase();
    mockRepository = MockFileRepository();

    bloc = FileBloc(
      getFilesUseCase: mockGetFilesUseCase,
      renameFileUseCase: mockRenameFileUseCase,
      deleteFileUseCase: mockDeleteFileUseCase,
      repository: mockRepository,
    );
  });

  tearDown(() {
    bloc.close();
  });

  final tFile = FileItem(
    id: 'fl1',
    ownerId: 'u1',
    fileName: 'CS101_Lecture_Notes.pdf',
    originalName: 'CS101.pdf',
    mimeType: 'application/pdf',
    extension: 'pdf',
    sizeBytes: 2450000,
    folder: 'Documents',
    moduleName: 'PLANNER',
    fileUrl: 'https://api.nexus-ai.com/files/cs101.pdf',
    createdAt: DateTime.now(),
  );

  test('initial state should be FileInitialState', () {
    expect(bloc.state, equals(const FileInitialState()));
  });

  blocTest<FileBloc, FileState>(
    'emits [FileLoadingState, FileLoadedState] when LoadFilesEvent is added',
    build: () {
      when(() => mockGetFilesUseCase(any())).thenAnswer((_) async => Right([tFile]));
      when(() => mockRepository.getFolders()).thenAnswer((_) async => const Right([]));
      return bloc;
    },
    act: (b) => b.add(const LoadFilesEvent()),
    expect: () => [
      const FileLoadingState(),
      FileLoadedState(files: [tFile], folders: const []),
    ],
  );
}
