
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(const BetterMeApp());

class UserProfile {
  static String name = 'BetterMe User';
  static String goal = 'Build healthier habits';
  static bool notifications = true;
  static bool dailyReminder = true;
  static bool biometricLock = false;
  static bool privateMode = true;
}

class SecurityCenter extends StatefulWidget {
  const SecurityCenter({super.key});
  @override State<SecurityCenter> createState()=>_SecurityCenterState();
}
class _SecurityCenterState extends State<SecurityCenter>{
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Security Center')),
    body:ListView(padding:const EdgeInsets.all(18),children:[
      const Mascot(message:'Your journey should stay yours. 🔐 Here are the privacy controls.'),
      const SizedBox(height:12),
      Card(child:SwitchListTile(
        value:UserProfile.privateMode,
        onChanged:(v)=>setState(()=>UserProfile.privateMode=v),
        title:const Text('Private mode'),
        subtitle:const Text('Keep personal journey data private by default.'))),
      Card(child:SwitchListTile(
        value:UserProfile.biometricLock,
        onChanged:(v)=>setState(()=>UserProfile.biometricLock=v),
        title:const Text('Biometric lock'),
        subtitle:const Text('UI preference; native biometric integration is planned.'))),
      const Card(child:ListTile(
        leading:Icon(Icons.vpn_key_outlined),
        title:Text('API keys'),
        subtitle:Text('Production keys must stay on a secure backend, never inside the app.'))),
      const Card(child:ListTile(
        leading:Icon(Icons.https_outlined),
        title:Text('Encrypted transport'),
        subtitle:Text('Production network calls should use HTTPS/TLS.'))),
      const Card(child:ListTile(
        leading:Icon(Icons.delete_forever_outlined),
        title:Text('Delete my data'),
        subtitle:Text('Production account deletion endpoint will permanently remove user data.'))),
    ]));
}

class ProfileScreen extends StatefulWidget{
  const ProfileScreen({super.key});
  @override State<ProfileScreen> createState()=>_ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen>{
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Profile')),
    body:ListView(padding:const EdgeInsets.all(18),children:[
      const Center(child:CuteMascot(size:110)),
      const SizedBox(height:8),
      Center(child:Text(UserProfile.name,
        style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.w900))),
      const SizedBox(height:14),
      Card(child:ListTile(
        leading:const Icon(Icons.flag_outlined),title:const Text('My goal'),
        subtitle:Text(UserProfile.goal),
        trailing:const Icon(Icons.edit_outlined),
        onTap:()=>_editGoal())),
      Card(child:SwitchListTile(
        value:UserProfile.notifications,
        onChanged:(v)=>setState(()=>UserProfile.notifications=v),
        title:const Text('Notifications'),
        subtitle:const Text('Allow BetterMe reminders and encouragements.'))),
      Card(child:SwitchListTile(
        value:UserProfile.dailyReminder,
        onChanged:UserProfile.notifications?(v)=>setState(()=>UserProfile.dailyReminder=v):null,
        title:const Text('Daily reminder'),
        subtitle:const Text('Reminder scheduling will use the device notification system.'))),
      Card(child:ListTile(
        leading:const Icon(Icons.notifications_outlined),
        title:const Text('Reminder Settings'),
        onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const NotificationSettingsScreen())))),
      Card(child:ListTile(
        leading:const Icon(Icons.verified_outlined),
        title:const Text('Release Readiness'),
        onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const ReleaseReadiness())))),
      Card(child:ListTile(
        leading:const Icon(Icons.shield_outlined),
        title:const Text('Security Center'),
        onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const SecurityCenter())))),
      Card(child:ListTile(
        leading:const Icon(Icons.logout),
        title:const Text('Sign out'),
        onTap:()=>ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content:Text('Account authentication will be connected in the production backend.'))))),
    ]));
  void _editGoal(){
    final c=TextEditingController(text:UserProfile.goal);
    showDialog(context:context,builder:(_)=>AlertDialog(
      title:const Text('Edit goal'),
      content:TextField(controller:c,decoration:const InputDecoration(hintText:'Your goal')),
      actions:[
        TextButton(onPressed:()=>Navigator.pop(context),child:const Text('Cancel')),
        FilledButton(onPressed:(){
          setState(()=>UserProfile.goal=c.text.trim().isEmpty?UserProfile.goal:c.text.trim());
          Navigator.pop(context);
        },child:const Text('Save')),
      ]));
  }
}

