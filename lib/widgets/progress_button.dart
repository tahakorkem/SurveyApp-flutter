import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProgressButton extends StatefulWidget {
  final Future Function() onPressed;
  final Widget? child;

  ProgressButton({
    Key? key,
    required this.onPressed,
    //ButtonStyle? style,
    //bool autofocus = false,
    required this.child,
  }) : super(key: key);

  @override
  _ProgressButtonState createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      //style: ElevatedButton.styleFrom(onSurface: Theme.of(context).primaryColor),
      onPressed: isLoading
          ? null
          : () async {
              setState(() => isLoading = true);
              await widget.onPressed();
              setState(() => isLoading = false);
            },
      child: isLoading
          ? SizedBox(
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 3),
              width: 16,
              height: 16,
            )
          : widget.child,
    );
  }
}
