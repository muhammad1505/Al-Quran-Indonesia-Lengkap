import 'package:quran_app/features/tajwid/domain/entities/tajweed_rule.dart';
import 'package:quran_app/features/tajwid/domain/entities/tajweed_token.dart';

const meem = 'م';
const noon = 'ن';
const waw = 'و';
const yaa = 'ي';
const laam = 'ل';
const raa = 'ر';
const baa = 'ب';
const jeem = 'ج';
const daal = 'د';
const qaaf = 'ق';
const qaa = 'ط';
const aleph = 'ا';
const hamza = 'ء';
const ayn = 'ع';
const ghayn = 'غ';
const haa = 'ه';
const khaa = 'خ';
const haaa = 'ح';
const sheen = 'ش';
const seen = 'س';
const zaa = 'ز';
const faa = 'ف';
const taa = 'ت';
const dhaa = 'ض';
const dhal = 'ذ';
const kaaf = 'ك';
const thaal = 'ث';
const saad = 'ص';
const dhal2 = 'ظ';

const shadda = 'ّ';
const sukuun = 'ْ';
const madda = 'ٓ';
const alephKhanjareeya = 'ٰ';

const fathatan = 'ً';
const dammatan = 'ٌ';
const kasratan = 'ٍ';

const fatha = 'َ';
const damma = 'ُ';
const kasra = 'ِ';

const harakaat = [fatha, damma, kasra];
const tanween = [fathatan, dammatan, kasratan];
const harakaatAndTanween = [...harakaat, ...tanween];

const aChar = 'A';
const noonSakinahChars = [noon, ...tanween];
const meemSakinahChars = [meem];
const laamSakinahChars = [laam];

const quranText =
    "ْ ٰ َّ ً ُّ ٌ ٍّ ِ ٍ ْ ّ َ ُ ِ ً ّ ٌ ٍ َ ُ ِ ْ ّ ً ٌ ٍ َ ُ ِ ْ ّ ً ٌ ٍ ء آ أ ؤ إ ئ ا ب ت ث ج ح خ د ذ ر ز س ش ص ض ط ظ ع غ ف ق ك ل م ن ه و ي";
const allQuranChars =
    "ء آ أ ؤ إ ئ ا ب ت ث ج ح خ د ذ ر ز س ش ص ض ط ظ ع غ ف ق ك ل م ن ه و ي ْ ّٰ َّ ً ُّ ٌ ٍّ ِ ٍ ْ ّ َ ُ ِ ً ّ ٌ ٍ َ ُ ِ ْ ّ ً ٌ ٍ َ ُ ِ ْ ّ ً ٌ ٍ";

const allChars = [
  "ء",
  "آ",
  "أ",
  "ؤ",
  "إ",
  "ئ",
  "ا",
  "ب",
  "ة",
  "ت",
  "ث",
  "ج",
  "ح",
  "خ",
  "د",
  "ذ",
  "ر",
  "ز",
  "س",
  "ش",
  "ص",
  "ض",
  "ط",
  "ظ",
  "ع",
  "غ",
  "ف",
  "ق",
  "ك",
  "ل",
  "م",
  "ن",
  "ه",
  "و",
  "ى",
  "ي"
];
const harakat = ["َ", "ً", "ُ", "ٌ", "ِ", "ٍ", "ْ", "ّ", "ٰ", "ٓ"];

