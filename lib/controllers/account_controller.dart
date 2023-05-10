import 'package:optairconnect/models/account_model.dart';

import '../db/mock_db.dart';
import '../repositories/account_repository.dart';

class AccountController {
  final AccountRepository _accountRepository = AccountRepository(VirtualDB());

  Future<Account?> getCurrentUser() {
    return _accountRepository.getCurrentUser();
  }

  Future<bool> registerUser(Account account) {
    return _accountRepository.insert(account);
  }

  Future<bool> updateUser(Account account) {
    return _accountRepository.update(account);
  }

  Future<bool> deleteAccount(int id) {
    return _accountRepository.delete(id);
  }
}
