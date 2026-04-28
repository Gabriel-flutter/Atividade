import 'package:flutter/material.dart';
import '../../../../../domain/models/character_entity.dart';
import '../../../../controllers/characters_view_model.dart';

class EditCharacterSheet extends StatefulWidget {
  final Character character;
  final CharactersViewModel viewModel;

  const EditCharacterSheet({
    super.key,
    required this.character,
    required this.viewModel,
  });

  @override
  State<EditCharacterSheet> createState() => _EditCharacterSheetState();
}

class _EditCharacterSheetState extends State<EditCharacterSheet> {
  late TextEditingController nameController;
  late TextEditingController levelController;
  late TextEditingController starsController;
  late TextEditingController threatController;

  late CharacterRarity rarity;
  late CharacterClass characterClass;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.character.name);
    levelController =
        TextEditingController(text: widget.character.level.toString());
    starsController =
        TextEditingController(text: widget.character.stars.toString());
    threatController =
        TextEditingController(text: widget.character.threat.toString());

    rarity = widget.character.rarity;
    characterClass = widget.character.characterClass;
  }

  @override
  void dispose() {
    nameController.dispose();
    levelController.dispose();
    starsController.dispose();
    threatController.dispose();
    super.dispose();
  }

  void save() {
    final updated = widget.character.copyWith(
      name: nameController.text,
      level: int.tryParse(levelController.text) ?? 1,
      stars: int.tryParse(starsController.text) ?? 1,
      threat: int.tryParse(threatController.text) ?? 0,
      rarity: rarity,
      characterClass: characterClass,
    );

    widget.viewModel.commands.updateCharacter(updated);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('Editar personagem',
                style: Theme.of(context).textTheme.titleLarge),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),

            TextField(
              controller: levelController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Level'),
            ),

            TextField(
              controller: starsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Stars'),
            ),

            TextField(
              controller: threatController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Threat'),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField(
              value: rarity,
              items: CharacterRarity.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => rarity = v!),
              decoration: const InputDecoration(labelText: 'Raridade'),
            ),

            DropdownButtonFormField(
              value: characterClass,
              items: CharacterClass.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => characterClass = v!),
              decoration: const InputDecoration(labelText: 'Classe'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: save,
              child: const Text('Salvar'),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}