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

  set setAccNum(int accNum) {
    _accountNumber = accNum;
  }

  set setAccHolName(String accName) {
    _accountHolderName = accName;
  }

  set setBalance(double newbalance) {
    if (newbalance <= 0) {
      print("Balance cannot be negative or zero!");
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
    print("\nTransaction History for $_accountNumber:\n");
    for (var t in _transactions) {
      print(t);
    }
  }
}

abstract class InterestBearing extends BankAccount {
  InterestBearing(super._accountNumber, super._accountHolderName, super._balance);

  double calculateInterest();
}

class SavingsAccount extends InterestBearing {
  int numOfWithdraw = 0;
  final int withdrawLimit = 3;
  final double _minBalance = 500;
  final double _interestRate = 0.02;

  SavingsAccount(super._accountNumber, super._accountHolderName, super._balance);

  @override
  void withdraw(double amount) {
    if (numOfWithdraw >= withdrawLimit) {
      print("Withdrawal limit reached!");
      return;
    }
    if (_balance - amount < _minBalance) {
      print("Insufficient balance || Cannot withdraw below minimum balance");
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
      print("Overdraft occurred! Fee of Rs. $_overdraftFee applied");
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

  PremiumAccount(super._accountNumber, super._accountHolderName, super._balance);

  @override
  void withdraw(double amount) {
    if (_balance - amount < _minBalance) {
      print("Insufficient balance || Cannot withdraw below minimum balance");
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

class Bank {
  List<BankAccount> accounts = [];

  void addAccount(BankAccount account) {
    accounts.add(account);
    print("Account for ${account.getAccHolName} created (Acc No: ${account.getAccNum})");
  }

  BankAccount? findAccount(int accountNum) {
    for (var account in accounts) {
      if (account._accountNumber == accountNum) {
        return account;
      }
    }
    print("Account with number $accountNum not found");
    return null;
  }

  void transfer(int senderNum, int receiverNum, double amount) {
    var sender = findAccount(senderNum);
    var receiver = findAccount(receiverNum);

    if (sender == null || receiver == null) {
      print("Transaction invalid: Account(s) not found");
      return;
    }

    sender.withdraw(amount);
    receiver.deposit(amount);

    sender.addTransaction("Transferred Rs. $amount to Acc $receiverNum");
    receiver.addTransaction("Received Rs. $amount from Acc $senderNum");

    print("Transferred Rs. $amount from ${sender.getAccHolName} to ${receiver.getAccHolName}");
  }

  void applyMonthlyInterest() {
    for (var account in accounts) {
      if (account is InterestBearing) {
        double interest = account.calculateInterest();
        account.deposit(interest);
        account.addTransaction("Monthly interest Rs. $interest applied");
        print("Applied Rs. $interest interest to ${account.getAccHolName}");
      }
    }
  }

  void generateReport() {
    print("\n===== Bank Accounts Report =====");
    for (var acc in accounts) {
      acc.displayInfo();
      acc.viewTransactions();
      print("================================\n");
    }
  }
}

void main(List<String> args) {
  Bank bank = Bank();

  var sav = SavingsAccount(1101, "Aayush Sharma", 2500);
  var prem = PremiumAccount(2202, "Kritika Rai", 80000);
  var check = CheckingAccount(3303, "Milan Gurung", 5000);
  var std = StudentAccount(1404, "Sneha Lama", 1500);

  bank.addAccount(sav);
  bank.addAccount(prem);
  bank.addAccount(check);
  bank.addAccount(std);

  sav.deposit(500);
  sav.withdraw(800);
  sav.withdraw(400);

  check.withdraw(5200);

  std.deposit(3000);
  std.withdraw(600);

  prem.withdraw(12000);

  bank.applyMonthlyInterest();

  bank.transfer(1101, 2202, 200);
  bank.transfer(3303, 1404, 500);

  bank.generateReport();
}
