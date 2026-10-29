import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'themes/app_themes.dart'; // For color themes

enum AgeRange { month1, months2to3, months4to6, months7to12 }

enum TileCategory {
  mindMoodEnergy('Mind, Mood, & Energy'),
  yourRecovery('Your recovery'),
  feedingNourishment('Feeding & Nourishment'),
  babyBasics('Baby Basics'),
  moveStrength('Move & Strength'),
  sleepRest('Sleep, Rest & Repeat');

  final String title;
  const TileCategory(this.title);
}

class GrowthTrackerScreen extends StatefulWidget {
  final AppTheme theme;

  /// The date entered on the setup screen (due date / birth date).
  final DateTime babyBirthday;

  const GrowthTrackerScreen({
    super.key,
    required this.theme,
    required this.babyBirthday,
  });

  @override
  State<GrowthTrackerScreen> createState() => _GrowthTrackerScreenState();
}

class _GrowthTrackerScreenState extends State<GrowthTrackerScreen> {

  // CONTENT: one entry per age range, one per tile.
  // Sources: 
  //        American College of Obstetricians and Gynechologists
  //        Centers for Disease Control and Prevention
  //        American Academy of Pediatrics (AAP)
  //        Postpartum Support International (PSI)

  static const Map<AgeRange, Map<TileCategory, String>> _content = {
    AgeRange.month1: {
      TileCategory.mindMoodEnergy:
          "The first weeks after birth can bring big emotional changes. "
          "You may feel tearful, irritable, anxious, or overwhelmed. "
          "These feelings are often called the \"baby blues\" and usually "
          "improve within about two weeks.\n\n"
          "If sadness, anxiety, or hopelessness feels intense, interferes "
          "with daily life, or does not begin to ease, contact a healthcare "
          "professional. Postpartum depression and anxiety are treatable, "
          "and you do not have to manage them alone.\n\n"
          "Ask your doctor, midwife, or your baby's pediatrician about "
          "support. If you have thoughts of harming yourself or your baby, "
          "seek immediate professional help.\n\n"
          "Sources: ACOG — https://www.acog.org/womens-health/faqs/"
          "postpartum-depression ; CDC — https://www.cdc.gov/"
          "reproductive-health/depression/",

      TileCategory.yourRecovery:
          "Your body is still healing after childbirth. Vaginal bleeding, "
          "cramping, breast changes, soreness, and fatigue can occur during "
          "recovery, but your experience will depend on your birth and "
          "individual health.\n\n"
          "Rest when possible, follow your discharge instructions, and "
          "attend your postpartum appointments. Contact your healthcare "
          "professional if pain is worsening, a wound looks infected, "
          "bleeding concerns you, or you have trouble urinating.\n\n"
          "Seek urgent medical attention for chest pain, difficulty "
          "breathing, severe headache, fainting, heavy bleeding, or "
          "one-sided leg swelling or pain. Do not dismiss severe symptoms "
          "as ordinary postpartum recovery.\n\n"
          "Source: ACOG — https://www.acog.org/womens-health/health-tools/"
          "my-postpartum-care-checklist",

      TileCategory.feedingNourishment:
          "Feeding a newborn takes practice, whether you breastfeed, "
          "express milk, use infant formula, or combine methods. Newborns "
          "often feed frequently, and feeding patterns can vary from one "
          "baby to another.\n\n"
          "Eat regular meals when you can and keep water nearby, especially "
          "during feeds. Easy options such as oatmeal, eggs, yogurt, fruit, "
          "soups, and prepared meals can make eating easier when time is "
          "limited.\n\n"
          "If feeding hurts, your baby struggles to latch, or you are "
          "worried about milk supply, wet diapers, or weight gain, ask "
          "your baby's healthcare professional or a lactation consultant "
          "for individualized guidance. Your baby's nutrition matters "
          "more than meeting a particular feeding ideal.\n\n"
          "Sources: CDC — https://www.cdc.gov/infant-toddler-nutrition/"
          "breastfeeding/how-much-and-how-often.html ; "
          "https://www.cdc.gov/infant-toddler-nutrition/formula-feeding/"
          "how-much-and-how-often.html",

      TileCategory.babyBasics:
          "In the first month, your baby is learning how to feed, sleep, "
          "and respond to the world. Hold your baby securely, speak softly, "
          "and watch for hunger cues such as rooting, bringing hands to "
          "the mouth, or smacking the lips.\n\n"
          "For every sleep, place your baby on their back on a firm, flat "
          "sleep surface. Keep pillows, blankets, toys, and other soft "
          "items out of the sleep space. Room-sharing without bed-sharing "
          "is recommended.\n\n"
          "Never shake a baby. If crying becomes overwhelming, place your "
          "baby safely in the crib and step away briefly while you calm "
          "down. Contact your pediatrician about feeding, jaundice, "
          "temperature, or other health concerns. A newborn with a "
          "temperature of 100.4°F (38°C) or higher needs immediate "
          "medical evaluation.\n\n"
          "Sources: CDC — https://www.cdc.gov/act-early/milestones/"
          "2-months.html ; AAP — https://www.healthychildren.org/"
          "English/ages-stages/baby/sleep/Pages/a-parents-guide-to-safe-sleep.aspx",

      TileCategory.moveStrength:
          "For now, gentle movement may be enough. If you feel comfortable "
          "and your healthcare team has not advised otherwise, short, easy "
          "walks and changing positions throughout the day may help you "
          "begin returning to activity.\n\n"
          "Your recovery depends on factors such as whether you had a "
          "vaginal or cesarean birth, tearing, or other complications. "
          "Follow your discharge instructions and ask when to resume "
          "strenuous exercise, lifting, or abdominal workouts.\n\n"
          "Pelvic-floor exercises may be appropriate early on, but stop "
          "and seek advice if they cause pain or pressure. You do not "
          "need to rush your recovery or compare your activity level "
          "with anyone else's.\n\n"
          "Source: ACOG — https://www.acog.org/clinical/clinical-guidance/"
          "committee-opinion/articles/2020/04/physical-activity-and-exercise-"
          "during-pregnancy-and-the-postpartum-period",

      TileCategory.sleepRest:
          "Newborn sleep is often unpredictable. Babies may sleep for "
          "short stretches throughout the day and night, so you may not "
          "get a long, uninterrupted stretch yourself.\n\n"
          "If possible, arrange shifts with a partner or trusted support "
          "person so each adult has an opportunity to rest. Consider "
          "accepting help with meals, laundry, and household tasks instead "
          "of trying to do everything yourself.\n\n"
          "Always place your baby on their back in a separate, firm, "
          "flat sleep space. If you feel yourself nodding off while "
          "feeding or holding your baby, move the baby to their safe "
          "sleep space as soon as possible. Avoid couches and armchairs "
          "for feeding when you are very sleepy.\n\n"
          "Source: AAP — https://www.healthychildren.org/English/ages-stages/"
          "baby/sleep/pages/Getting-Your-Baby-to-Sleep.aspx",
    },

    AgeRange.months2to3: {
      TileCategory.mindMoodEnergy:
          "By now, the early baby blues have usually eased. If you are "
          "still feeling persistently sad, anxious, irritable, or "
          "disconnected, it is worth checking in with a healthcare "
          "professional. Postpartum depression and anxiety can make "
          "everyday tasks feel difficult, even when you are doing "
          "your best to care for your baby.\n\n"
          "You do not need to wait for your next appointment to ask "
          "for help. Tell your doctor, midwife, or your baby's "
          "pediatrician what you have been experiencing. Pediatric "
          "well-child visits can also provide opportunities to discuss "
          "parental emotional well-being.\n\n"
          "Postpartum Support International offers support groups and "
          "a directory of perinatal mental health professionals. "
          "Seeking help is a meaningful step toward feeling better.\n\n"
          "Sources: ACOG — https://www.acog.org/womens-health/faqs/"
          "postpartum-depression ; PSI — https://postpartum.net/",

      TileCategory.yourRecovery:
          "At two to three months postpartum, you may feel much more "
          "physically recovered, but healing does not follow one "
          "universal schedule. Pelvic discomfort, urinary leakage, "
          "pain during sex, bowel difficulties, or persistent incision "
          "pain deserve attention rather than being accepted as "
          "something you must live with.\n\n"
          "Consider scheduling a check-in if these symptoms are "
          "affecting daily activities or intimacy. Your clinician "
          "may recommend further evaluation or pelvic-floor physical "
          "therapy, depending on your symptoms.\n\n"
          "Keep up with your own healthcare, not just your baby's "
          "appointments. If you develop severe pain, heavy bleeding, "
          "chest pain, difficulty breathing, or another urgent symptom, "
          "seek medical attention promptly.\n\n"
          "Source: ACOG — https://www.acog.org/womens-health/health-tools/"
          "my-postpartum-care-checklist",

      TileCategory.feedingNourishment:
          "By now, you may be getting into a more familiar feeding "
          "routine, although growth spurts and changing appetite can "
          "make some days different from others. Breastfed babies "
          "may still feed frequently, and formula-fed babies may "
          "gradually go longer between feeds.\n\n"
          "Continue responding to hunger and fullness cues instead "
          "of expecting every feed to look the same. If you breastfeed "
          "and are returning to work or school, a lactation consultant "
          "can help you plan pumping and milk storage.\n\n"
          "If you use formula, follow the product's preparation "
          "instructions carefully. Do not dilute formula to make it "
          "last longer. Ask your baby's clinician about vitamin D "
          "supplementation if your baby receives breast milk or "
          "less than about 32 ounces of formula per day.\n\n"
          "Sources: CDC — https://www.cdc.gov/infant-toddler-nutrition/"
          "breastfeeding/how-much-and-how-often.html ; "
          "https://www.cdc.gov/infant-toddler-nutrition/formula-feeding/"
          "how-much-and-how-often.html",

      TileCategory.babyBasics:
          "Around two months, many babies begin smiling at people, "
          "looking at faces, making sounds other than crying, and "
          "holding their head up briefly during tummy time. Every "
          "baby develops at their own pace, so milestones are "
          "guides rather than deadlines.\n\n"
          "When your baby is awake and supervised, offer short "
          "periods of tummy time and talk, sing, or respond to "
          "their sounds. These simple interactions support movement, "
          "communication, and connection.\n\n"
          "Keep routine well-child visits and discuss any concerns "
          "about feeding, hearing, vision, or development. Contact "
          "your pediatrician if your baby loses a skill they "
          "previously had.\n\n"
          "Source: CDC — https://www.cdc.gov/act-early/milestones/"
          "2-months.html",

      TileCategory.moveStrength:
          "If your clinician has cleared you for activity, you may "
          "be ready to gradually increase the length or frequency "
          "of your walks. Gentle mobility and comfortable daily "
          "movement can be useful starting points while you rebuild "
          "stamina.\n\n"
          "Pay attention to symptoms rather than following a rigid "
          "timeline. Pelvic heaviness, urine leakage, abdominal "
          "pain, increased bleeding, or a feeling of pressure "
          "during exercise are reasons to pause and ask for "
          "professional advice.\n\n"
          "If you want to return to running, heavy lifting, or "
          "higher-impact workouts, ask your healthcare professional "
          "about an appropriate progression for your delivery "
          "and recovery. Progress should be gradual, not forced.\n\n"
          "Source: ACOG — https://www.acog.org/clinical/clinical-guidance/"
          "committee-opinion/articles/2020/04/physical-activity-and-exercise-"
          "during-pregnancy-and-the-postpartum-period",

      TileCategory.sleepRest:
          "Around two to three months, some babies begin developing "
          "more recognizable day-and-night patterns, but night "
          "waking remains normal. You may still need to feed, "
          "comfort, or change your baby during the night.\n\n"
          "A simple, calming bedtime routine can help signal that "
          "nighttime is for sleeping. Keep nighttime interactions "
          "quiet and lights dim when practical, while allowing "
          "daytime light and interaction during waking hours.\n\n"
          "Continue placing your baby on their back for every "
          "sleep, on a firm, flat surface without loose bedding. "
          "Do not use sleep positioners or inclined products to "
          "help your baby sleep. Your own rest matters too; ask "
          "for help if exhaustion is becoming difficult to manage.\n\n"
          "Source: AAP — https://www.healthychildren.org/English/ages-stages/"
          "baby/sleep/pages/Getting-Your-Baby-to-Sleep.aspx",
    },

    AgeRange.months4to6: {
      TileCategory.mindMoodEnergy:
          "Several months into parenthood, the demands of feeding, "
          "sleep disruption, and daily caregiving may still feel "
          "heavy. You might expect to feel completely settled by "
          "now, but there is no single timetable for adjusting "
          "to life with a baby.\n\n"
          "Depression and anxiety can persist or begin later in "
          "the first year after birth. Look out for ongoing "
          "hopelessness, loss of interest, excessive worry, "
          "difficulty concentrating, or trouble functioning "
          "day to day. You deserve support even if you felt "
          "well during the early weeks.\n\n"
          "Talk with a healthcare professional about your symptoms "
          "and treatment options. Postpartum Support International "
          "can help you locate specialized support. If you have "
          "thoughts of harming yourself or your baby, seek immediate "
          "professional help.\n\n"
          "Sources: ACOG — https://www.acog.org/womens-health/faqs/"
          "postpartum-depression ; PSI — https://postpartum.net/",

      TileCategory.yourRecovery:
          "At four to six months postpartum, recovery may be less "
          "visible but still important. If you are experiencing "
          "ongoing pelvic pain, urine leakage, pain during sex, "
          "back discomfort, or abdominal weakness, bring it up "
          "with your healthcare professional.\n\n"
          "You do not have to wait for symptoms to become severe "
          "before asking for help. Depending on your needs, "
          "evaluation or pelvic-floor physical therapy may help "
          "address persistent symptoms.\n\n"
          "If your periods have returned, they may differ from "
          "your pre-pregnancy pattern. Breastfeeding does not "
          "reliably prevent pregnancy in every circumstance, so "
          "discuss contraception and pregnancy spacing if relevant "
          "to you.\n\n"
          "Source: ACOG — https://www.acog.org/womens-health/health-tools/"
          "my-postpartum-care-checklist",

      TileCategory.feedingNourishment:
          "Around six months, many babies are ready to begin "
          "complementary foods when they show developmental "
          "readiness, such as being able to sit with support "
          "and control their head and neck. Breast milk or "
          "infant formula remains their main source of nutrition "
          "through the first year.\n\n"
          "Start with small amounts of soft, developmentally "
          "appropriate foods. Offer a variety of nutrient-rich "
          "options, including iron-rich foods, vegetables, fruits, "
          "and appropriate protein sources. Introduce foods "
          "safely and supervise your baby while eating.\n\n"
          "Avoid choking hazards, honey before 12 months, and "
          "unpasteurized foods. Ask your pediatrician about "
          "introducing common allergens and any individual "
          "feeding concerns. Do not replace breast milk or "
          "formula with solid foods too quickly.\n\n"
          "Sources: CDC — https://www.cdc.gov/infant-toddler-nutrition/"
          "foods-and-drinks/foods-and-drinks-to-encourage.html ; "
          "https://www.cdc.gov/infant-toddler-nutrition/foods-and-drinks/"
          "how-much-and-how-often-to-feed.html",

      TileCategory.babyBasics:
          "Between four and six months, many babies become more "
          "social, reach for objects, make more sounds, and "
          "develop better head control. Give your baby supervised "
          "floor time, safe toys, and plenty of opportunities "
          "to interact with you.\n\n"
          "As your baby becomes more mobile, begin checking your "
          "home for hazards. Keep small objects, medications, "
          "cleaning products, hot drinks, and cords out of reach. "
          "Never leave your baby unattended on a bed, sofa, "
          "changing table, or other elevated surface.\n\n"
          "Discuss developmental milestones and feeding readiness "
          "at well-child visits. Babies develop at different rates, "
          "but losing a previously acquired skill or having "
          "persistent developmental concerns warrants a conversation "
          "with your pediatrician.\n\n"
          "Sources: CDC — https://www.cdc.gov/act-early/milestones/"
          "4-months.html ; https://www.cdc.gov/act-early/milestones/"
          "6-months.html",

      TileCategory.moveStrength:
          "If you have recovered sufficiently and your clinician "
          "has cleared you, you may be able to build a more "
          "consistent movement routine. Walking, gentle strength "
          "work, and comfortable mobility exercises can help "
          "you gradually rebuild endurance.\n\n"
          "There is no need to rush into high-impact exercise. "
          "Pay attention to pelvic pressure, urine leakage, "
          "pain, or abdominal symptoms during and after activity. "
          "These can indicate that you need to modify your "
          "routine or seek guidance.\n\n"
          "If you are breastfeeding, regular moderate exercise "
          "is generally compatible with breastfeeding. Staying "
          "hydrated and feeding or expressing milk before "
          "exercise may improve comfort. Adapt your routine "
          "to your recovery and energy levels.\n\n"
          "Source: ACOG — https://www.acog.org/clinical/clinical-guidance/"
          "committee-opinion/articles/2020/04/physical-activity-and-exercise-"
          "during-pregnancy-and-the-postpartum-period",

      TileCategory.sleepRest:
          "By four to six months, some babies begin sleeping "
          "for longer stretches, but others continue waking "
          "during the night. Sleep changes can happen as your "
          "baby grows, and waking does not automatically mean "
          "something is wrong.\n\n"
          "A consistent, soothing bedtime routine may help. "
          "Look for your baby's sleepy cues and keep the sleep "
          "environment calm. If you are considering a sleep "
          "training approach, choose one that fits your family "
          "and discuss feeding or medical concerns with your "
          "pediatrician first.\n\n"
          "Continue safe-sleep practices: place your baby on "
          "their back at the start of every sleep, use a firm "
          "flat sleep surface, and keep the sleep space free "
          "of pillows, loose blankets, and toys. Avoid comparing "
          "your baby's sleep with other babies' routines.\n\n"
          "Source: AAP — https://www.healthychildren.org/English/ages-stages/"
          "baby/sleep/pages/Getting-Your-Baby-to-Sleep.aspx",
    },

    AgeRange.months7to12: {
      TileCategory.mindMoodEnergy:
          "The second half of your baby's first year can bring "
          "new routines, changing responsibilities, and decisions "
          "about childcare or returning to work. You may feel "
          "proud of how far you have come and still feel tired, "
          "anxious, or overwhelmed.\n\n"
          "Perinatal depression and anxiety can persist or appear "
          "later in the first year. You do not need to wait for "
          "symptoms to disappear on their own. If low mood, "
          "excessive worry, loss of interest, or difficulty "
          "functioning is affecting your life, contact a healthcare "
          "professional to discuss support and treatment.\n\n"
          "Consider identifying people you can ask for practical "
          "help, emotional support, or a break. Postpartum Support "
          "International offers support groups and a provider "
          "directory. If you have thoughts of harming yourself "
          "or your baby, seek immediate professional help.\n\n"
          "Sources: ACOG — https://www.acog.org/womens-health/faqs/"
          "postpartum-depression ; PSI — https://postpartum.net/",

      TileCategory.yourRecovery:
          "As the first year progresses, you may be focused on "
          "your baby's milestones and overlook your own health. "
          "Persistent pelvic-floor symptoms, pain during sex, "
          "urinary or bowel leakage, or discomfort that limits "
          "daily activities are worth discussing with a healthcare "
          "professional, even if months have passed since birth.\n\n"
          "Keep up with preventive care and discuss contraception, "
          "future pregnancy plans, menstrual changes, and any "
          "health conditions affected by pregnancy. Your postpartum "
          "health is part of your long-term health, not just "
          "a short recovery period.\n\n"
          "If you have ongoing symptoms, ask whether further "
          "evaluation or a referral to a specialist or pelvic-floor "
          "physical therapist would be appropriate. Seek urgent "
          "care for severe or sudden symptoms.\n\n"
          "Source: ACOG — https://www.acog.org/womens-health/health-tools/"
          "my-postpartum-care-checklist",

      TileCategory.feedingNourishment:
          "Between seven and twelve months, solid foods gradually "
          "become a bigger part of your baby's diet, but breast "
          "milk or infant formula remains important throughout "
          "the first year. Offer a variety of soft, appropriately "
          "prepared foods, including iron-rich options, fruits, "
          "vegetables, grains, and protein sources.\n\n"
          "Let your baby explore food while seated upright and "
          "closely supervised. Avoid choking hazards such as "
          "whole grapes, whole nuts, popcorn, and hard raw "
          "vegetable pieces. Never give honey before the first "
          "birthday, and do not offer cow's milk as the main "
          "drink before 12 months.\n\n"
          "Around six to twelve months, small amounts of water "
          "can be offered with meals. Continue breast milk or "
          "infant formula as recommended by your pediatrician, "
          "and discuss allergies, iron intake, or feeding "
          "difficulties if you have concerns.\n\n"
          "Sources: CDC — https://www.cdc.gov/infant-toddler-nutrition/"
          "foods-and-drinks/foods-and-drinks-to-encourage.html ; "
          "https://www.cdc.gov/infant-toddler-nutrition/foods-and-drinks/"
          "how-much-and-how-often-to-feed.html",

      TileCategory.babyBasics:
          "During the second half of the first year, many babies "
          "begin sitting independently, moving around, responding "
          "to their names, babbling, or exploring objects in "
          "new ways. Development varies, so use milestones "
          "as a guide and discuss concerns with your pediatrician.\n\n"
          "Make your home safer as your baby becomes more mobile. "
          "Secure furniture and televisions, use safety gates "
          "where appropriate, keep stairs and windows protected, "
          "and store small objects, medications, and chemicals "
          "out of reach. Supervise your baby closely around "
          "water, pets, and food.\n\n"
          "Read together, talk about what you are doing, sing, "
          "and respond to your baby's attempts to communicate. "
          "These everyday interactions support learning and "
          "connection. Keep routine well-child visits and "
          "developmental screenings.\n\n"
          "Sources: CDC — https://www.cdc.gov/act-early/milestones/"
          "9-months.html ; https://www.cdc.gov/act-early/milestones/"
          "1-year.html",

      TileCategory.moveStrength:
          "As your baby grows, everyday movement may become more "
          "physically demanding. Carrying your baby, getting "
          "down to the floor, and lifting a car seat can all "
          "challenge your strength and endurance.\n\n"
          "If you are comfortable and have no medical restrictions, "
          "continue building a routine with walking, gradual "
          "strength work, and activities you enjoy. Increase "
          "intensity slowly and leave room for rest on busy days.\n\n"
          "Persistent urine leakage, pelvic heaviness, pain, "
          "or abdominal discomfort during exercise is not "
          "something you need to ignore. Ask your healthcare "
          "professional whether your routine should be adjusted "
          "or whether pelvic-floor physical therapy may help. "
          "Your progress does not need to match anyone else's.\n\n"
          "Source: ACOG — https://www.acog.org/clinical/clinical-guidance/"
          "committee-opinion/articles/2020/04/physical-activity-and-exercise-"
          "during-pregnancy-and-the-postpartum-period",

      TileCategory.sleepRest:
          "Your baby's sleep may become more predictable during "
          "the second half of the first year, but night waking "
          "can continue. Teething, illness, changes in routine, "
          "and developmental changes may temporarily disrupt "
          "sleep.\n\n"
          "A regular bedtime routine, a calm environment, and "
          "consistent sleep cues can help your family establish "
          "habits that work for you. If sleep difficulties are "
          "severe or you are concerned about your baby's "
          "breathing, feeding, or growth, speak with your "
          "pediatrician.\n\n"
          "Continue placing your baby on their back at the "
          "start of every sleep until their first birthday. "
          "Use a firm, flat sleep surface without pillows, "
          "loose bedding, or toys. If your baby can roll in "
          "both directions independently, you do not need "
          "to keep repositioning them, but always start "
          "sleep on the back and keep the sleep space clear.\n\n"
          "Source: AAP — https://www.healthychildren.org/English/"
          "ages-stages/baby/sleep/Pages/a-parents-guide-to-safe-sleep.aspx",
    },
  };