class NotificationCenter extends StatelessWidget{
  const NotificationCenter({super.key});
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Notifications')),
    body:ListView(padding:const EdgeInsets.all(18),children:[
      const Mascot(message:'A gentle reminder can help—but you stay in control. 🔔'),
      const SizedBox(height:12),
      Card(child:ListTile(
        leading:const Icon(Icons.notifications_active_outlined),
        title:Text(UserProfile.notifications?'Notifications enabled':'Notifications paused'),
        subtitle:const Text('Manage reminder permission in Profile.'))),
      const Card(child:ListTile(
        leading:Icon(Icons.schedule),
        title:Text('Daily challenge reminder'),
        subtitle:Text('Production version will schedule this using local notifications.'))),
      const Card(child:ListTile(
        leading:Icon(Icons.favorite_border),
        title:Text('Encouragement'),
        subtitle:Text('Optional motivational messages from your BetterMe mascot.'))),
    ]));
}

class ChallengeState {
  static int completedDays = 1;
  static int streak = 1;
  static int bestStreak = 1;
  static int triggersLogged = 0;
  static int healthyChoices = 0;
  static final Set<int> completed = {1};

  static void completeDay(int day) {
    if (completed.add(day)) {
      completedDays = completed.length;
      streak = _calculateCurrentStreak();
      if (streak > bestStreak) bestStreak = streak;
      healthyChoices++;
    }
  }

  static int _calculateCurrentStreak() {
    int s = 0;
    for (int d = 21; d >= 1; d--) {
      if (completed.contains(d)) s++; else if (s > 0) break;
    }
    return s == 0 ? 1 : s;
  }
}

class Achievement {
  final String title, description;
  final IconData icon;
  final bool unlocked;
  const Achievement(this.title,this.description,this.icon,this.unlocked);
}

class AppContent {
  static const habits = [
    'Smoking','Alcohol','Excessive phone / social media',
    'Unhealthy eating','Late-night waking','Procrastination',
    'Masturbation / pornography','Custom habit'
  ];
  static const replacements = [
    'Exercise','Study / reading','Walk outside','Meditation / breathing',
    'Healthy hobby','Music','Talk to someone','Custom good habit'
  ];
  static const triggers = [
    'Loneliness','Stress / anxiety','Boredom','Anger',
    'Late night','Phone content','Specific thought','Other'
  ];
  static const challengeTitles = [
    'Notice one trigger today.',
    'Write down when the urge usually appears.',
    'Do your replacement habit for 10 minutes.',
    'Create distance from one trigger.',
    'Spend 15 minutes on something meaningful.',
    'Practice a 2-minute reset when an urge appears.',
    'Celebrate your first 7 days of effort.',
    'Change one part of your usual routine.',
    'Do one healthy activity before using your phone.',
    'Write why this change matters to you.',
    'Choose your replacement habit before an urge arrives.',
    'Take a short walk when you feel restless.',
    'Reduce one trigger from your environment.',
    'Give yourself 10 minutes before acting on an urge.',
    'Do something you are proud of today.',
    'Talk to someone you trust if you need support.',
    'Repeat your strongest replacement habit.',
    'Review your trigger patterns.',
    'Protect your sleep and routine.',
    'Write what has improved so far.',
    'Look back at the person you are becoming.'
  ];
}


class OnboardingState {
  static bool photoDone = false;
  static bool habitDone = false;
  static bool consentDone = false;
  static bool get complete => photoDone && habitDone && consentDone;
}

class AiPhotoService {
  // Production contract only: the provider API key must remain server-side.
  static Future<String> createBetterSelf({required String imagePath}) async {
    await Future.delayed(const Duration(seconds: 2));
    return 'better-self-placeholder';
  }
}

class NotificationPlan {
  static String reminderTime = '20:00';
  static bool enabled = true;
}

