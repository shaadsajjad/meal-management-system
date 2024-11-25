import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database!;
  }



  // Initialize the database
  Future<Database> initDb() async {
    return await openDatabase(
      join(await getDatabasesPath(), "multi_table_database.db"),
      onCreate: (db, version) async {
        // Create all necessary tables
        await db.execute('''
          CREATE TABLE IF NOT EXISTS admin_info (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            pass TEXT NOT NULL,
            conPass TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL,
            number TEXT NOT NULL,
            pass TEXT NOT NULL,
            conPass TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS menuList (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            type TEXT NOT NULL,
            menu TEXT NOT NULL
          )
        ''');
        await db.execute('''
  CREATE TABLE IF NOT EXISTS user_contributions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_email TEXT NOT NULL,
    amount REAL NOT NULL,
    date TEXT NOT NULL,
    description TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id)
  )
''');
        await db.execute(''' 
  CREATE TABLE IF NOT EXISTS meal_orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    meal_type TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    order_date TEXT NOT NULL
  )
''');
        await db.execute(''' 
          CREATE TABLE bazaar (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            price REAL
          ) 
        ''');
        await db.execute(''' 
         CREATE TABLE IF NOT EXISTS bazaar_expenses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  amount REAL NOT NULL,
  date TEXT NOT NULL,
  description TEXT,
  FOREIGN KEY (user_id) REFERENCES users(id)
)
        ''');
      },
      version: 1,
    );
  }
  Future<List<Map<String, dynamic>>> fetchAllBazaarItems() async {
    final db = await database;
    return await db.query('bazaar'); // Assuming 'bazaar' is the table name
  }

  // Add method to insert Bazaar item into DB
  Future<void> insertBazaarItem(String name, String price) async {
    final db = await database;
    await db.rawInsert("INSERT INTO bazaar(name, price) VALUES (?,?)",
      [name, price],
    );
  }
  // Insert admin
  Future<void> insertAdmin(
      String name, String email, String pass, String conPass) async {
    try {
      final db = await database;
      await db.rawInsert(
        "INSERT INTO admin_info(name, email, pass, conPass) VALUES (?, ?, ?, ?)",
        [name, email, pass, conPass],
      );
      print("Admin inserted successfully.");
    } catch (e) {
      print("Error inserting admin: $e");
    }
  }

  // Insert user
  Future<void> insertUser(
      String name, String email, String number, String pass, String conPass) async {
    try {
      final db = await database;
      await db.rawInsert(
        "INSERT INTO users(name, email, number, pass, conPass) VALUES (?, ?, ?, ?, ?)",
        [name, email, number, pass, conPass],
      );
      print("User inserted successfully.");
    } catch (e) {
      print("Error inserting user: $e");
    }
  }

  // Insert menu
  Future<void> insertMenu(String date, String type, String menu) async {
    try {
      final db = await database;
      await db.rawInsert(
        "INSERT INTO menuList(date, type, menu) VALUES (?, ?, ?)",
        [date, type, menu],
      );
      print("Menu inserted successfully.");
    } catch (e) {
      print("Error inserting menu: $e");
    }
  }

  // Fetch all admins
  Future<List<Map<String, dynamic>>> fetchAdmins() async {
    try {
      final db = await database;
      return await db.rawQuery("SELECT * FROM admin_info");
    } catch (e) {
      print("Error fetching admins: $e");
      return [];
    }
  }

  // Fetch all users
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      final db = await database;
      return await db.rawQuery("SELECT * FROM users");
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

  // Fetch all menu entries
  Future<List<Map<String, dynamic>>> fetchMenus() async {
    try {
      final db = await database;
      return await db.rawQuery("SELECT * FROM menuList");
    } catch (e) {
      print("Error fetching menus: $e");
      return [];
    }
  }

  // Delete admin by ID
  Future<void> deleteAdmin(int id) async {
    try {
      final db = await database;
      final result =
      await db.rawDelete("DELETE FROM admin_info WHERE id = ?", [id]);
      if (result == 0) {
        print("No admin found with id: $id");
      } else {
        print("Admin deleted successfully.");
      }
    } catch (e) {
      print("Error deleting admin: $e");
    }
  }

  // Delete user by ID
  Future<void> deleteUser(int id) async {
    try {
      final db = await database;
      final result = await db.rawDelete("DELETE FROM users WHERE id = ?", [id]);
      if (result == 0) {
        print("No user found with id: $id");
      } else {
        print("User deleted successfully.");
      }
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  // Delete menu by ID
  Future<void> deleteMenu(int id) async {
    try {
      final db = await database;
      final result =
      await db.rawDelete("DELETE FROM menuList WHERE id = ?", [id]);
      if (result == 0) {
        print("No menu found with id: $id");
      } else {
        print("Menu deleted successfully.");
      }
    } catch (e) {
      print("Error deleting menu: $e");
    }
  }
  Future<Map<String, dynamic>?> adminLoginCheck(String email, String pass) async {
    try {
      final db = await database;
      final result = await db.rawQuery(
        "SELECT * FROM admin_info WHERE email = ? AND pass = ?",
        [email, pass],
      );
      if (result.isNotEmpty) {
        return result.first; // Returns the admin details if login is successful
      } else {
        return null; // Returns null if no match is found
      }
    } catch (e) {
      print("Error during admin login check: $e");
      return null;
    }
  }

  // User Login Check
  Future<Map<String, dynamic>?> userLoginCheck(String email, String pass) async {
    if (email.isEmpty || pass.isEmpty) {
      print("Error: Email or password cannot be empty.");
      return null;
    }

    try {
      final db = await database;
      // Query to fetch user details based on email and password
      final result = await db.query(
        'users', // Table name
        where: 'email = ? AND pass = ?', // Conditions
        whereArgs: [email, pass], // Arguments for the conditions
      );

      // If a user is found, return the first record
      if (result.isNotEmpty) {
        return result.first; // Return the first record if found
      } else {
        print("Login failed: No user found with the provided email and password.");
        return null; // Return null if no matching user found
      }
    } catch (e) {
      print("Error during user login check: $e");
      return null;
    }
  }


  Future<String?> getAdminNameByEmail(String email) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> results = await db.query(
        'admin_info',
        columns: ['name'], // Select only the 'name' column
        where: 'email = ?',
        whereArgs: [email],
      );

      // If a result is found, return the name; otherwise, return null.
      return results.isNotEmpty ? results.first['name'] as String : null;
    } catch (e) {
      print("Error fetching admin name: $e");
      return null;
    }
  }

  // Get User Name by Email
  Future<String?> getUserNameByEmail(String email) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> results = await db.query(
        'users',
        columns: ['name'], // Select only the 'name' column
        where: 'email = ?',
        whereArgs: [email],
      );

      // If a result is found, return the name; otherwise, return null.
      return results.isNotEmpty ? results.first['name'] as String : null;
    } catch (e) {
      print("Error fetching user name: $e");
      return null;
    }
  }
  // Example of insertMealOrder method in DbHelper
  Future<void> insertMealOrder(int userId, String mealType, int quantity, String date) async {
    final db = await database;  // Get the database
    await db.insert(
      'meal_orders',  // The name of the table in your database
      {
        'user_id': userId,
        'meal_type': mealType,
        'quantity': quantity,
        'order_date': date,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,  // If the record exists, it replaces it
    );
    print('Order inserted successfully!');
  }

  // Fetch scheduled meals for a user
  Future<List<Map<String, dynamic>>> fetchScheduledMeals(int userId) async {
    try {
      final db = await database;
      return await db.rawQuery(
        "SELECT * FROM meal_orders WHERE user_id = ? AND status = 'ordered'",
        [userId],
      );
    } catch (e) {
      print("Error fetching scheduled meals: $e");
      return [];
    }
  }
  // Cancel a meal order if it's more than 1 week away
  Future<void> cancelMealOrder(int orderId, String orderDate) async {
    try {
      DateTime orderDateTime = DateTime.parse(orderDate);
      DateTime currentDate = DateTime.now();

      // Check if the order is at least 1 week away from the current date
      if (orderDateTime.isAfter(currentDate.add(Duration(days: 7)))) {
        final db = await database;
        await db.rawUpdate(
          "UPDATE meal_orders SET status = 'cancelled' WHERE id = ?",
          [orderId],
        );
        print("Meal order cancelled successfully.");
      } else {
        print("Cannot cancel the meal order less than 7 days in advance.");
      }
    } catch (e) {
      print("Error canceling meal order: $e");
    }
  }

// Insert bazaar expense
  Future<void> insertBazaarExpense(int userId, double amount, String date, String description) async {
    try {
      final db = await database;
      await db.rawInsert(
        "INSERT INTO bazaar_expenses(user_id, amount, date, description) VALUES (?, ?, ?, ?)",
        [userId, amount, date, description],
      );
      print("Bazaar expense inserted successfully.");
    } catch (e) {
      print("Error inserting bazaar expense: $e");
    }
  }
  // Fetch all bazaar expenses for a user
  Future<List<Map<String, dynamic>>> fetchBazaarExpenses(int userId) async {
    try {
      final db = await database;
      return await db.rawQuery(
        "SELECT * FROM bazaar_expenses WHERE user_id = ?",
        [userId],
      );
    } catch (e) {
      print("Error fetching bazaar expenses: $e");
      return [];
    }
  }

  // Delete meal by ID
  Future<void> deleteMeal(int mealId) async {
    try {
      final db = await database;
      await db.rawDelete(
        "DELETE FROM scheduled_meals WHERE id = ?",
        [mealId],
      );
      print("Meal deleted successfully.");
    } catch (e) {
      print("Error deleting meal: $e");
    }
  }
  // Fetch scheduled meals by date
  Future<List<Map<String, dynamic>>> fetchScheduledMealsByDate(String date) async {
    try {
      final db = await database;

      // Trim the date to remove any spaces
      String trimmedDate = date.trim();

      // Query the database using the trimmed date
      final result = await db.rawQuery(
        "SELECT * FROM menuList WHERE date = ?",
        [trimmedDate],  // Use the trimmed date here
      );

      print('Fetched meals: $result');  // Debugging the results

      return result;
    } catch (e) {
      print("Error fetching scheduled meals by date: $e");
      return [];
    }
  }



  Future<void> insertUserContribution(
      String userEmail, double amount, String date, String description) async {
    try {
      final db = await database;
      await db.rawInsert(
        "INSERT INTO user_contributions(user_email, amount, date, description) VALUES (?, ?, ?, ?)",
        [userEmail, amount, date, description],
      );
      print("Contribution added successfully.");
    } catch (e) {
      print("Error adding contribution: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserContributions(int userId) async {
    try {
      final db = await database;
      return await db.rawQuery(
        "SELECT * FROM user_contributions WHERE user_id = ?",
        [userId],
      );
    } catch (e) {
      print("Error fetching contributions: $e");
      return [];
    }
  }
  Future<List<Map<String, dynamic>>> fetchAllTransactions() async {
    try {
      final db = await database;
      return await db.rawQuery("SELECT * FROM user_contributions");
    } catch (e) {
      print("Error fetching transactions: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllOrders() async {
    final db = await database;
    final List<Map<String, dynamic>> orders = await db.query('orders'); // Fetch all orders from the 'orders' table
    print("Fetched orders: $orders");
    return orders;
  }










}
