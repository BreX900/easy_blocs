import 'package:easy_blocs/src/skeletons/BoneProvider.dart';
import 'package:easy_blocs/src/skeletons/BoneProviderTree.dart';
import 'package:easy_blocs/src/skeletons/form/FormSkeleton.dart';
import 'package:flutter/widgets.dart';


class LightForm extends StatelessWidget {
  final FormSkeleton manager;
  final List<BoneProvider> boneProviders;
  final Widget child;

  LightForm({Key key, this.manager, this.child, this.boneProviders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BoneProviderTree(
      boneProviders: boneProviders..add(BoneProvider.tree(manager)),
      child: Form(
        key: manager.formKey,
        child: child,
      ),
    );
  }
}