class AnimatedWelcome extends StatefulWidget {
  const AnimatedWelcome({super.key});
  @override State<AnimatedWelcome> createState()=>_AnimatedWelcomeState();
}
class _AnimatedWelcomeState extends State<AnimatedWelcome>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync:this,duration:const Duration(milliseconds:900))..forward();
  late final Animation<double> fade = CurvedAnimation(parent:controller,curve:Curves.easeOut);
  @override void dispose(){controller.dispose();super.dispose();}
  @override Widget build(BuildContext context)=>FadeTransition(
    opacity:fade,
    child:Welcome(onTheme:(m){},));
}

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});
  @override State<NotificationSettingsScreen> createState()=>_NotificationSettingsScreenState();
}
class _NotificationSettingsScreenState extends State<NotificationSettingsScreen>{
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Reminder Settings')),
    body:ListView(padding:const EdgeInsets.all(18),children:[
      const Mascot(message:'Pick a gentle time that works for you. You can change it anytime. 🔔'),
      const SizedBox(height:12),
      Card(child:SwitchListTile(
        value:NotificationPlan.enabled,
        onChanged:(v)=>setState(()=>NotificationPlan.enabled=v),
        title:const Text('Daily challenge reminder'),
        subtitle:Text(NotificationPlan.enabled
          ? 'Scheduled for ${NotificationPlan.reminderTime}'
          : 'Reminders are paused'))),
      Card(child:ListTile(
        leading:const Icon(Icons.schedule),
        title:const Text('Reminder time'),
        subtitle:Text(NotificationPlan.reminderTime),
        onTap:()=>_pickTime())),
      const Card(child:ListTile(
        leading:Icon(Icons.notifications_active_outlined),
        title:Text('Permission'),
        subtitle:Text('The production build will request OS notification permission before scheduling.'))),
    ]));
  Future<void> _pickTime() async {
    final parts=NotificationPlan.reminderTime.split(':');
    final initial=TimeOfDay(hour:int.parse(parts[0]),minute:int.parse(parts[1]));
    final t=await showTimePicker(context:context,initialTime:initial);
    if(t!=null)setState(()=>NotificationPlan.reminderTime=
      '${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')}');
  }
}

class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  const MetricCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
        ],
      ),
    ),
  );
}

class FinalHome extends StatelessWidget{
  const FinalHome({super.key});
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('BetterMe'),actions:[
      IconButton(icon:const Icon(Icons.person_outline),
        onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const ProfileScreen()))),
      IconButton(icon:const Icon(Icons.notifications_none),
        onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const NotificationSettingsScreen()))),
    ]),
    body:ListView(padding:const EdgeInsets.all(18),children:[
      const Mascot(message:'Welcome back! 🌱 One good choice today is enough to keep moving.'),
      const SizedBox(height:14),
      Card(child:Padding(padding:const EdgeInsets.all(18),child:Column(
        crossAxisAlignment:CrossAxisAlignment.start,children:[
          const Text('Today',style:TextStyle(fontSize:22,fontWeight:FontWeight.w900)),
          const SizedBox(height:8),
          Text('Day ${ChallengeState.completedDays.clamp(1,21)} of 21'),
          const SizedBox(height:12),
          LinearProgressIndicator(value:ChallengeState.completedDays/21,minHeight:10),
          const SizedBox(height:12),
          FilledButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>ChallengeHome(
            oldHabit:'Your focus',replacement:'Your healthy habit'))),child:const Text('Continue challenge')),
        ]))),
      const SizedBox(height:10),
      Row(children:[
        Expanded(child:MetricCard(label:'Streak',value:'${ChallengeState.streak} 🔥')),
        const SizedBox(width:10),
        Expanded(child:MetricCard(label:'Badges',value:'${[
          ChallengeState.completedDays>=1,
          ChallengeState.completedDays>=3,
          ChallengeState.completedDays>=7,
          ChallengeState.completedDays>=11,
          ChallengeState.completedDays>=21
        ].where((x)=>x).length}/5')),
      ]),
      const SizedBox(height:10),
      Card(child:ListTile(
        leading:const Icon(Icons.auto_awesome),
        title:const Text('Better Self'),
        subtitle:const Text('Your creative AI portrait experience'),
        onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const PhotoPlaceholder())))),
    ]));
}


