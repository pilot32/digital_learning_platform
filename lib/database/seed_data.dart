import '../models/student.dart';
import '../models/subject.dart';
import '../models/lesson.dart';
import '../models/progress.dart';
import '../models/quiz.dart';
import '../models/reward.dart';
import '../models/settings.dart';
import 'database_helper.dart';

class SeedData {
  static final DatabaseHelper _dbHelper = DatabaseHelper();

  static Future<void> seedDatabase() async {
    try {
      print('Starting database seeding...');

      // Clear existing data
      await _clearDatabase();
      print('Database cleared');

      // Insert Students
      await _insertStudents();
      print('Students inserted');

      // Insert Subjects
      await _insertSubjects();
      print('Subjects inserted');

      // Insert Lessons
      await _insertLessons();
      print('Lessons inserted');

      // Insert Progress
      await _insertProgress();
      print('Progress inserted');

      // Insert Quizzes
      await _insertQuizzes();
      print('Quizzes inserted');

      // Insert Rewards
      await _insertRewards();
      print('Rewards inserted');

      // Insert Settings
      await _insertSettings();
      print('Settings inserted');

      print('Database seeding completed successfully');
    } catch (e) {
      print('Error during database seeding: $e');
      rethrow;
    }
  }

  static Future<void> _clearDatabase() async {
    try {
      final db = await _dbHelper.database;

      // Disable foreign key constraints temporarily
      await db.execute('PRAGMA foreign_keys = OFF');

      // Clear in correct order to avoid foreign key issues
      await db.delete('settings');
      await db.delete('rewards');
      await db.delete('quiz_results');
      await db.delete('quiz_questions');
      await db.delete('quizzes');
      await db.delete('progress');
      await db.delete('lessons');
      await db.delete('subjects');
      await db.delete('students');

      // Re-enable foreign key constraints
      await db.execute('PRAGMA foreign_keys = ON');
    } catch (e) {
      print('Error clearing database: $e');
      rethrow;
    }
  }

