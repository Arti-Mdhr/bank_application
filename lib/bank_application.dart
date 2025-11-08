abstract class BankAccount {
  int _accountNumber;
  String _accountHolderName;
  double _balance;

  List<String> _transactions = [];

  void withdraw(double amount);
  void deposit(double amount);

  BankAccount(
    this._accountNumber,
    this._accountHolderName,
    this._balance,
  );

  get getAccNum => _accountNumber;
  get getAccHolName => _accountHolderName;
  get getBalance => _balance;

  set setAccNum(int accNum) => _accountNumber = accNum;

  set setAccHolName(String accName) => _accountHolderName = accName;

  set setBalance(double newbalance) {
    if (newbalance <= 0) {
      print("Balance cannot be negative or zero!!!");
    } else {
      _balance = newbalance;
    }
  }

  void displayInfo() {
    print('''
    Account Number: $_accountNumber
    Account Holder Name: $_accountHolderName
    Balance: Rs. $_balance
    ''');
  }

  void addTransaction(String detail) {
    _transactions.add(detail);
  }

  void viewTransactions() {
    print("\nTransaction History for $_accountNumber is: \n");
    for (var t in _transactions) {
      print(t);
    }
  }
}

abstract class InterestBearing extends BankAccount {
  InterestBearing(
      super._accountNumber, super._accountHolderName, super._balance);

  double calculateInterest();
}

class SavingsAccount extends InterestBearing {
  int numOfWithdraw = 0;
  final int withdrawLimit = 3;
  final double _minBalance = 500;
  final double _interestRate = 0.02;

  SavingsAccount(
      super._accountNumber, super._accountHolderName, super._balance);

  @override
  void withdraw(double amount) {
    if (numOfWithdraw > withdrawLimit) {
      print("Withdraw Limit Reached !!");
    }
    if (_balance - amount < _minBalance) {
      print("Insufficient balance || Cannot Withdraw below minimum balance");
    } else {
      _balance -= amount;
      numOfWithdraw++;
      addTransaction("Withdrawn Rs. $amount");
      print("Withdrawn Rs. $amount from the account");
    }
  }

  @override
  void deposit(double amount) {
    _balance += amount;
    addTransaction("Deposited Rs. $amount");
    print('''Deposited Rs. $amount into the account
    New Balance: $_balance''');
  }

  @override
  double calculateInterest() {
    return _balance * _interestRate;
  }
}

class CheckingAccount extends BankAccount {
  final int _overdraftFee = 35;
  CheckingAccount(super._accountNumber, super._accountHolderName, super._balance);

  @override
  void withdraw(double amount) {
    _balance -= amount;
    if (_balance < 0) {
      _balance -= _overdraftFee;
      print("Overdraft Discovered !! Fee of Rs. $_overdraftFee Applied");
    }
    addTransaction("Withdrawn Rs. $amount");
    print("Withdrawn Rs. $amount from the account");
  }

  @override
  void deposit(double amount) {
    _balance += amount;
    addTransaction("Deposited Rs. $amount");
    print("Deposited Rs. $amount into the account");
  }
}

class PremiumAccount extends InterestBearing {
  final double _minBalance = 1000;
  final double _interestRate = 0.05;

  PremiumAccount(
      super._accountNumber, super._accountHolderName, super._balance);

  @override
  void withdraw(double amount) {
    if (_balance - amount < _minBalance) {
      print("Insufficient balance || Cannot Withdraw below minimum balance");
    } else {
      _balance -= amount;
      addTransaction("Withdrawn Rs. $amount");
      print('''Withdrawn Rs. $amount from the account
      New Balance: Rs. $_balance''');
    }
  }

  @override
  void deposit(double amount) {
    _balance += amount;
    addTransaction("Deposited Rs. $amount");
    print('''Deposited Rs. $amount into the account
    New Balance: Rs. $_balance''');
  }

  @override
  double calculateInterest() {
    return _balance * _interestRate;
  }
}

class StudentAccount extends BankAccount {
  static const double _maxBalance = 5000;

  StudentAccount(super._accountNumber, super._accountHolderName, super._balance);

  @override
  void withdraw(double amount) {
    if (_balance - amount < 0) {
      print("Insufficient balance");
    } else {
      _balance -= amount;
      addTransaction("Withdrawn Rs. $amount");
      print("Withdrawn Rs. $amount from the account. New Balance: $_balance");
    }
  }

  @override
  void deposit(double amount) {
    if (_balance + amount > _maxBalance) {
      print("Cannot deposit above maximum balance of Rs. $_maxBalance");
      _balance = _maxBalance;
    } else {
      _balance += amount;
      addTransaction("Deposited Rs. $amount");
      print("Deposited Rs. $amount into account. New Balance: $_balance");
    }
  }
}