class OnboardingFlow extends StatefulWidget{
  const OnboardingFlow({super.key});
  @override State<OnboardingFlow> createState()=>_OnboardingFlowState();
}
class _OnboardingFlowState extends State<OnboardingFlow>{
  int page=0;
  final PageController controller=PageController();
  @override void dispose(){controller.dispose();super.dispose();}
  @override Widget build(BuildContext context)=>Scaffold(
    body:SafeArea(child:Column(children:[
      Expanded(child:PageView(controller:controller,onPageChanged:(v)=>setState(()=>page=v),children:[
        const OnboardCard(icon:Icons.auto_awesome,title:'Meet your Better Self',
          body:'Choose a photo and create a motivating cartoon-style concept with your consent.'),
        const OnboardCard(icon:Icons.track_changes,title:'Find your triggers',
          body:'Notice patterns like stress, boredom or late nights—without shame.'),
        const OnboardCard(icon:Icons.calendar_month,title:'21 days of progress',
          body:'Replace one habit with a healthier action and build a streak one day at a time.'),
      ])),
      Padding(padding:const EdgeInsets.all(18),child:Row(children:[
        Text('${page+1}/3'),const Spacer(),
        FilledButton(onPressed:(){
          if(page<2)controller.nextPage(duration:const Duration(milliseconds:300),curve:Curves.easeOut);
          else Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const HabitSetup()));
        },child:Text(page<2?'Next':'Get started')),
      ])),
    ])));
}
class OnboardCard extends StatelessWidget{
  final IconData icon; final String title,body;
  const OnboardCard({super.key,required this.icon,required this.title,required this.body});
  @override Widget build(BuildContext context)=>Center(child:Padding(padding:const EdgeInsets.all(28),
    child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
      TweenAnimationBuilder<double>(tween:Tween(begin:.7,end:1),duration:const Duration(milliseconds:700),
        curve:Curves.easeOutBack,builder:(c,v,_)=>Transform.scale(scale:v,
          child:CircleAvatar(radius:58,child:Icon(icon,size:52)))),
      const SizedBox(height:28),
      Text(title,textAlign:TextAlign.center,style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.w900)),
      const SizedBox(height:12),Text(body,textAlign:TextAlign.center),
    ])));
}


class ConsentManager {
  static bool aiPhotoConsent = false;
  static bool analyticsConsent = false;
  static DateTime? consentUpdatedAt;

  static void setAi(bool value) {
    aiPhotoConsent = value;
    consentUpdatedAt = DateTime.now();
  }
  static void setAnalytics(bool value) {
    analyticsConsent = value;
    consentUpdatedAt = DateTime.now();
  }
}

class AppSettings {
  static bool haptics = true;
  static bool sound = true;
  static bool privateMode = true;
}

class DataStore {
  // Prototype has no persistent storage yet.
  static void clearUserData() {}
}