  static Future<void> _insertStudents() async {
    try {
      final students = [
        Student(
          name: 'राम कुमार',
          email: 'ram@example.com',
          password: _dbHelper.hashPassword('password123'),
          grade: 'Class 10',
          streakDays: 15,
          totalStars: 127,
          badgesEarned: 5,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        Student(
          name: 'सीता शर्मा',
          email: 'sita@example.com',
          password: _dbHelper.hashPassword('password123'),
          grade: 'Class 9',
          streakDays: 8,
          totalStars: 89,
          badgesEarned: 3,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
        ),
      ];

      for (final student in students) {
        await _dbHelper.insertStudent(student);
      }
    } catch (e) {
      print('Error inserting students: $e');
      rethrow;
    }
  }

  static Future<void> _insertSubjects() async {
    try {
      final subjects = [
        // Main Subjects
        Subject(
          subjectName: 'हिंदी',
          description: 'Hindi Language Learning',
          totalLessons: 20,
          category: 'main',
          icon: 'Icons.menu_book_rounded',
          color: '0xFFFF7043',
        ),
        Subject(
          subjectName: 'अंग्रेज़ी',
          description: 'English Language Learning',
          totalLessons: 18,
          category: 'main',
          icon: 'Icons.language_rounded',
          color: '0xFF42A5F5',
        ),
        Subject(
          subjectName: 'गणित',
          description: 'Mathematics',
          totalLessons: 25,
          category: 'main',
          icon: 'Icons.calculate_rounded',
          color: '0xFF66BB6A',
        ),
        // Advanced Subjects
        Subject(
          subjectName: 'विज्ञान',
          description: 'Science',
          totalLessons: 30,
          category: 'advanced',
          icon: 'Icons.science_rounded',
          color: '0xFFAB47BC',
        ),
        Subject(
          subjectName: 'सामाजिक विज्ञान',
          description: 'Social Science',
          totalLessons: 22,
          category: 'advanced',
          icon: 'Icons.public_rounded',
          color: '0xFFFFB300',
        ),
      ];

      for (final subject in subjects) {
        await _dbHelper.insertSubject(subject);
      }
    } catch (e) {
      print('Error inserting subjects: $e');
      rethrow;
    }
  }

  static Future<void> _insertLessons() async {
    try {
      final lessons = [
        // Hindi Lessons (subjectId: 1)
        Lesson(
          subjectId: 1,
          lessonTitle: 'हिंदी व्याकरण - संज्ञा',
          lessonContent: 'संज्ञा के प्रकार और उपयोग',
          mediaUrl: 'https://example.com/hindi-noun',
          status: 'completed',
          durationMinutes: 30,
          lesson_order: 1,
        ),
        Lesson(
          subjectId: 1,
          lessonTitle: 'हिंदी व्याकरण - सर्वनाम',
          lessonContent: 'सर्वनाम के प्रकार और उपयोग',
          mediaUrl: 'https://example.com/hindi-pronoun',
          status: 'completed',
          durationMinutes: 25,
          lesson_order: 2,
        ),
        Lesson(
          subjectId: 1,
          lessonTitle: 'हिंदी व्याकरण - क्रिया',
          lessonContent: 'क्रिया के प्रकार और उपयोग',
          mediaUrl: 'https://example.com/hindi-verb',
          status: 'in-progress',
          durationMinutes: 35,
          lesson_order: 3,
        ),
        // English Lessons (subjectId: 2)
        Lesson(
          subjectId: 2,
          lessonTitle: 'English Grammar - Nouns',
          lessonContent: 'Types and usage of nouns',
          mediaUrl: 'https://example.com/english-noun',
          status: 'completed',
          durationMinutes: 28,
          lesson_order: 1,
        ),
        Lesson(
          subjectId: 2,
          lessonTitle: 'English Grammar - Verbs',
          lessonContent: 'Types and usage of verbs',
          mediaUrl: 'https://example.com/english-verb',
          status: 'in-progress',
          durationMinutes: 32,
          lesson_order: 2,
        ),
        // Math Lessons (subjectId: 3)
        Lesson(
          subjectId: 3,
          lessonTitle: 'बीजगणित - समीकरण',
          lessonContent: 'रैखिक समीकरणों का हल',
          mediaUrl: 'https://example.com/math-algebra',
          status: 'upcoming',
          durationMinutes: 40,
          lesson_order: 1,
        ),
      ];

      for (final lesson in lessons) {
        await _dbHelper.insertLesson(lesson);
      }
    } catch (e) {
      print('Error inserting lessons: $e');
      rethrow;
    }
  }

  static Future<void> _insertProgress() async {
    try {
      final progress = [
        // Ram's progress (studentId: 1)
        Progress(
          studentId: 1,
          lessonId: 1,
          isCompleted: true,
          timeSpentMinutes: 30,
          lastAccessed: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Progress(
          studentId: 1,
          lessonId: 2,
          isCompleted: true,
          timeSpentMinutes: 25,
          lastAccessed: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Progress(
          studentId: 1,
          lessonId: 3,
          isCompleted: false,
          timeSpentMinutes: 15,
          lastAccessed: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Progress(
          studentId: 1,
          lessonId: 4,
          isCompleted: true,
          timeSpentMinutes: 28,
          lastAccessed: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Progress(
          studentId: 1,
          lessonId: 5,
          isCompleted: false,
          timeSpentMinutes: 10,
          lastAccessed: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        // Sita's progress (studentId: 2)
        Progress(
          studentId: 2,
          lessonId: 1,
          isCompleted: true,
          timeSpentMinutes: 30,
          lastAccessed: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Progress(
          studentId: 2,
          lessonId: 4,
          isCompleted: false,
          timeSpentMinutes: 20,
          lastAccessed: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];

      for (final prog in progress) {
        await _dbHelper.insertProgress(prog);
      }
    } catch (e) {
      print('Error inserting progress: $e');
      rethrow;
    }
  }

  static Future<void> _insertQuizzes() async {
    try {
      // Insert Quiz for Hindi subject (subjectId: 1)
      final quizId = await _dbHelper.insertQuiz(Quiz(
        subjectId: 1,
        quizTitle: 'हिंदी व्याकरण क्विज़',
        totalQuestions: 2,
      ));

      // Insert Quiz Questions
      final questions = [
        QuizQuestion(
          quizId: quizId,
          questionText: 'संज्ञा किसे कहते हैं?',
          optionA: 'क्रिया को',
          optionB: 'वस्तु के नाम को',
          optionC: 'विशेषण को',
          optionD: 'क्रिया विशेषण को',
          correctOption: 'B',
        ),
        QuizQuestion(
          quizId: quizId,
          questionText: 'सर्वनाम कितने प्रकार के होते हैं?',
          optionA: '5',
          optionB: '6',
          optionC: '7',
          optionD: '8',
          correctOption: 'B',
        ),
      ];

      for (final question in questions) {
        await _dbHelper.insertQuizQuestion(question);
      }
    } catch (e) {
      print('Error inserting quizzes: $e');
      rethrow;
    }
  }

  static Future<void> _insertRewards() async {
    try {
      final rewards = [
        // Ram's rewards (studentId: 1)
        Reward(
          studentId: 1,
          rewardType: 'star',
          rewardValue: 50,
          earnedAt: DateTime.now().subtract(const Duration(days: 1)),
          description: 'पहला पाठ पूरा करने के लिए',
        ),
        Reward(
          studentId: 1,
          rewardType: 'star',
          rewardValue: 77,
          earnedAt: DateTime.now().subtract(const Duration(days: 2)),
          description: 'दूसरा पाठ पूरा करने के लिए',
        ),
        Reward(
          studentId: 1,
          rewardType: 'badge',
          rewardValue: 1,
          earnedAt: DateTime.now().subtract(const Duration(days: 3)),
          description: 'पहला बैज',
        ),
        Reward(
          studentId: 1,
          rewardType: 'streak',
          rewardValue: 15,
          earnedAt: DateTime.now().subtract(const Duration(days: 1)),
          description: '15 दिन की लकीर',
        ),
        // Sita's rewards (studentId: 2)
        Reward(
          studentId: 2,
          rewardType: 'star',
          rewardValue: 30,
          earnedAt: DateTime.now().subtract(const Duration(days: 2)),
          description: 'पहला पाठ पूरा करने के लिए',
        ),
        Reward(
          studentId: 2,
          rewardType: 'star',
          rewardValue: 59,
          earnedAt: DateTime.now().subtract(const Duration(days: 3)),
          description: 'अभ्यास पूरा करने के लिए',
        ),
        Reward(
          studentId: 2,
          rewardType: 'badge',
          rewardValue: 1,
          earnedAt: DateTime.now().subtract(const Duration(days: 4)),
          description: 'पहला बैज',
        ),
      ];

      for (final reward in rewards) {
        await _dbHelper.insertReward(reward);
      }
    } catch (e) {
      print('Error inserting rewards: $e');
      rethrow;
    }
  }

  static Future<void> _insertSettings() async {
    try {
      final settings = [
        Settings(
          studentId: 1,
          fontSize: 'medium',
          appLanguage: 'hindi',
          downloadEnabled: true,
        ),
        Settings(
          studentId: 2,
          fontSize: 'large',
          appLanguage: 'hindi',
          downloadEnabled: false,
        ),
      ];

      for (final setting in settings) {
        await _dbHelper.insertSettings(setting);
      }
    } catch (e) {
      print('Error inserting settings: $e');
      rethrow;
    }
  }
}