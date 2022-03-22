import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef OnFocused = void Function(
    FocusNode node, TextEditingController controller)?;

/// A text field that can listen to a riverpod provider and update it's text base on the provider.
///
/// Exmaple usage
/// ```
/// final commentProvider = StateProvider<String>((ref) => "");
///
/// class CommentField extends StatelessWidget {
///    const CommentField({Key? key}) : super(key: key);
///
///    @override
///    Widget build(BuildContext context) {
///      return DynamicTextField(
///         listenProvider: commentProvider,
///       );
///    }
///  }
/// ```
/// The Field will listen to changes to the `commentProvider`.
class DynamicTextField<T> extends ConsumerStatefulWidget {
  const DynamicTextField(
      {Key? key,
      this.label,
      required this.listenProvider,
      this.onLoseFocus,
      this.initialText,
      this.decoration,
      this.onFieldSubmitted,
      this.enabled = true,
      this.onChanged,
      this.inputFormatters,
      this.keyboardType,
      this.validator,
      this.onFocused,
      this.readOnly = false})
      : super(key: key);

  final String? label;
  final InputDecoration? decoration;
  final ProviderListenable<T> listenProvider;
  final void Function(String v)? onLoseFocus;
  final String? initialText;
  final bool enabled;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onFieldSubmitted;
  final bool readOnly;

  final OnFocused? onFocused;
  @override
  _DynamicTextFieldState<T> createState() => _DynamicTextFieldState();
}

class _DynamicTextFieldState<T> extends ConsumerState<DynamicTextField<T>> {
  final _controller = TextEditingController();
  final _node = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null) {
      _controller.text = widget.initialText!;
    }

    if (widget.onFocused != null) {
      _node.addListener(() {
        if (_node.hasFocus) {
          widget.onFocused!(_node, _controller);
        }
      });
    }

    if (widget.onLoseFocus != null) {
      _node.addListener(() {
        if (!_node.hasFocus && _controller.text.isNotEmpty) {
          widget.onLoseFocus!(_controller.text);
        }
      });
    }
  }

  @override
  void dispose() {
    _node.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<T>(widget.listenProvider, (pre, cur) {
      _controller.text = cur.toString();
    });

    return TextFormField(
      enabled: widget.enabled,
      focusNode: _node,
      decoration: widget.label != null
          ? widget.decoration?.copyWith(label: Text(widget.label!)) ??
              InputDecoration(
                label: Text(widget.label!),
              )
          : widget.decoration,
      controller: _controller,
      onFieldSubmitted: (v) {
        if (widget.onFieldSubmitted != null) {
          widget.onFieldSubmitted!(v);
        }
      },
      onChanged: widget.onChanged,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
    );
  }
}