class DataManagementScreen extends StatefulWidget {
  const DataManagementScreen({super.key});
  @override State<DataManagementScreen> createState()=>_DataManagementScreenState();
}
class _DataManagementScreenState extends State<DataManagementScreen>{
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Data & Privacy')),
    body:ListView(padding:const EdgeInsets.all(18),children:[
      const Mascot(message:'You control your data. Choose what BetterMe can use. 🔐'),
      const SizedBox(height:12),
      Card(child:SwitchListTile(
        value:ConsentManager.aiPhotoConsent,
        onChanged:(v)=>setState(()=>ConsentManager.setAi(v)),
        title:const Text('AI photo processing'),
        subtitle:const Text('Required before sending a photo to the AI service.'))),
      Card(child:SwitchListTile(
        value:ConsentManager.analyticsConsent,
        onChanged:(v)=>setState(()=>ConsentManager.setAnalytics(v)),
        title:const Text('Optional analytics'),
        subtitle:const Text('Off by default; production analytics should avoid private habit content.'))),
      Card(child:ListTile(
        leading:const Icon(Icons.download_outlined),
        title:const Text('Export my data'),
        subtitle:const Text('Production: create an authenticated export of your data.'),
        onTap:()=>ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content:Text('Export endpoint is ready for backend integration.'))))),
      Card(child:ListTile(
        leading:const Icon(Icons.delete_forever_outlined),
        title:const Text('Delete my data'),
        subtitle:const Text('Clear local prototype data and revoke consent.'),
        onTap:()=>_delete())),
      const SizedBox(height:8),
      Text('Consent updated: ${ConsentManager.consentUpdatedAt?.toLocal() ?? 'Not yet'}',
        style:const TextStyle(fontSize:12)),
    ]));
  void _delete(){
    showDialog(context:context,builder:(_)=>AlertDialog(
      title:const Text('Delete local data?'),
      content:const Text('This removes prototype data from the current session. Production deletion must also remove server-side data.'),
      actions:[
        TextButton(onPressed:()=>Navigator.pop(context),child:const Text('Cancel')),
        FilledButton(onPressed:(){
          DataStore.clearUserData();
          ChallengeState.completed.clear();
          ChallengeState.completedDays=0;
          ChallengeState.streak=0;
          ChallengeState.bestStreak=0;
          ChallengeState.triggersLogged=0;
          ChallengeState.healthyChoices=0;
          ConsentManager.aiPhotoConsent=false;
          ConsentManager.analyticsConsent=false;
          Navigator.pop(context);
          setState((){});
        },child:const Text('Delete')),
      ]));
  }
}

class AppSettingsScreen extends StatefulWidget{
  const AppSettingsScreen({super.key});
  @override State<AppSettingsScreen> createState()=>_AppSettingsScreenState();
}
class _AppSettingsScreenState extends State<AppSettingsScreen>{
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('App Settings')),
    body:ListView(padding:const EdgeInsets.all(18),children:[
      Card(child:SwitchListTile(value:AppSettings.haptics,
        onChanged:(v)=>setState(()=>AppSettings.haptics=v),
        title:const Text('Haptics'),subtitle:const Text('Small feedback on important actions.'))),
      Card(child:SwitchListTile(value:AppSettings.sound,
        onChanged:(v)=>setState(()=>AppSettings.sound=v),
        title:const Text('Sound'),subtitle:const Text('Optional mascot and challenge sounds.'))),
      Card(child:SwitchListTile(value:AppSettings.privateMode,
        onChanged:(v)=>setState(()=>AppSettings.privateMode=v),
        title:const Text('Private mode'),subtitle:const Text('Avoid displaying sensitive habit details in public-facing UI.'))),
    ]));
}

class ReleaseReadiness extends StatelessWidget{
  const ReleaseReadiness({super.key});
  @override Widget build(BuildContext context){
    final checks=[
      ['UI / navigation',true],
      ['21-day challenge flow',true],
      ['Streak & achievements',true],
      ['Trigger tracker',true],
      ['Profile & settings',true],
      ['Privacy/consent screens',true],
      ['Real encrypted persistence',false],
      ['Production authentication/backend',false],
      ['Real AI provider backend',false],
      ['Native notification scheduling',false],
      ['Native biometric authentication',false],
      ['QA/security audit & Play Store release',false],
    ];
    return Scaffold(appBar:AppBar(title:const Text('Release Readiness')),
      body:ListView(padding:const EdgeInsets.all(16),children:[
        const Mascot(message:'We’re close! These checks show what is prototype-ready and what still needs production integration. 🚀'),
        const SizedBox(height:10),
        ...checks.map((c)=>Card(child:ListTile(
          leading:Icon(c[1] as bool?Icons.check_circle:Icons.pending_outlined),
          title:Text(c[0] as String),
          trailing:Text(c[1] as bool?'READY':'NEXT')))),
      ]));
  }
}

