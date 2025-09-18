import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import '../models/student.dart';
import '../models/subject.dart';
import '../models/lesson.dart';
import '../models/progress.dart';
import '../models/quiz.dart';
import '../models/reward.dart';
import '../models/settings.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'student_dashboard.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Students Table
    await db.execute('''
      CREATE TABLE students (
        student_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        grade TEXT NOT NULL,
        streak_days INTEGER DEFAULT 0,
        total_stars INTEGER DEFAULT 0,
        badges_earned INTEGER DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    // Subjects Table
    await db.execute('''
      CREATE TABLE subjects (
        subject_id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject_name TEXT NOT NULL,
        description TEXT NOT NULL,
        total_lessons INTEGER NOT NULL,
        category TEXT NOT NULL,
        icon TEXT NOT NULL,
        color TEXT NOT NULL
      )
    ''');

    // Lessons Table
    await db.execute('''
      CREATE TABLE lessons (
        lesson_id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject_id INTEGER NOT NULL,
        lesson_title TEXT NOT NULL,
        lesson_content TEXT NOT NULL,
        media_url TEXT,
        status TEXT DEFAULT 'upcoming',
        duration_minutes INTEGER NOT NULL,
        lesson_order INTEGER NOT NULL,
        FOREIGN KEY (subject_id) REFERENCES subjects (subject_id) ON DELETE CASCADE
      )
    ''');

    // Progress Table
    await db.execute('''
      CREATE TABLE progress (
        progress_id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_id INTEGER NOT NULL,
        lesson_id INTEGER NOT NULL,
        is_completed INTEGER DEFAULT 0,
        time_spent_minutes INTEGER DEFAULT 0,
        last_accessed TEXT NOT NULL,
        FOREIGN KEY (student_id) REFERENCES students (student_id) ON DELETE CASCADE,
        FOREIGN KEY (lesson_id) REFERENCES lessons (lesson_id) ON DELETE CASCADE,
        UNIQUE(student_id, lesson_id)
      )
    ''');

    // Quizzes Table
    await db.execute('''
      CREATE TABLE quizzes (
        quiz_id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject_id INTEGER NOT NULL,
        quiz_title TEXT NOT NULL,
        total_questions INTEGER NOT NULL,
        FOREIGN KEY (subject_id) REFERENCES subjects (subject_id) ON DELETE CASCADE
      )
    ''');

    // Quiz Questions Table
    await db.execute('''
      CREATE TABLE quiz_questions (
        question_id INTEGER PRIMARY KEY AUTOINCREMENT,
        quiz_id INTEGER NOT NULL,
        question_text TEXT NOT NULL,
        option_a TEXT NOT NULL,
        option_b TEXT NOT NULL,
        option_c TEXT NOT NULL,
        option_d TEXT NOT NULL,
        correct_option TEXT NOT NULL,
        FOREIGN KEY (quiz_id) REFERENCES quizzes (quiz_id) ON DELETE CASCADE
      )
    ''');

    // Quiz Results Table
    await db.execute('''
      CREATE TABLE quiz_results (
        result_id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_id INTEGER NOT NULL,
        quiz_id INTEGER NOT NULL,
        score INTEGER NOT NULL,
        completed_at TEXT NOT NULL,
        FOREIGN KEY (student_id) REFERENCES students (student_id) ON DELETE CASCADE,
        FOREIGN KEY (quiz_id) REFERENCES quizzes (quiz_id) ON DELETE CASCADE
      )
    ''');

    // Rewards Table
    await db.execute('''
      CREATE TABLE rewards (
        reward_id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_id INTEGER NOT NULL,
        reward_type TEXT NOT NULL,
        reward_value INTEGER NOT NULL,
        earned_at TEXT NOT NULL,
        description TEXT,
        FOREIGN KEY (student_id) REFERENCES students (student_id) ON DELETE CASCADE
      )
    ''');

    // Settings Table
    await db.execute('''
      CREATE TABLE settings (
        setting_id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_id INTEGER NOT NULL,
        font_size TEXT DEFAULT 'medium',
        app_language TEXT DEFAULT 'hindi',
        download_enabled INTEGER DEFAULT 0,
        FOREIGN KEY (student_id) REFERENCES students (student_id) ON DELETE CASCADE,
        UNIQUE(student_id)
      )
    ''');
  }

  // Student CRUD Operations
  Future<int> insertStudent(Student student) async {
    final db = await database;
    return await db.insert('students', student.toMap());
  }

  Future<Student?> getStudentByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'students',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return Student.fromMap(maps.first);
    }
    return null;
  }

  Future<Student?> getStudentById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'students',
      where: 'student_id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Student.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateStudent(Student student) async {
    final db = await database;
    return await db.update(
      'students',
      student.toMap(),
      where: 'student_id = ?',
      whereArgs: [student.studentId],
    );
  }

  // Subject CRUD Operations
  Future<int> insertSubject(Subject subject) async {
    final db = await database;
    return await db.insert('subjects', subject.toMap());
  }

  Future<List<Subject>> getAllSubjects() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('subjects');
    return List.generate(maps.length, (i) => Subject.fromMap(maps[i]));
  }

  Future<List<Subject>> getSubjectsByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'subjects',
      where: 'category = ?',
      whereArgs: [category],
    );
    return List.generate(maps.length, (i) => Subject.fromMap(maps[i]));
  }

  // Lesson CRUD Operations
  Future<int> insertLesson(Lesson lesson) async {
    final db = await database;
    return await db.insert('lessons', lesson.toMap());
  }

  Future<List<Lesson>> getLessonsBySubject(int subjectId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'lessons',
      where: 'subject_id = ?',
      whereArgs: [subjectId],
      orderBy: 'lesson_order ASC',
    );
    return List.generate(maps.length, (i) => Lesson.fromMap(maps[i]));
  }

  // Progress CRUD Operations
  Future<int> insertProgress(Progress progress) async {
    final db = await database;
    return await db.insert(
      'progress',
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Progress?> getProgress(int studentId, int lessonId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'progress',
      where: 'student_id = ? AND lesson_id = ?',
      whereArgs: [studentId, lessonId],
    );
    if (maps.isNotEmpty) {
      return Progress.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateProgress(Progress progress) async {
    final db = await database;
    return await db.update(
      'progress',
      progress.toMap(),
      where: 'student_id = ? AND lesson_id = ?',
      whereArgs: [progress.studentId, progress.lessonId],
    );
  }

  Future<List<Progress>> getStudentProgress(int studentId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'progress',
      where: 'student_id = ?',
      whereArgs: [studentId],
    );
    return List.generate(maps.length, (i) => Progress.fromMap(maps[i]));
  }

  // Quiz CRUD Operations
  Future<int> insertQuiz(Quiz quiz) async {
    final db = await database;
    return await db.insert('quizzes', quiz.toMap());
  }

  Future<int> insertQuizQuestion(QuizQuestion question) async {
    final db = await database;
    return await db.insert('quiz_questions', question.toMap());
  }

  Future<List<Quiz>> getQuizzesBySubject(int subjectId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'quizzes',
      where: 'subject_id = ?',
      whereArgs: [subjectId],
    );
    return List.generate(maps.length, (i) => Quiz.fromMap(maps[i]));
  }

  Future<List<QuizQuestion>> getQuizQuestions(int quizId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'quiz_questions',
      where: 'quiz_id = ?',
      whereArgs: [quizId],
    );
    return List.generate(maps.length, (i) => QuizQuestion.fromMap(maps[i]));
  }

  Future<int> insertQuizResult(QuizResult result) async {
    final db = await database;
    return await db.insert('quiz_results', result.toMap());
  }

  // Reward CRUD Operations
  Future<int> insertReward(Reward reward) async {
    final db = await database;
    return await db.insert('rewards', reward.toMap());
  }

  Future<List<Reward>> getStudentRewards(int studentId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'rewards',
      where: 'student_id = ?',
      whereArgs: [studentId],
      orderBy: 'earned_at DESC',
    );
    return List.generate(maps.length, (i) => Reward.fromMap(maps[i]));
  }

  // Settings CRUD Operations
  Future<int> insertSettings(Settings settings) async {
    final db = await database;
    return await db.insert(
      'settings',
      settings.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Settings?> getStudentSettings(int studentId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'settings',
      where: 'student_id = ?',
      whereArgs: [studentId],
    );
    if (maps.isNotEmpty) {
      return Settings.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateSettings(Settings settings) async {
    final db = await database;
    return await db.update(
      'settings',
      settings.toMap(),
      where: 'student_id = ?',
      whereArgs: [settings.studentId],
    );
  }

  // Utility Methods
  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> authenticateStudent(String email, String password) async {
    final student = await getStudentByEmail(email);
    if (student != null) {
      return student.password == hashPassword(password);
    }
    return false;
  }

  // Dashboard Statistics
  Future<Map<String, dynamic>> getDashboardStats(int studentId) async {
    final db = await database;

    try {
      // Get total progress
      final progressResult = await db.rawQuery('''
        SELECT COUNT(*) as total_lessons,
               SUM(CASE WHEN is_completed = 1 THEN 1 ELSE 0 END) as completed_lessons
        FROM progress p
        JOIN lessons l ON p.lesson_id = l.lesson_id
        WHERE p.student_id = ?
      ''', [studentId]);

      // Get streak days
      final student = await getStudentById(studentId);

      // Get total stars
      final starsResult = await db.rawQuery('''
        SELECT COALESCE(SUM(reward_value), 0) as total_stars
        FROM rewards
        WHERE student_id = ? AND reward_type = 'star'
      ''', [studentId]);

      // Get badges earned
      final badgesResult = await db.rawQuery('''
        SELECT COUNT(*) as badges_earned
        FROM rewards
        WHERE student_id = ? AND reward_type = 'badge'
      ''', [studentId]);

      return {
        'totalProgress': progressResult.first['total_lessons'] ?? 0,
        'completedLessons': progressResult.first['completed_lessons'] ?? 0,
        'streakDays': student?.streakDays ?? 0,
        'totalStars': starsResult.first['total_stars'] ?? 0,
        'badgesEarned': badgesResult.first['badges_earned'] ?? 0,
      };
    } catch (e) {
      print('Error getting dashboard stats: $e');
      return {
        'totalProgress': 0,
        'completedLessons': 0,
        'streakDays': 0,
        'totalStars': 0,
        'badgesEarned': 0,
      };
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}