final rules = [
  TajweedRule(
      "Ghunnah",
      "Ghunnah adalah suara dengung yang keluar dari pangkal hidung. Ini merupakan sifat dari huruf ن (Nun) dan م (Mim) bertasydid. Suara ditahan selama 2 harakat.",
      [
        TajweedSubrule(
            "Ghunnah",
            "Suara dengung yang ditahan selama 2 harakat pada huruf ن dan م bertasydid.",
            TajweedRuleType.ghunna,
            RegExp('($noon$shadda|$meem$shadda)'))
      ],
      1),
  TajweedRule(
      "Qalqalah",
      "Qalqalah adalah bunyi pantulan atau getaran yang terjadi ketika salah satu dari lima huruf Qalqalah dalam keadaan sukun (mati). Lima huruf Qalqalah tersebut adalah ق, ط, ب, ج, د.",
      [
        TajweedSubrule(
            "Qalqalah",
            "Bunyi pantulan pada salah satu dari lima huruf Qalqalah jika berharakat sukun.",
            TajweedRuleType.qalqala,
            RegExp('([$qaaf$qaa$baa$jeem$daal]$sukuun)'))
      ],
      2),
  TajweedRule(
      "Nun Sukun dan Tanwin",
      "Hukum Nun Sukun dan Tanwin berlaku ketika huruf Nun bersukun atau tanwin bertemu dengan huruf Hijaiyah tertentu.",
      [
        TajweedSubrule(
            "Ikhfa'",
            "Menyamarkan bunyi 'n' dari Nun Sukun atau Tanwin menjadi dengung (ghunnah) saat bertemu salah satu dari 15 huruf Ikhfa'.",
            TajweedRuleType.ikhfaa,
            RegExp(
                '([$noon]$sukuun|[$fathatan$dammatan$kasratan])\\s*([$saad$dhal$thaal$kaaf$jeem$sheen$qaaf$seen$daal$qaa$zaa$faa$taa$dhaa$dhal2])')),
        TajweedSubrule(
            "Izhar",
            "Membaca bunyi 'n' dari Nun Sukun atau Tanwin secara jelas tanpa dengung saat bertemu huruf Halqi (tenggorokan).",
            TajweedRuleType.izhar,
            RegExp(
                '([$noon]$sukuun|[$fathatan$dammatan$kasratan])\\s*([$hamza$haa$ayn$haaa$ghayn$khaa])')),
        TajweedSubrule(
            "Idgham Bighunnah",
            "Memasukkan bunyi Nun Sukun atau Tanwin ke huruf berikutnya disertai dengan dengungan.",
            TajweedRuleType.idgham,
            RegExp(
                '([$noon]$sukuun|[$fathatan$dammatan$kasratan])\\s*([$noon$meem$waw$yaa])')),
        TajweedSubrule(
            "Idgham Bilaghunnah",
            "Memasukkan bunyi Nun Sukun atau Tanwin ke huruf berikutnya secara jelas tanpa dengungan.",
            TajweedRuleType.idgham,
            RegExp(
                '([$noon]$sukuun|[$fathatan$dammatan$kasratan])\\s*([$laam$raa])')),
        TajweedSubrule(
            "Iqlab",
            "Mengganti bunyi 'n' dari Nun Sukun atau Tanwin menjadi bunyi 'm' yang didengungkan saat bertemu huruf Ba (ب).",
            TajweedRuleType.iqlab,
            RegExp(
                '([$noon]$sukuun|[$fathatan$dammatan$kasratan])\\s*([$baa])')),
      ],
      3),
  TajweedRule(
      "Mim Sukun",
      "Hukum Mim Sukun berlaku ketika huruf Mim bersukun bertemu dengan huruf Hijaiyah tertentu.",
      [
        TajweedSubrule(
            "Ikhfa' Syafawi",
            "Menyamarkan bunyi 'm' dari Mim Sukun didengungkan saat bertemu huruf Ba (ب).",
            TajweedRuleType.ikhfaa,
            RegExp('($meem$sukuun)\\s*($baa)')),
        TajweedSubrule(
            "Idgham Mutamatsilain (Syafawi)",
            "Memasukkan Mim Sukun ke dalam huruf Mim setelahnya disertai dengan dengungan.",
            TajweedRuleType.idgham,
            RegExp('($meem$sukuun)\\s*($meem)')),
        TajweedSubrule(
            "Izhar Syafawi",
            "Membaca bunyi 'm' dari Mim Sukun secara jelas tanpa dengung saat bertemu huruf selain Mim dan Ba.",
            TajweedRuleType.izhar,
            RegExp('($meem$sukuun)\\s*([$aChar-$meem])')),
      ],
      4),
  TajweedRule(
      "Mad", "Pemanjangan bunyi vokal pendek menjadi vokal panjang dalam bahasa Arab.", [], 5)
];

List<TajweedToken> tokenize(String text) {
  final tokens = <TajweedToken>[];
  for (final rule in rules) {
    for (final subrule in rule.subrules) {
      final matches = subrule.regex.allMatches(text);
      for (final match in matches) {
        tokens.add(TajweedToken(match.start, match.end, rule, subrule));
      }
    }
  }
  return tokens;
}