class BetterMeApp extends StatefulWidget {
  const BetterMeApp({super.key});
  @override State<BetterMeApp> createState()=>_BetterMeAppState();
}
class _BetterMeAppState extends State<BetterMeApp>{
  ThemeMode mode=ThemeMode.system;
  @override Widget build(BuildContext context)=>MaterialApp(
    debugShowCheckedModeBanner:false,title:'BetterMe',themeMode:mode,
    theme:ThemeData(useMaterial3:true,colorSchemeSeed:const Color(0xFF176B45),
      brightness:Brightness.light,scaffoldBackgroundColor:const Color(0xFFF5F8F5)),
    darkTheme:ThemeData(useMaterial3:true,colorSchemeSeed:const Color(0xFF35D58A),
      brightness:Brightness.dark,scaffoldBackgroundColor:const Color(0xFF061D15)),
    home:Welcome(onTheme:(m)=>setState(()=>mode=m)),
  );
}

class Welcome extends StatelessWidget{
  final ValueChanged<ThemeMode> onTheme;
  const Welcome({super.key,required this.onTheme});
  @override Widget build(BuildContext context)=>Scaffold(
    body:SafeArea(child:ListView(padding:const EdgeInsets.all(22),children:[
      const Mascot(message:'Ready for your next step? 🌱 Let’s choose one habit and replace it with something better!'),
      const SizedBox(height:20),
      Text('BetterMe',textAlign:TextAlign.center,
        style:Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight:FontWeight.w900)),
      const SizedBox(height:8),
      const Text('21 days • Better habits • Private journey',textAlign:TextAlign.center),
      const SizedBox(height:24),
      FilledButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const OnboardingFlow())),
        child:const Padding(padding:EdgeInsets.symmetric(vertical:14),child:Text('Begin BetterMe'))),
      const SizedBox(height:8),
      OutlinedButton.icon(
        onPressed:()=>showModalBottomSheet(context:context,builder:(_)=>ThemePicker(onTheme:onTheme)),
        icon:const Icon(Icons.brightness_6),label:const Text('Auto / Light / Dark')),
    ])));
}

class HabitSetup extends StatefulWidget{
  const HabitSetup({super.key});
  @override State<HabitSetup> createState()=>_HabitSetupState();
}
class _HabitSetupState extends State<HabitSetup>{
  String? oldHabit;
  String? replacement;
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Choose your focus')),
    body:ListView(padding:const EdgeInsets.all(18),children:[
      const Mascot(message:'No judgment. Pick the habit you want to change, then choose what you want to do instead. 💚'),
      const SizedBox(height:18),
      Text('1. Habit you want to reduce',
        style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight:FontWeight.w800)),
      const SizedBox(height:8),
      ...AppContent.habits.map((h)=>RadioListTile<String>(
        value:h,groupValue:oldHabit,title:Text(h),
        onChanged:(v)=>setState(()=>oldHabit=v))),
      const SizedBox(height:12),
      Text('2. Good habit to build',
        style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight:FontWeight.w800)),
      const SizedBox(height:8),
      ...AppContent.replacements.map((h)=>RadioListTile<String>(
        value:h,groupValue:replacement,title:Text(h),
        onChanged:(v)=>setState(()=>replacement=v))),
      const SizedBox(height:10),
      FilledButton(
        onPressed:(oldHabit==null||replacement==null)?null:()=>Navigator.pushReplacement(
          context,MaterialPageRoute(builder:(_)=>ChallengeHome(
            oldHabit:oldHabit!,replacement:replacement!))),
        child:const Text('Start my 21 days'),
      )
    ]));
}

class ChallengeHome extends StatelessWidget{
  final String oldHabit,replacement;
  const ChallengeHome({super.key,required this.oldHabit,required this.replacement});
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('My 21-Day Challenge')),
    body:ListView(padding:const EdgeInsets.all(18),children:[
      Mascot(message:'You chose "$replacement" as your healthier replacement. That’s a strong start! 🦉💚'),
      const SizedBox(height:14),
      Card(child:Padding(padding:const EdgeInsets.all(18),child:Column(
        crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text('Day 1 of 21',style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.w900)),
          const SizedBox(height:8),
          const Text('Notice one trigger today. You do not need to be perfect.'),
          const SizedBox(height:14),
          LinearProgressIndicator(value:1/21,minHeight:9,borderRadius:BorderRadius.circular(8)),
          const SizedBox(height:8),const Text('Progress: 1 / 21'),
        ]))),
      const SizedBox(height:12),
      Card(child:ListTile(
        leading:const CircleAvatar(child:Icon(Icons.psychology_alt)),
        title:const Text('Track a trigger'),
        subtitle:const Text('Understand what happens before an urge.'),
        onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const TriggerLog())),
      )),
      Card(child:ListTile(
        leading:const CircleAvatar(child:Icon(Icons.self_improvement)),
        title:const Text('Need an urge reset?'),
        subtitle:const Text('Try a quick healthier action.'),
        onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const Reset())),
      )),
      Card(child:ListTile(
        leading:const CircleAvatar(child:Icon(Icons.calendar_month)),
        title:const Text('See all 21 days'),
        subtitle:const Text('Preview your daily missions.'),
        onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const Days())),
      )),
    ]));
}

