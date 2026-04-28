import '../../core/failure/failure.dart';
import '../../core/patterns/command.dart';
import '../../domain/models/character_entity.dart';
import '../commands/character_commands.dart';
import 'characters_state_viewmodel.dart';
import 'package:signals_flutter/signals_flutter.dart';

class CharactersCommandsViewModel {
  final CharactersStateViewmodel state;
  final GetAllCharactersCommand _getAccountCommand;
  final CreateCharacterCommand _createCharacterCommand;
  final UpdateCharacterCommand _updateCharacterCommand; 
  final DeleteCharacterCommand _deleteCharacterCommand;

  CharactersCommandsViewModel({
    required this.state,
    required GetAllCharactersCommand getAccountCommand,
    required CreateCharacterCommand createCharacterCommand,
    required UpdateCharacterCommand updateCharacterCommand, 
    required DeleteCharacterCommand deleteCharacterCommand,
  })  : _getAccountCommand = getAccountCommand,
        _createCharacterCommand = createCharacterCommand,
        _updateCharacterCommand = updateCharacterCommand, 
        _deleteCharacterCommand = deleteCharacterCommand {
    // Observers para cada comando
    _observeGetAllCharacters();
    _observeCreateCharacter();
    _observeUpdateCharacter(); 
    _observeDeleteCharacter();
  }

  // ========================================================
  //   GETTERS PARA WIDGETS USAREM DIRETAMENTE OS COMANDOS
  // ========================================================
  GetAllCharactersCommand get getAllCharactersCommand => _getAccountCommand;
  CreateCharacterCommand get createCharacterCommand => _createCharacterCommand;
  UpdateCharacterCommand get updateCharacterCommand => _updateCharacterCommand;
  DeleteCharacterCommand get deleteCharacterCommand => _deleteCharacterCommand;


  // ========================================================
  //   MÉTODO GENÉRICO DE OBSERVAÇÃO DE COMANDOS
  // ========================================================
  void _observeCommand<T>(
    Command<T, Failure> command, {
    required void Function(T data) onSuccess,
    void Function(Failure err)? onFailure,
  }) {
    effect(() {
      // 1) Ignora enquanto está executando
      if (command.isExecuting.value) return;

      // 2) ignora até existir um resultado
      final result = command.result.value;
      if (result == null) return;

      // 3) Sucesso ou falha
      result.fold(
        onSuccess: (data) {
          state.clearMessage(); // sempre limpa erros em sucesso
          onSuccess(data); // ação especifífica para esse comando
          command.clear();
        },
        onFailure: (err) {
          state.setMessage(err.msg); //registra o erro no estados
          if (onFailure != null) onFailure(err); //talvez retirar
          command.clear();
        },
      );
    });
  }

  void _observeGetAllCharacters() {
    _observeCommand<List<Character>>(
      _getAccountCommand,
      onSuccess: (characters) {
        state.state.value = characters;
      },
    );
  }

  void _observeCreateCharacter() {
    _observeCommand<Character>(
      _createCharacterCommand,
      onSuccess: (newCharacter) {
        final list = [...state.state.value, newCharacter];
        state.state.value = list;
      },
    );
  }

  void _observeUpdateCharacter() {
    _observeCommand<Character>(
      _updateCharacterCommand,
      onSuccess: (updatedCharacter) {
        final list = state.state.value.map((c) {
          return c.id == updatedCharacter.id ? updatedCharacter : c;
        }).toList();

        state.state.value = list;
      },
    );
  }

  void _observeDeleteCharacter() {
    _observeCommand<Character>(
      _deleteCharacterCommand,
      onSuccess: (deletedCharacter) {
        final list = state.state.value
            .where((c) => c.id != deletedCharacter.id)
            .toList();

        state.state.value = list;
      },
    );
  }

  Future<void> fetchCharacters() async {
    state.clearMessage(); 
    await _getAccountCommand.executeWith(());
  }
  Future<void> addCharacter(Character character) async {
    state.clearMessage();
    await _createCharacterCommand.executeWith((character: character));
  }

  Future<void> updateCharacter(Character character) async {
    state.clearMessage();
    await _updateCharacterCommand.executeWith((character: character));
  }

  Future<void> deleteCharacter(String id) async {
    await _deleteCharacterCommand.executeWith((id: id));
  }
}