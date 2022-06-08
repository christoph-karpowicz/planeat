class ShoppingItemDto {
  final String _startingString;
  double? _quantity;
  String? _unit;
  List<ShoppingItemDto> _leftovers = <ShoppingItemDto>[];
  bool _isLeftover = false;

  ShoppingItemDto(this._startingString) {
    _init();
  }

  get startingString {
    return _startingString;
  }

  get quantity {
    return _quantity;
  }

  get unit {
    return _unit;
  }

  set setIsLeftover(bool isLeftover) {
    _isLeftover = isLeftover;
  }

  void _init() {
    _getUnit();
    _getQuantity();
  }

  void _getUnit() {
    RegExp unitRegex = new RegExp(r'([a-zA-Z]+$)');
    Match? unitMatch = unitRegex.firstMatch(_startingString);
    if (unitMatch != null) {
      _unit = _startingString.substring(unitMatch.start, unitMatch.end).trim();
    }
  }

  void _getQuantity() {
    RegExp numRegex = new RegExp(r'([0-9]+((\.|,)[0-9]+)?)');
    Match? firstMatch = numRegex.firstMatch(_startingString);
    if (firstMatch != null) {
      String quantity = _startingString.substring(firstMatch.start, firstMatch.end).replaceAll(r',', '.').trim();
      _quantity = double.parse(quantity);
    }
  }

  bool merge(ShoppingItemDto other) {
    if (other.unit != this._unit || this._quantity == null || other.quantity == null) {
      bool mergeInLeftover = false;
      for (ShoppingItemDto leftover in this._leftovers) {
        bool merged = leftover.merge(other);
        if (merged) {
          mergeInLeftover = true;
          break;
        }
      }
      if (!this._isLeftover && !mergeInLeftover) {
        other.setIsLeftover = true;
        this._leftovers.add(other);
      }
      return false;
    }

    this._quantity = this._quantity! + other.quantity!;
    return true;
  }

  @override
  String toString() {
    String result = "";

    if (_quantity != null) {
      if (_quantity! % 1 == 0) {
        result = result + _quantity!.toInt().toString();
      } else {
        result = result + _quantity.toString();
      }
    }

    if (_unit != null) {
      result = result + _unit!;
    }

    if (_quantity == null && _unit == null) {
      result = result + _startingString;
    }

    if (_leftovers.length > 0 && result.isNotEmpty) {
      String leftovers = _leftovers
          .map((l) => l.toString())
          .where((l) => l.isNotEmpty)
          .toList().join(", ");
      result = result + ', ' + leftovers;
    }

    return result;
  }
}
