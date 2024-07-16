import '../models/user.dart';
import 'database_service.dart';

class AuthService {
  final DatabaseService _dbService = DatabaseService();

  Future<User?> login(String username, String password) async {
    return await _dbService.getUser(username, password);
  }

  Future<int> register(User user) async {
    return await _dbService.insertUser(user);
  }
}