class Days extends StatelessWidget{
  const Days({super.key});
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('21-Day Missions')),
    body:ListView.builder(
      padding:const EdgeInsets.all(12),itemCount:21,
      itemBuilder:(context,i)=>Card(child:ListTile(
        leading:CircleAvatar(child:Text('${i+1}')),
        title:Text('Day ${i+1}'),
        subtitle:Text(AppContent.challengeTitles[i]),
        trailing:i==0?const Icon(Icons.check_circle):const Icon(Icons.lock_outline),
      ))));
}

class TriggerLog extends StatefulWidget{
  const TriggerLog({super.key});
  @override State<TriggerLog> createState()=>_TriggerLogState();
}
class _TriggerLogState extends State<TriggerLog>{
  final selected=<String>{};
  int strength=5;
  String? replacement;
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Trigger & Urge Log')),
    body:ListView(padding:const EdgeInsets.all(18),children:[
      const Mascot(message:'Understanding the pattern is progress. 🧠'),
      const SizedBox(height:12),
      Text('What triggered the urge?',style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight:FontWeight.w800)),
      ...AppContent.triggers.map((t)=>CheckboxListTile(
        value:selected.contains(t),title:Text(t),
        onChanged:(v)=>setState(()=>v==true?selected.add(t):selected.remove(t)))),
      const SizedBox(height:8),
      Text('Urge strength: $strength / 10'),
      Slider(value:strength.toDouble(),min:1,max:10,divisions:9,
        onChanged:(v)=>setState(()=>strength=v.round())),
      const SizedBox(height:8),
      Text('What did you choose instead?',style:Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight:FontWeight.w700)),
      DropdownButtonFormField<String>(
        value:replacement,
        items:AppContent.replacements.map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),
        onChanged:(v)=>setState(()=>replacement=v),
        decoration:const InputDecoration(border:OutlineInputBorder(),hintText:'Select a healthier action')),
      const SizedBox(height:14),
      FilledButton(onPressed:selected.isEmpty?null:(){
        ChallengeState.triggersLogged++;
        Navigator.pop(context);
      },child:const Text('Save log')),
    ]));
}

class Reset extends StatelessWidget{
  const Reset({super.key});
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('2-Minute Reset')),
    body:Center(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
      const CuteMascot(size:130),const SizedBox(height:18),
      Text('Pause. Breathe. Choose.',style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.w900)),
      const SizedBox(height:10),
      const Text('Take five slow breaths, drink water, stand up and change your surroundings.',
        textAlign:TextAlign.center),
      const SizedBox(height:20),
      FilledButton(onPressed:()=>Navigator.pop(context),child:const Text('I chose a healthier action')),
    ]))));
}

