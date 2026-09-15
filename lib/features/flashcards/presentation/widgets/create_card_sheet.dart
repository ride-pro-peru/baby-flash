import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';

typedef CreateCardCallback = void Function(String word, File image);

class CreateCardSheet extends StatefulWidget {
  final String categoryName;
  final CreateCardCallback onSave;

  const CreateCardSheet({
    super.key,
    required this.categoryName,
    required this.onSave,
  });

  @override
  State<CreateCardSheet> createState() => _CreateCardSheetState();
}

class _CreateCardSheetState extends State<CreateCardSheet> {
  final TextEditingController _wordController = TextEditingController();
  File? _image;

  bool get _canSave => _wordController.text.trim().isNotEmpty && _image != null;

  @override
  void dispose() {
    _wordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 88,
    );
    if (picked == null || !mounted) return;
    setState(() => _image = File(picked.path));
  }

  void _save() {
    final word = _wordController.text.trim();
    final image = _image;
    if (word.isEmpty || image == null) return;
    Navigator.of(context).pop();
    widget.onSave(word, image);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = CupertinoTheme.brightnessOf(context);

    return CupertinoPageScaffold(
      backgroundColor: AppColors.backgroundFor(brightness),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.cardBackgroundFor(brightness),
        middle: const Text('Nueva tarjeta'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Categoría: ${widget.categoryName}',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondaryFor(brightness),
                ),
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: _wordController,
                placeholder: 'Palabra (ej. Tigre)',
                placeholderStyle: TextStyle(
                  color: AppColors.textSecondaryFor(brightness),
                ),
                style: TextStyle(
                  color: AppColors.textPrimaryFor(brightness),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardBackgroundFor(brightness),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: brightness == Brightness.dark
                        ? CupertinoColors.systemGrey5
                        : CupertinoColors.systemGrey4,
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: AppColors.cardImageBackgroundFor(brightness),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.gallery_add,
                              size: 44,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Elegir foto de galería',
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.textSecondaryFor(brightness),
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            _image!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              CupertinoButton.filled(
                onPressed: _canSave ? _save : null,
                borderRadius: BorderRadius.circular(20),
                child: const Text('Guardar tarjeta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}