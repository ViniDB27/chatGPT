import 'package:flutter/material.dart';

class InputMessage extends StatelessWidget {
  const InputMessage({
    required this.controller,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final void Function()? onPressed;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Center(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Digite sua mensagem',
                ),
                onEditingComplete: onPressed,
                onSubmitted: (_) => onPressed!(),
              ),
            ),
            IconButton(
              onPressed: onPressed,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