  static const String _crisisNote =
      'If you have thoughts of harming yourself or your baby, '
      'seek immediate professional help. In the United States, '
      'call or text 988 for mental health crisis support. '
      'If you or your baby are in immediate danger, call 911.';

  static const Set<TileCategory> _aapTiles = {
    TileCategory.babyBasics,
    TileCategory.sleepRest,
  };

  static const String _aapSource =
      'Additional resource: American Academy of Pediatrics (AAP) — '
      'https://www.healthychildren.org/';

  static const String _disclaimer =
      'This content is for general educational purposes only. '
      'It is not a substitute for professional medical advice, '
      'diagnosis, or treatment. Contact a qualified healthcare '
      'professional about your individual needs. Seek urgent '
      'medical care for severe or concerning symptoms.';


  AppTheme get _t => widget.theme;

  /// Produces a short preview
  String _previewText(String content, {int maxLength = 115}) {
    final normalized = content.trim().replaceAll(RegExp(r'\s+'), ' ');

    if (normalized.length <= maxLength) {
      return normalized;
    }

    return '${normalized.substring(0, maxLength).trimRight()}…';
  }


  // Age calculations
  int get _weekOfLife {
    final today = DateTime.now();
    final birth = widget.babyBirthday;
    final days = DateTime(today.year, today.month, today.day)
        .difference(DateTime(birth.year, birth.month, birth.day))
        .inDays;
    return (days < 0 ? 0 : days) ~/ 7 + 1;
  }