class PhotoPlaceholder extends StatefulWidget{
  const PhotoPlaceholder({super.key});
  @override State<PhotoPlaceholder> createState()=>_PhotoPlaceholderState();
}
class _PhotoPlaceholderState extends State<PhotoPlaceholder>{
  XFile? photo;
  Future<void> pick()async{
    final p=await ImagePicker().pickImage(source:ImageSource.gallery,imageQuality:90);
    if(p!=null)setState(()=>photo=p);
  }
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Your Better Self')),
    body:ListView(padding:const EdgeInsets.all(20),children:[
      GestureDetector(onTap:pick,child:Container(height:280,
        decoration:BoxDecoration(borderRadius:BorderRadius.circular(26),
          color:Theme.of(context).colorScheme.surfaceContainerHighest),
        clipBehavior:Clip.antiAlias,
        child:photo==null?const Center(child:Text('Tap to choose your photo')):
          Image.file(File(photo!.path),fit:BoxFit.cover))),
      const SizedBox(height:14),
      const Mascot(message:'In the production version, your consented photo will be transformed into your cute Better Self cartoon. ✨'),
      const SizedBox(height:12),
      Card(child:SwitchListTile(
        value:ConsentManager.aiPhotoConsent,
        onChanged:(v)=>setState(()=>ConsentManager.setAi(v)),
        title:const Text('I consent to AI photo processing'),
        subtitle:const Text('Required before the photo can be sent to the AI service.'))),
      const SizedBox(height:12),
      FilledButton.icon(onPressed:(photo==null||!ConsentManager.aiPhotoConsent)?null:()async{
        await AiPhotoService.createBetterSelf(imagePath:photo!.path);
        if(context.mounted)ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content:Text('AI generation contract is ready for secure backend integration.')));
      },icon:const Icon(Icons.auto_awesome),label:const Text('Create Better Self')), 
    ]));
}

class Mascot extends StatelessWidget{
  final String message;
  const Mascot({super.key,required this.message});
  @override Widget build(BuildContext context)=>Card(
    color:Theme.of(context).colorScheme.primaryContainer.withValues(alpha:.55),
    child:Padding(padding:const EdgeInsets.all(14),child:Row(children:[
      const CuteMascot(size:70),const SizedBox(width:12),Expanded(child:Text(message,
        style:const TextStyle(fontWeight:FontWeight.w700,height:1.3))),
    ])));
}

class CuteMascot extends StatelessWidget{
  final double size;
  const CuteMascot({super.key,this.size=90});
  @override Widget build(BuildContext context)=>CustomPaint(
    size:Size(size,size),painter:MascotPainter());
}
class MascotPainter extends CustomPainter{
  @override void paint(Canvas canvas,Size s){
    final c=Offset(s.width/2,s.height/2),r=s.width*.34;
    canvas.drawCircle(c.translate(0,5),r,Paint()..color=const Color(0xFF2E8B57));
    canvas.drawOval(Rect.fromCenter(center:c.translate(0,17),width:r*1.25,height:r*1.05),
      Paint()..color=const Color(0xFFB9F2D0));
    final w=Paint()..color=Colors.white,d=Paint()..color=const Color(0xFF12352A);
    for(final x in [-.38,.38]){
      canvas.drawCircle(Offset(c.dx+r*x,c.dy-7),r*.13,w);
      canvas.drawCircle(Offset(c.dx+r*x,c.dy-7),r*.055,d);
    }
    canvas.drawCircle(Offset(c.dx-r*.55,c.dy+12),r*.10,Paint()..color=const Color(0xFFFFA6B8));
    canvas.drawCircle(Offset(c.dx+r*.55,c.dy+12),r*.10,Paint()..color=const Color(0xFFFFA6B8));
    final beak=Path()..moveTo(c.dx,c.dy+1)..lineTo(c.dx-6,c.dy+10)..lineTo(c.dx+6,c.dy+10)..close();
    canvas.drawPath(beak,Paint()..color=const Color(0xFFFFC857));
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}

class ThemePicker extends StatelessWidget{
  final ValueChanged<ThemeMode> onTheme;
  const ThemePicker({super.key,required this.onTheme});
  @override Widget build(BuildContext context)=>SafeArea(child:Column(mainAxisSize:MainAxisSize.min,children:[
    const ListTile(title:Text('Choose appearance')),
    ListTile(leading:const Icon(Icons.brightness_auto),title:const Text('Auto'),
      onTap:(){onTheme(ThemeMode.system);Navigator.pop(context);}),
    ListTile(leading:const Icon(Icons.light_mode),title:const Text('Light'),
      onTap:(){onTheme(ThemeMode.light);Navigator.pop(context);}),
    ListTile(leading:const Icon(Icons.dark_mode),title:const Text('Dark'),
      onTap:(){onTheme(ThemeMode.dark);Navigator.pop(context);}),
    const SizedBox(height:8),
  ]));
}
