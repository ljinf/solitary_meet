import 'package:flutter/cupertino.dart';

class CommentView extends StatefulWidget {
  const CommentView({super.key});

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/images/empty.png",
        width: 128,
        height: 128,
      ),
    );
  }
}