  // True while the entered date is still in the future (baby not born yet).
  bool get _notBornYet {
    final today = DateTime.now();
    final birth = widget.babyBirthday;
    return DateTime(birth.year, birth.month, birth.day)
        .isAfter(DateTime(today.year, today.month, today.day));
  }

  int get _weeksUntilDue {
    final today = DateTime.now();
    final birth = widget.babyBirthday;
    final days = DateTime(birth.year, birth.month, birth.day)
        .difference(DateTime(today.year, today.month, today.day))
        .inDays;
    return (days / 7).ceil();
  }

  String get _headerLabel => _notBornYet
      ? (_weeksUntilDue <= 1 ? 'Due this week' : 'Due in $_weeksUntilDue weeks')
      : 'Week $_weekOfLife';


  int get _completedMonths {
    final today = DateTime.now();
    final birth = widget.babyBirthday;
    int months =
        (today.year - birth.year) * 12 + (today.month - birth.month);
    if (today.day < birth.day) months--;
    return months < 0 ? 0 : months;
  }

  AgeRange get _ageRange {
    final monthOfLife = _completedMonths + 1;
    if (monthOfLife <= 1) return AgeRange.month1;
    if (monthOfLife <= 3) return AgeRange.months2to3;
    if (monthOfLife <= 6) return AgeRange.months4to6;
    return AgeRange.months7to12; // also used past 12 months
  }

