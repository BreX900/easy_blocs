import 'package:flutter/widgets.dart';

class Signer implements PeopleMarked {
  List<PeopleMarked> _signers = [];

  void addSigner(Signer signer) => _signers.add(signer);

  void removeSigner(Signer signer) => _signers.remove(signer);

  void addPeople(PeopleMarked people) => _signers.forEach((signer) => signer.addPeople(people));

  void removePeople(PeopleMarked people) =>
      _signers.forEach((signer) => signer.removePeople(people));

  void dispose() => _signers = null;
}

abstract class PeopleMarked {
  void addPeople(PeopleMarked people);
  void removePeople(PeopleMarked people);
}

class SignerProvider extends StatefulWidget {
  final ValueGetter<Signer> getSigner;
  final Widget child;

  const SignerProvider({Key key, @required this.getSigner, @required this.child}) : super(key: key);

  @override
  _SignerProviderState createState() => _SignerProviderState();

  static Signer of(BuildContext context) => _SignerProvider.of(context);
}

mixin SignerStateMixin on State {
  PeopleMarked _people;
  Signer _signer;

  PeopleMarked get people;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _signer = SignerProvider.of(context);
  }

  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_people != people) {
      _signer.removePeople(_people);
      _people = people;
      _signer.addPeople(_people);
    }
  }

  @override
  void dispose() {
    _signer.removePeople(_people);
    super.dispose();
  }
}

class _SignerProviderState extends State<SignerProvider> {
  Signer _signer, _topSigner;

  @override
  void initState() {
    super.initState();
    _signer = widget.getSigner();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newTopSigner = SignerProvider.of(context);
    if (_topSigner != newTopSigner) {
      _topSigner?.removeSigner(_signer);
      _topSigner = newTopSigner;
      _topSigner.addSigner(_signer);
    }
  }

  @override
  void dispose() {
    _topSigner.removeSigner(_signer);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SignerProvider(
      signer: _signer,
      child: widget.child,
    );
  }
}

class _SignerProvider extends InheritedWidget {
  final Signer signer;

  const _SignerProvider({
    Key key,
    this.signer,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static Signer of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_SignerProvider) as _SignerProvider)?.signer;
  }

  @override
  bool updateShouldNotify(_SignerProvider old) {
    return false;
  }
}
