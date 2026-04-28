import '../../core/failure/failure.dart';
import '../../core/patterns/command.dart';
import '../../core/patterns/result.dart';
import '../../core/typedefs/types_defs.dart';
import '../../domain/facades/character_facade_usecases_interface.dart';
import '../../domain/models/character_entity.dart';

final class CreateCharacterCommand
    extends ParameterizedCommand<Character, Failure, CharacterParams> {
  final ICharacterFacadeUseCases _facade;

  CreateCharacterCommand(this._facade);

  @override
  Future<CharacterResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo'));
    }

    return await _facade.saveCharacter(parameter!);
  }
}

final class UpdateCharacterCommand
    extends ParameterizedCommand<Character, Failure, CharacterParams> {
  final ICharacterFacadeUseCases _facade;

  UpdateCharacterCommand(this._facade);

  @override
  Future<CharacterResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo'));
    }

    return await _facade.updateCharacter(parameter!);
  }
}

final class DeleteCharacterCommand
    extends ParameterizedCommand<Character, Failure, CharacterIdParams> {
  final ICharacterFacadeUseCases _facade;

  DeleteCharacterCommand(this._facade);

  @override
  Future<CharacterResult> execute() async {
    if (parameter == null || parameter!.id.isEmpty) {
      return Error(InputFailure('Parametro inválido para delete'));
    }

    return await _facade.deleteCharacter(parameter!);
  }
}

final class GetAllCharactersCommand
    extends ParameterizedCommand<List<Character>, Failure, NoParams> {
  final ICharacterFacadeUseCases _facade;

  GetAllCharactersCommand(this._facade);

  @override
  Future<ListCharacterResult> execute() async {
    return await _facade.getAllCharacters(());
  }
}