 // UI
  void _openTile(TileCategory category) {
    final text = _content[_ageRange]![category]!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: _t.tertiary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 20,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                category.title,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _t.black,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          height: 1.5,
                          color: _t.black,
                        ),
                      ),
                      if (category == TileCategory.mindMoodEnergy) ...[
                        const SizedBox(height: 16),
                        Text(
                          _crisisNote,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                            color: _t.black,
                          ),
                        ),
                      ],
                      if (_aapTiles.contains(category)) ...[
                        const SizedBox(height: 16),
                        Text(
                          _aapSource,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            height: 1.4,
                            fontStyle: FontStyle.italic,
                            color: _t.black,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Text(
                        _disclaimer,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          height: 1.4,
                          color: _t.black.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            Expanded(child: _buildGrid()),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _t.secondary,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _t.primary.withValues(alpha: 0.5),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        _headerLabel,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: _t.black,
        ),
      ),
    );
  }

  /// Three rows of two tiles that stretch to fill the available height,
  /// so nothing overflows on small screens.
  Widget _buildGrid() {
    final categories = TileCategory.values;
    return Column(
      children: [
        for (int row = 0; row < categories.length; row += 2) ...[
          if (row > 0) const SizedBox(height: 22),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildTile(categories[row])),
                const SizedBox(width: 26),
                Expanded(child: _buildTile(categories[row + 1])),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTile(TileCategory category) {
    final content = _content[_ageRange]![category]!;
    final preview = _previewText(content);

    return Material(
      color: _t.primary.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(28),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => _openTile(category),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  color: _t.black,
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: Text(
                  preview,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    height: 1.45,
                    color: _t.black.withValues(alpha: 0.8),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Read more',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: _t.black,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 13,
                    color: _t.black,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }  


}