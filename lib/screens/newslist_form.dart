import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class NewsFormDialog extends StatefulWidget {
  final CookieRequest request;
  final VoidCallback? onSuccess;

  const NewsFormDialog({
    super.key,
    required this.request,
    this.onSuccess,
  });

  @override
  State<NewsFormDialog> createState() => _NewsFormDialogState();
}

class _NewsFormDialogState extends State<NewsFormDialog> {
  static const Color red = Color(0xFFAA1515);

  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _content = "";
  String? _category;
  String _thumbnail = "";
  bool _isFeatured = false;

  bool _isSubmitting = false;

  final List<String> _categories = const [
    'transfer',
    'update',
    'exclusive',
    'match',
    'rumor',
    'analysis',
  ];

  InputDecoration _dec(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: red, width: 1.6),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final response = await widget.request.postJson(
        "https://muhammad-farrel46-garudalounge.pbp.cs.ui.ac.id/news/create-flutter/",
        jsonEncode({
          "title": _title,
          "content": _content,
          "thumbnail": _thumbnail,
          "category": _category,
          "is_featured": _isFeatured,
        }),
      );

      if (!mounted) return;

      final status = response["status"];
      final isSuccess =
          status == true || status == "success" || status == "ok";

      if (isSuccess) {
        Navigator.pop(context);
        widget.onSuccess?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("News successfully saved!")),
        );
      } else {
        final msg = response["message"]?.toString() ??
            "Something went wrong, please try again.";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Tambah Berita Baru",
                      style: TextStyle(
                        color: red,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed:
                    _isSubmitting ? null : () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: _dec("Judul"),
                      onChanged: (v) => _title = v,
                      validator: (v) =>
                      (v == null || v.trim().isEmpty)
                          ? "Judul wajib diisi"
                          : null,
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      maxLines: 5,
                      decoration: _dec("Konten"),
                      onChanged: (v) => _content = v,
                      validator: (v) =>
                      (v == null || v.trim().isEmpty)
                          ? "Konten wajib diisi"
                          : null,
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: _category,
                      decoration: _dec("Kategori", hint: "Pilih kategori"),
                      items: _categories
                          .map(
                            (cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(
                            cat[0].toUpperCase() + cat.substring(1),
                          ),
                        ),
                      )
                          .toList(),
                      onChanged: (v) => _category = v,
                      validator: (v) =>
                      v == null ? "Pilih kategori dulu" : null,
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      decoration: _dec(
                        "Thumbnail URL",
                        hint: "https://example.com/image.jpg",
                      ),
                      onChanged: (v) => _thumbnail = v,
                    ),
                    const SizedBox(height: 8),

                    CheckboxListTile(
                      value: _isFeatured,
                      onChanged: (v) {
                        setState(() {
                          _isFeatured = v ?? false;
                        });
                      },
                      title: const Text("Featured News"),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      activeColor: red,
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: _isSubmitting
                              ? null
                              : () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _isSubmitting ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: red,
                            foregroundColor: Colors.white, // bikin teks pasti kontras
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text("Publish"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
