import '../../domain/facades/character_facade_usecases_interface.dart';
import '../commands/character_commands.dart';
import 'characters_commands_view_model.dart';
import 'characters_state_viewmodel.dart';

// ViewModel principal que será consumida na UI
/// que mostra a lista de personagens
class CharactersViewModel {
  late final CharactersStateViewmodel _state;

  CharactersStateViewmodel get charactersState => _state;

  late final CharactersCommandsViewModel commands;
  CharactersViewModel(ICharacterFacadeUseCases facade) {
    _state = CharactersStateViewmodel();
    // dispara os commands e effects
    commands = CharactersCommandsViewModel(
      state: _state,
      getAccountCommand: GetAllCharactersCommand(facade),
      createCharacterCommand: CreateCharacterCommand(facade),
      updateCharacterCommand: UpdateCharacterCommand(facade), 
      deleteCharacterCommand: DeleteCharacterCommand(facade),
    );
  }
   // --- Comandos expostos ---
  GetAllCharactersCommand get getAllCharactersCommand =>
      commands.getAllCharactersCommand;
  CreateCharacterCommand get createCharacterCommand =>
      commands.createCharacterCommand;
  UpdateCharacterCommand get updateCharacterCommand =>
      commands.updateCharacterCommand;
  DeleteCharacterCommand get deleteCharacterCommand =>
      commands.deleteCharacterCommand;
}