import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  Loading({this.loading, this.child});

  final Stream<bool> loading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: loading,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data) {
            return Stack(
              children: <Widget>[
                child,
                Opacity(
                  opacity: 0.3,
                  child: ModalBarrier(
                    barrierSemanticsDismissible: false,
                    color: Colors.grey,
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                ),
              ],
            );
          } else {
            return child;
          }
        });
  }
}
