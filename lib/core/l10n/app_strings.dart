import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/locale_provider.dart';

/// Hand-written bilingual (English / Arabic) UI strings. Chosen over ARB
/// codegen so the app never depends on a `flutter gen-l10n` build step.
class L10n {
  final bool ar;
  const L10n(this.ar);

  String pick(String en, String arText) => ar ? arText : en;

  // App / navigation
  String get appName => ar ? 'مدرّبي' : 'My Coach';
  String get navHome => ar ? 'الرئيسية' : 'Home';
  String get navProgramme => ar ? 'البرنامج' : 'Programme';
  String get navLibrary => ar ? 'التمارين' : 'Library';
  String get navProgress => ar ? 'التقدّم' : 'Progress';
  String get navCalendar => ar ? 'التقويم' : 'Calendar';

  // Common
  String get error => ar ? 'خطأ' : 'Error';
  String get retry => ar ? 'إعادة المحاولة' : 'Retry';
  String get goHome => ar ? 'العودة للرئيسية' : 'Go home';
  String get search => ar ? 'بحث' : 'Search';
  String get all => ar ? 'الكل' : 'All';
  String get close => ar ? 'إغلاق' : 'Close';

  // Exercise detail
  String get exercises => ar ? 'التمارين' : 'Exercises';
  String get exerciseNotFound => ar ? 'التمرين غير موجود.' : 'Exercise not found.';
  String get howToPerform => ar ? 'طريقة الأداء' : 'How to Perform';
  String get commonMistakes => ar ? 'الأخطاء الشائعة' : 'Common Mistakes';
  String get breathing => ar ? 'التنفّس' : 'Breathing';
  String get safetyNote => ar ? 'ملاحظة أمان' : 'Safety Note';
  String get equipment => ar ? 'المعدات' : 'Equipment';
  String get watchOnYoutube => ar ? 'شاهد على يوتيوب' : 'Watch on YouTube';

  String get substitute => ar ? 'بديل مفضّل' : 'Substitute';

  String categoryName(String key) {
    switch (key) {
      case 'lower_quad':
        return ar ? 'الأرجل — الفخذ الأمامي' : 'Legs — Quads';
      case 'posterior':
        return ar ? 'الأرجل — السلسلة الخلفية' : 'Legs — Posterior Chain';
      case 'push_horizontal':
        return ar ? 'دفع — أفقي' : 'Push — Horizontal';
      case 'push_vertical':
        return ar ? 'دفع — عمودي' : 'Push — Vertical';
      case 'pull_horizontal':
        return ar ? 'سحب — أفقي' : 'Pull — Horizontal';
      case 'pull_vertical':
        return ar ? 'سحب — عمودي' : 'Pull — Vertical';
      case 'arms':
        return ar ? 'الذراعان' : 'Arms';
      case 'core':
        return ar ? 'الجذع' : 'Core';
      case 'calves':
        return ar ? 'السمانة' : 'Calves';
      default:
        return key;
    }
  }

  // Difficulty
  String difficulty(String value) {
    switch (value) {
      case 'beginner':
        return ar ? 'مبتدئ' : 'Beginner';
      case 'advanced':
        return ar ? 'متقدّم' : 'Advanced';
      case 'intermediate':
      default:
        return ar ? 'متوسّط' : 'Intermediate';
    }
  }

  // Programme
  String get programme => ar ? 'البرنامج' : 'Programme';
  String get week => ar ? 'الأسبوع' : 'Week';
  String get block => ar ? 'المرحلة' : 'Block';
  String weekLabel(int n) => ar ? 'الأسبوع $n' : 'Week $n';

  String sessionLabel(String type) {
    switch (type) {
      case 'upper':
        return ar ? 'الجزء العلوي' : 'Upper Body';
      case 'lower':
        return ar ? 'الجزء السفلي' : 'Lower Body';
      case 'push':
        return ar ? 'الدفع' : 'Push';
      case 'pull':
        return ar ? 'السحب' : 'Pull';
      case 'legs':
        return ar ? 'الأرجل' : 'Legs';
      default:
        return type;
    }
  }

  String blockName(int number) {
    switch (number) {
      case 1:
        return ar ? 'التراكم' : 'Accumulation';
      case 2:
        return ar ? 'الشدّة' : 'Intensity';
      case 3:
        return ar ? 'ذروة القوة' : 'Peak Strength';
      case 4:
        return ar ? 'التخفيف' : 'Deload';
      default:
        return '';
    }
  }

  String weekday(String key) {
    switch (key) {
      case 'monday':
        return ar ? 'الإثنين' : 'Monday';
      case 'tuesday':
        return ar ? 'الثلاثاء' : 'Tuesday';
      case 'wednesday':
        return ar ? 'الأربعاء' : 'Wednesday';
      case 'thursday':
        return ar ? 'الخميس' : 'Thursday';
      case 'friday':
        return ar ? 'الجمعة' : 'Friday';
      case 'saturday':
        return ar ? 'السبت' : 'Saturday';
      case 'sunday':
        return ar ? 'الأحد' : 'Sunday';
      default:
        return key;
    }
  }

  // Settings
  String get settings => ar ? 'الإعدادات' : 'Settings';
  String get language => ar ? 'اللغة' : 'Language';
  String get arabic => 'العربية';
  String get english => 'English';
  String get unit => ar ? 'وحدة الوزن' : 'Weight Unit';
  String get kilograms => ar ? 'كيلوجرام (kg)' : 'Kilograms (kg)';
  String get pounds => ar ? 'رطل (lbs)' : 'Pounds (lbs)';
  String get theme => ar ? 'المظهر' : 'Theme';
  String get themeDark => ar ? 'داكن' : 'Dark';
}

final l10nProvider = Provider<L10n>((ref) => L10n(ref.watch(isArabicProvider)));
