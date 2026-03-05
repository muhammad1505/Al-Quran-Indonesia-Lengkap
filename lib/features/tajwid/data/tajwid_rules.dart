import 'package:flutter/material.dart';
import 'package:quran_app/core/theme/app_colors.dart';

class TajwidRule {
  final String title;
  final String explanation;
  final Color color;
  final List<TajwidExample> examples;

  const TajwidRule({
    required this.title,
    required this.explanation,
    required this.color,
    required this.examples,
  });
}

class TajwidExample {
  final int surahNumber;
  final int ayahNumber;
  final String text;

  const TajwidExample({
    required this.surahNumber,
    required this.ayahNumber,
    required this.text,
  });
}

final List<TajwidRule> tajwidRules = [
  TajwidRule(
    title: 'Izhar Halqi (إظهار حلقي)',
    explanation:
        'Izhar artinya menjelaskan. Hukum ini terjadi ketika Nun sukun (نْ) atau Tanwin bertemu dengan salah satu huruf halaq: ء ه ع ح غ خ.\n\nDibaca jelas tanpa dengung.',
    color: AppColors.tajwidIzhar,
    examples: [
      TajwidExample(surahNumber: 92, ayahNumber: 5, text: 'مَنْ أَعْطَى'),
    ],
  ),
  TajwidRule(
    title: 'Idgham Bighunnah (إدغام بغنة)',
    explanation:
        'Idgham artinya memasukkan. Bighunnah artinya dengan dengung. Terjadi ketika Nun sukun atau Tanwin bertemu huruf: ي ن م و (disingkat "YANMU").\n\nDibaca dengan memasukkan suara nun ke huruf setelahnya disertai dengung.',
    color: AppColors.tajwidIdghamBighunnah,
    examples: [
      TajwidExample(surahNumber: 4, ayahNumber: 123, text: 'مَنْ يَعْمَلْ'),
    ],
  ),
  TajwidRule(
    title: 'Idgham Bilaghunnah (إدغام بلا غنة)',
    explanation:
        'Terjadi ketika Nun sukun atau Tanwin bertemu huruf Lam (ل) atau Ra (ر).\n\nDibaca dengan memasukkan suara nun tanpa dengung.',
    color: AppColors.tajwidIdghamBilaaghunnah,
    examples: [
      TajwidExample(surahNumber: 4, ayahNumber: 40, text: 'مِنْ لَدُنْهُ'),
    ],
  ),
  TajwidRule(
    title: 'Ikhfa\' Haqiqi (إخفاء حقيقي)',
    explanation:
        'Ikhfa artinya menyembunyikan/menyamarkan. Terjadi ketika Nun sukun atau Tanwin bertemu salah satu dari 15 huruf ikhfa.\n\nDibaca samar antara izhar dan idgham dengan dengung 2 harakat.',
    color: AppColors.tajwidIkhfa,
    examples: [
      TajwidExample(surahNumber: 113, ayahNumber: 2, text: 'مِنْ شَرِّ'),
    ],
  ),
  TajwidRule(
    title: 'Iqlab (إقلاب)',
    explanation:
        'Iqlab artinya membalik/mengubah. Terjadi ketika Nun sukun atau Tanwin bertemu huruf Ba (ب).\n\nNun sukun/tanwin berubah pengucapannya menjadi bunyi Mim (م) dengan dengung.',
    color: AppColors.tajwidIqlab,
    examples: [
      TajwidExample(surahNumber: 2, ayahNumber: 27, text: 'مِنْ بَعْدِ'),
    ],
  ),
  TajwidRule(
    title: 'Ikhfa\' Syafawi (إخفاء شفوي)',
    explanation:
        'Terjadi ketika Mim sukun (مْ) bertemu huruf Ba (ب).\n\nDibaca samar/ditahan pada bibir dengan dengung.',
    color: AppColors.tajwidIkhfaSyafawi,
    examples: [
      TajwidExample(surahNumber: 105, ayahNumber: 4, text: 'تَرْمِيهِمْ بِحِجَارَةٍ'),
    ],
  ),
  TajwidRule(
    title: 'Idgham Mimi (إدغام ميمي)',
    explanation:
        'Terjadi ketika Mim sukun (مْ) bertemu huruf Mim (م).\n\nDua mim dilebur menjadi satu dengan dengung.',
    color: AppColors.tajwidIdghamMimi,
    examples: [
      TajwidExample(surahNumber: 16, ayahNumber: 31, text: 'لَهُمْ مَا يَشَاءُونَ'),
    ],
  ),
  TajwidRule(
    title: 'Ghunnah (غنة)',
    explanation:
        'Ghunnah adalah suara dengung yang keluar dari rongga hidung.\n\nTerjadi pada Nun (نّ) atau Mim (مّ) yang bertasydid. Dengung ditahan selama 2 harakat.',
    color: AppColors.tajwidGhunnah,
    examples: [
      TajwidExample(surahNumber: 1, ayahNumber: 6, text: 'إِنَّ'),
    ],
  ),
  TajwidRule(
    title: 'Qalqalah (قلقلة)',
    explanation:
        'Qalqalah artinya memantulkan suara. Huruf qalqalah ada 5: ق ط ب ج د (disingkat "qutbu jadin").\n\nTerjadi ketika huruf tersebut dalam keadaan sukun (mati), baik di tengah maupun di akhir kata (waqaf).',
    color: AppColors.tajwidQalqalah,
    examples: [
      TajwidExample(surahNumber: 112, ayahNumber: 1, text: 'قُلْ هُوَ ٱللَّهُ أَحَدٌ'),
    ],
  ),
  TajwidRule(
    title: 'Mad Thabi\'i (مد طبيعي)',
    explanation:
        'Mad Thabi\'i adalah mad dasar yang panjangnya 2 harakat.\n\nTerjadi ketika ada:\n• Alif setelah fathah\n• Waw sukun setelah dhammah\n• Ya sukun setelah kasrah\n\nTidak ada penyebab tambahan (hamzah atau sukun setelahnya).',
    color: AppColors.tajwidMad,
    examples: [
      TajwidExample(surahNumber: 1, ayahNumber: 1, text: 'بِسْمِ اللَّهِ'),
    ],
  ),
];
