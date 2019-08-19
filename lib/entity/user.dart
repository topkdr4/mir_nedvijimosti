class User {
    String _name;
    bool _valid = false;

    String get name => _name;

    set name(String value) {
        _name = value;
    }

    bool get valid => _valid;

    set valid(bool value) {
        _valid = value;
    }


}