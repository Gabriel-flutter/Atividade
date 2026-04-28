import 'package:flutter/material.dart';
import 'package:injustice_app/domain/models/character_entity.dart';
import 'package:injustice_app/presentation/controllers/characters_view_model.dart';
import 'number_stepper.dart';

class CreateCharacterSheet extends StatefulWidget {
  final CharactersViewModel viewModel;

  const CreateCharacterSheet({super.key, required this.viewModel});

  @override
  State<CreateCharacterSheet> createState() =>
      _CreateCharacterSheetState();
}

class _CreateCharacterSheetState extends State<CreateCharacterSheet> {
  final _nameController = TextEditingController();

  int _level = 1;
  int _stars = 1;

  CharacterClass _class = CharacterClass.poderoso;
  CharacterRarity _rarity = CharacterRarity.prata;
  CharacterAlignment _alignment = CharacterAlignment.heroi;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (_nameController.text.trim().isEmpty) return;

    final now = DateTime.now();

    final character = Character(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),

      characterClass: _class,
      rarity: _rarity,
      alignment: _alignment,

      level: _level,
      threat: _level * 10,
      attack: _level * 5,
      health: _level * 20,
      stars: _stars,

      createdAt: now,
      updatedAt: now,
    );

    await widget.viewModel.commands.addCharacter(character);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = widget
        .viewModel
        .commands
        .createCharacterCommand
        .isExecuting
        .value;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Criar Personagem',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField(
              value: _class,
              items: CharacterClass.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.displayName),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _class = v!),
              decoration: const InputDecoration(labelText: 'Classe'),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField(
              value: _rarity,
              items: CharacterRarity.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.displayName),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _rarity = v!),
              decoration: const InputDecoration(labelText: 'Raridade'),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField(
              value: _alignment,
              items: CharacterAlignment.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.displayName),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _alignment = v!),
              decoration: const InputDecoration(labelText: 'Alinhamento'),
            ),

            const SizedBox(height: 12),

            NumberStepper(
              label: 'Level',
              value: _level,
              min: 1,
              max: 80,
              onChanged: (v) => setState(() => _level = v),
            ),

            const SizedBox(height: 8),

            NumberStepper(
              label: 'Stars',
              value: _stars,
              min: 1,
              max: 14,
              onChanged: (v) => setState(() => _stars = v),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _create,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Criar'),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}