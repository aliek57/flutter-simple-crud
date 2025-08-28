class Vehicle {
  String _licensePlate, _description;
  int _year, _km;
  double _price;

  Vehicle(this._licensePlate, this._description,
          this._year, this._km, this._price);

  double get price => _price;
  set price(double value) { _price = value; }

  int get km => _km;
  set km(int value) { _km = value; }

  int get year => _year;
  set year(int value) { _year = value; }

  String get description => _description;
  set description(String value) { _description = value; }

  String get licensePlate => _licensePlate;
  set licensePlate(String value) { _licensePlate = value; }
}