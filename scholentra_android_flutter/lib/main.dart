import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const ScholentraApp());

const _navy = Color(0xFF071A46);
const _blue = Color(0xFF2563EB);
const _violet = Color(0xFF7657FF);
const _green = Color(0xFF12B76A);
const _red = Color(0xFFF04438);
const _amber = Color(0xFFF79009);

class AppController extends ChangeNotifier {
  bool dark = false;
  bool loggedIn = false;
  int tab = 0;
  String search = '';
  final List<Student> students = List.of(demoStudents);

  void login() { loggedIn = true; notifyListeners(); }
  void logout() { loggedIn = false; tab = 0; notifyListeners(); }
  void toggleTheme() { dark = !dark; notifyListeners(); }
  void setTab(int i) { tab = i; notifyListeners(); }
  void setSearch(String value) { search = value; notifyListeners(); }
  void addStudent(Student s) { students.insert(0, s); notifyListeners(); }
  void deleteStudent(String id) { students.removeWhere((e) => e.id == id); notifyListeners(); }
}

class ScholentraApp extends StatefulWidget {
  const ScholentraApp({super.key});
  @override State<ScholentraApp> createState() => _ScholentraAppState();
}

class _ScholentraAppState extends State<ScholentraApp> {
  final controller = AppController();
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Scholentra',
        themeMode: controller.dark ? ThemeMode.dark : ThemeMode.light,
        theme: buildTheme(false),
        darkTheme: buildTheme(true),
        home: controller.loggedIn ? AppShell(controller: controller) : LoginScreen(controller: controller),
      ),
    );
  }
}

ThemeData buildTheme(bool dark) {
  final scheme = ColorScheme.fromSeed(
    seedColor: _blue,
    brightness: dark ? Brightness.dark : Brightness.light,
    surface: dark ? const Color(0xFF101828) : Colors.white,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: dark ? const Color(0xFF0B1220) : const Color(0xFFF6F8FC),
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, letterSpacing: -1.0),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -.7),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark ? const Color(0xFF111A2E) : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: dark ? const Color(0xFF26324A) : const Color(0xFFE5EAF2))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: dark ? const Color(0xFF26324A) : const Color(0xFFE5EAF2))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: _blue, width: 1.4)),
    ),
  );
}

class LoginScreen extends StatefulWidget {
  final AppController controller;
  const LoginScreen({super.key, required this.controller});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController(text: 'admin@demo.com');
  final password = TextEditingController(text: 'admin123');
  bool hide = true;
  bool remember = true;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final left = _LoginBrandPanel(compact: !wide);
    final form = Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: wide ? 54 : 22, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Container(
            padding: EdgeInsets.all(wide ? 34 : 24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Theme.of(context).dividerColor.withOpacity(.35)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 40, offset: const Offset(0, 18))],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Image.asset('assets/images/scholentra-logo.png', height: 70, fit: BoxFit.contain)),
              const SizedBox(height: 28),
              Text('Welcome back', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 6),
              Text('Sign in to continue to your Scholentra workspace.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 28),
              const Text('Email address', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(prefixIcon: Icon(Icons.mail_outline_rounded), hintText: 'admin@demo.com')),
              const SizedBox(height: 18),
              const Text('Password', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(controller: password, obscureText: hide, decoration: InputDecoration(prefixIcon: const Icon(Icons.lock_outline_rounded), hintText: 'Enter password', suffixIcon: IconButton(onPressed: () => setState(() => hide = !hide), icon: Icon(hide ? Icons.visibility_outlined : Icons.visibility_off_outlined)))),
              const SizedBox(height: 12),
              Row(children: [
                Checkbox(value: remember, onChanged: (v) => setState(() => remember = v ?? true)),
                const Text('Remember me'),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text('Forgot password?')),
              ]),
              const SizedBox(height: 8),
              SizedBox(width: double.infinity, height: 54, child: FilledButton.icon(onPressed: widget.controller.login, iconAlignment: IconAlignment.end, icon: const Icon(Icons.arrow_forward_rounded), label: const Text('Sign in'))),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: _blue.withOpacity(.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: _blue.withOpacity(.14))),
                child: Row(children: [
                  const Icon(Icons.school_outlined, color: _blue), const SizedBox(width: 12),
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Demo account', style: TextStyle(fontWeight: FontWeight.w700)), SizedBox(height: 2), Text('Sapphire School sample data', style: TextStyle(fontSize: 12.5))])),
                  TextButton(onPressed: () { email.text='admin@demo.com'; password.text='admin123'; }, child: const Text('Use demo')),
                ]),
              ),
              const SizedBox(height: 18),
              Center(child: Text('A product of CoreSyncs', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant))),
            ]),
          ),
        ),
      ),
    );
    if (wide) return Scaffold(body: Row(children: [Expanded(flex: 11, child: left), Expanded(flex: 9, child: form)]));
    return Scaffold(body: Stack(children: [Positioned.fill(child: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFEAF2FF), Color(0xFFF7F9FF)], begin: Alignment.topLeft, end: Alignment.bottomRight)))), form, Positioned(top: 14, right: 14, child: IconButton.filledTonal(onPressed: widget.controller.toggleTheme, icon: const Icon(Icons.dark_mode_outlined)))]));
  }
}

class _LoginBrandPanel extends StatelessWidget {
  final bool compact;
  const _LoginBrandPanel({required this.compact});
  @override Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFEAF2FF)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: Stack(children: [
        Positioned.fill(child: Opacity(opacity: .22, child: Image.asset('assets/images/campus.jpg', alignment: Alignment.bottomCenter, fit: BoxFit.cover))),
        Positioned.fill(child: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFF5F9FF), Color(0xCCEFF5FF), Color(0x44EAF2FF)], begin: Alignment.topLeft, end: Alignment.bottomRight)))),
        SafeArea(child: Padding(
          padding: const EdgeInsets.fromLTRB(54, 36, 54, 38),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Image.asset('assets/images/scholentra-logo.png', height: 95, alignment: Alignment.centerLeft),
            const Spacer(flex: 2),
            const Text('EDUCATION, UNIFIED', style: TextStyle(color: Color(0xFF536A9D), fontWeight: FontWeight.w700, letterSpacing: 3.2, fontSize: 12)),
            const SizedBox(height: 20),
            const Text('Smarter Schools.', style: TextStyle(color: _navy, fontSize: 48, fontWeight: FontWeight.w700, letterSpacing: -1.8, height: 1.02)),
            ShaderMask(shaderCallback: (r) => const LinearGradient(colors: [_blue, _violet]).createShader(r), blendMode: BlendMode.srcIn, child: const Text('Brighter Futures.', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700, letterSpacing: -1.8, height: 1.04))),
            const SizedBox(height: 22),
            const ConstrainedBox(constraints: BoxConstraints(maxWidth: 620), child: Text('A unified operating system for students, admissions, academics, attendance, finance, communication and institutional intelligence.', style: TextStyle(color: Color(0xFF5C6B89), fontSize: 18, height: 1.65))),
            const SizedBox(height: 28),
            const Wrap(spacing: 34, runSpacing: 16, children: [
              _Feature(icon: Icons.groups_2_outlined, title: 'All-in-One', subtitle: 'School Management'),
              _Feature(icon: Icons.auto_graph_rounded, title: 'Meaningful', subtitle: 'Insights & Reports'),
              _Feature(icon: Icons.verified_user_outlined, title: 'Secure & Reliable', subtitle: 'Built to Scale'),
            ]),
            const Spacer(flex: 3),
            const Row(children: [
              _Proof(value: '1,000+', label: 'Schools'), SizedBox(width: 34),
              _Proof(value: '10M+', label: 'Students'), SizedBox(width: 34),
              _Proof(value: '99.9%', label: 'Availability'),
            ]),
          ]),
        )),
      ]),
    );
  }
}

class _Feature extends StatelessWidget { final IconData icon; final String title, subtitle; const _Feature({required this.icon, required this.title, required this.subtitle}); @override Widget build(BuildContext context)=>Row(mainAxisSize:MainAxisSize.min,children:[Container(width:52,height:52,decoration:BoxDecoration(color:Colors.white.withOpacity(.88),borderRadius:BorderRadius.circular(16)),child:Icon(icon,color:_blue)),const SizedBox(width:12),Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(color:_navy,fontWeight:FontWeight.w700)),Text(subtitle,style:const TextStyle(color:Color(0xFF657492),fontSize:12.5))])]); }
class _Proof extends StatelessWidget { final String value,label; const _Proof({required this.value,required this.label}); @override Widget build(BuildContext context)=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(value,style:const TextStyle(color:_navy,fontSize:18,fontWeight:FontWeight.w700)),Text(label,style:const TextStyle(color:Color(0xFF697896),fontSize:12))]); }

class AppShell extends StatelessWidget {
  final AppController controller;
  const AppShell({super.key, required this.controller});
  static const tabs = ['Home','Students','Attendance','Finance','More'];
  @override Widget build(BuildContext context) {
    final pages = [DashboardScreen(controller: controller), StudentsScreen(controller: controller), const AttendanceScreen(), const FinanceScreen(), MoreScreen(controller: controller)];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 18,
        title: Row(children: [
          Container(width: 36,height:36,decoration:BoxDecoration(color:_blue.withOpacity(.1),borderRadius:BorderRadius.circular(11)),child:const Icon(Icons.school_rounded,color:_blue,size:21)),
          const SizedBox(width:10),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text('Sapphire School',style:TextStyle(fontSize:15,fontWeight:FontWeight.w700)),Text('Scholentra',style:TextStyle(fontSize:11,fontWeight:FontWeight.w400))])),
        ]),
        actions: [IconButton(onPressed: controller.toggleTheme, icon: Icon(controller.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined)), IconButton(onPressed: () {}, icon: const Badge(smallSize: 7, child: Icon(Icons.notifications_none_rounded))), const SizedBox(width:6), const CircleAvatar(radius:17,backgroundImage:AssetImage('assets/images/admin.png')), const SizedBox(width:12)],
      ),
      body: Stack(children:[IndexedStack(index: controller.tab, children: pages), const Positioned(right:18,bottom:18,child:AiFab())]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: controller.tab,
        onDestinationSelected: controller.setTab,
        destinations: const [
          NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home_rounded),label:'Home'),
          NavigationDestination(icon:Icon(Icons.groups_outlined),selectedIcon:Icon(Icons.groups_rounded),label:'Students'),
          NavigationDestination(icon:Icon(Icons.fact_check_outlined),selectedIcon:Icon(Icons.fact_check_rounded),label:'Attendance'),
          NavigationDestination(icon:Icon(Icons.account_balance_wallet_outlined),selectedIcon:Icon(Icons.account_balance_wallet_rounded),label:'Finance'),
          NavigationDestination(icon:Icon(Icons.grid_view_outlined),selectedIcon:Icon(Icons.grid_view_rounded),label:'More'),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final AppController controller;
  const DashboardScreen({super.key, required this.controller});
  @override Widget build(BuildContext context) {
    return RefreshIndicator(onRefresh: () async => Future.delayed(const Duration(milliseconds:700)), child: ListView(padding: const EdgeInsets.fromLTRB(18,16,18,110), children:[
      Container(
        height: 155,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: const LinearGradient(colors:[Color(0xFFE8F1FF),Color(0xFFF3F4FF)])),
        child: Stack(children:[Positioned(right:-35,bottom:-26,width:250,height:170,child:Opacity(opacity:.6,child:Image.asset('assets/images/campus.jpg',fit:BoxFit.cover))),Padding(padding:const EdgeInsets.all(22),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('WELCOME BACK',style:TextStyle(fontSize:10.5,letterSpacing:2.2,fontWeight:FontWeight.w700,color:Color(0xFF60729A))),const SizedBox(height:10),Text('Good morning, Admin',style:Theme.of(context).textTheme.headlineMedium?.copyWith(color:_navy)),const SizedBox(height:6),const Text("Here's what's happening at Sapphire School today.",style:TextStyle(color:Color(0xFF5E6D89),fontSize:13.5))]))]),
      ),
      const SizedBox(height:16),
      GridView.count(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),crossAxisCount:2,crossAxisSpacing:12,mainAxisSpacing:12,childAspectRatio:1.48,children: const [
        KpiCard(icon:Icons.groups_2_outlined,label:'Total Students',value:'1,248',delta:'+12%',tone:_blue),
        KpiCard(icon:Icons.event_available_outlined,label:'Attendance Today',value:'92%',delta:'+3%',tone:_green),
        KpiCard(icon:Icons.account_balance_wallet_outlined,label:'Fee Collection',value:'PKR 1.84M',delta:'+18%',tone:_violet),
        KpiCard(icon:Icons.error_outline_rounded,label:'Outstanding Fees',value:'PKR 628K',delta:'+6%',tone:_red),
      ]),
      const SizedBox(height:16),
      SectionCard(title:'Revenue vs Expenses',subtitle:'Monthly comparison',trailing:'Jan – Jun',child:const SizedBox(height:190,child:RevenueChart())),
      const SizedBox(height:14),
      SectionCard(title:'Attendance Trend',subtitle:'Daily attendance this week',trailing:'Last 7 days',child:const SizedBox(height:170,child:AttendanceBars())),
      const SizedBox(height:14),
      const NeedsAttention(),
      const SizedBox(height:14),
      const AiInsightCard(),
      const SizedBox(height:14),
      const UpcomingEvents(),
      const SizedBox(height:14),
      const QuickActions(),
    ]));
  }
}

class KpiCard extends StatelessWidget { final IconData icon; final String label,value,delta; final Color tone; const KpiCard({super.key,required this.icon,required this.label,required this.value,required this.delta,required this.tone}); @override Widget build(BuildContext context){return Container(padding:const EdgeInsets.all(15),decoration:cardDecoration(context),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[Container(width:38,height:38,decoration:BoxDecoration(color:tone.withOpacity(.1),borderRadius:BorderRadius.circular(12)),child:Icon(icon,color:tone,size:21)),const Spacer(),Text(delta,style:TextStyle(color:delta.startsWith('+')?_green:_red,fontSize:11.5,fontWeight:FontWeight.w700))]),const Spacer(),Text(label,style:TextStyle(color:Theme.of(context).colorScheme.onSurfaceVariant,fontSize:12)),const SizedBox(height:3),FittedBox(fit:BoxFit.scaleDown,alignment:Alignment.centerLeft,child:Text(value,style:const TextStyle(fontSize:22,fontWeight:FontWeight.w700,letterSpacing:-.6)))]));} }

BoxDecoration cardDecoration(BuildContext context)=>BoxDecoration(color:Theme.of(context).colorScheme.surface,borderRadius:BorderRadius.circular(20),border:Border.all(color:Theme.of(context).dividerColor.withOpacity(.28)),boxShadow:[BoxShadow(color:Colors.black.withOpacity(Theme.of(context).brightness==Brightness.dark?0:.025),blurRadius:20,offset:const Offset(0,8))]);

class SectionCard extends StatelessWidget { final String title,subtitle,trailing; final Widget child; const SectionCard({super.key,required this.title,required this.subtitle,required this.trailing,required this.child}); @override Widget build(BuildContext context)=>Container(padding:const EdgeInsets.all(18),decoration:cardDecoration(context),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:Theme.of(context).textTheme.titleLarge),const SizedBox(height:2),Text(subtitle,style:TextStyle(fontSize:12,color:Theme.of(context).colorScheme.onSurfaceVariant))])),Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:7),decoration:BoxDecoration(borderRadius:BorderRadius.circular(10),border:Border.all(color:Theme.of(context).dividerColor.withOpacity(.5))),child:Text(trailing,style:const TextStyle(fontSize:11.5,fontWeight:FontWeight.w600)))]),const SizedBox(height:16),child])); }

class RevenueChart extends StatefulWidget { const RevenueChart({super.key}); @override State<RevenueChart> createState()=>_RevenueChartState(); }
class _RevenueChartState extends State<RevenueChart> with SingleTickerProviderStateMixin { late final AnimationController a=AnimationController(vsync:this,duration:const Duration(milliseconds:950))..forward(); @override void dispose(){a.dispose();super.dispose();} @override Widget build(BuildContext context)=>AnimatedBuilder(animation:a,builder:(_,__)=>CustomPaint(painter:RevenuePainter(progress:Curves.easeOutCubic.transform(a.value),dark:Theme.of(context).brightness==Brightness.dark),child:const SizedBox.expand())); }
class RevenuePainter extends CustomPainter { final double progress; final bool dark; RevenuePainter({required this.progress,required this.dark}); @override void paint(Canvas c,Size s){final grid=Paint()..color=(dark?Colors.white:Colors.black).withOpacity(.07)..strokeWidth=1; const left=42.0,bottom=26.0,top=8.0; final w=s.width-left-8,h=s.height-top-bottom; for(int i=0;i<5;i++){final y=top+h*i/4;c.drawLine(Offset(left,y),Offset(s.width,y),grid); final label=['2.5M','2M','1.5M','1M','500K'][i]; _text(c,label,Offset(0,y-7),dark?Colors.white60:const Color(0xFF73809A),10);} final months=['Jan','Feb','Mar','Apr','May','Jun']; for(int i=0;i<months.length;i++){_text(c,months[i],Offset(left+w*i/5-10,s.height-18),dark?Colors.white60:const Color(0xFF73809A),10);} final rev=[.22,.38,.51,.72,.63,.87], exp=[.12,.24,.3,.43,.35,.49]; drawLine(c,s,left,top,w,h,rev,_blue,progress); drawLine(c,s,left,top,w,h,exp,_violet,progress); }
void drawLine(Canvas c,Size s,double left,double top,double w,double h,List<double> vals,Color color,double p){final path=Path(); for(int i=0;i<vals.length;i++){final x=left+w*i/(vals.length-1), y=top+h*(1-vals[i]*p); if(i==0)path.moveTo(x,y); else path.lineTo(x,y);} c.drawPath(path,Paint()..color=color..strokeWidth=2.6..style=PaintingStyle.stroke..strokeCap=StrokeCap.round..strokeJoin=StrokeJoin.round); for(int i=0;i<vals.length;i++){final x=left+w*i/(vals.length-1),y=top+h*(1-vals[i]*p); c.drawCircle(Offset(x,y),3.5,Paint()..color=color);c.drawCircle(Offset(x,y),2,Paint()..color=Colors.white);} }
void _text(Canvas c,String t,Offset o,Color color,double size){final tp=TextPainter(text:TextSpan(text:t,style:TextStyle(color:color,fontSize:size,fontWeight:FontWeight.w500)),textDirection:TextDirection.ltr)..layout();tp.paint(c,o);} @override bool shouldRepaint(covariant RevenuePainter old)=>old.progress!=progress||old.dark!=dark; }

class AttendanceBars extends StatefulWidget { const AttendanceBars({super.key}); @override State<AttendanceBars> createState()=>_AttendanceBarsState(); }
class _AttendanceBarsState extends State<AttendanceBars> with SingleTickerProviderStateMixin { late final AnimationController a=AnimationController(vsync:this,duration:const Duration(milliseconds:850))..forward(); @override void dispose(){a.dispose();super.dispose();} @override Widget build(BuildContext context)=>AnimatedBuilder(animation:a,builder:(_,__)=>CustomPaint(painter:BarsPainter(p:Curves.easeOut.transform(a.value),dark:Theme.of(context).brightness==Brightness.dark))); }
class BarsPainter extends CustomPainter { final double p; final bool dark; BarsPainter({required this.p,required this.dark}); @override void paint(Canvas c,Size s){final vals=[88,92,90,94,92,89,91],days=['M','T','W','T','F','S','S']; final gap=10.0,bw=(s.width-gap*8)/7; for(int i=0;i<7;i++){final h=(s.height-38)*vals[i]/100*p;final x=gap+(bw+gap)*i, y=s.height-25-h; final r=RRect.fromRectAndRadius(Rect.fromLTWH(x,y,bw,h),const Radius.circular(7)); c.drawRRect(r,Paint()..shader=const LinearGradient(colors:[Color(0xFF66AEFF),_blue],begin:Alignment.topCenter,end:Alignment.bottomCenter).createShader(r.outerRect)); _txt(c,'${vals[i]}%',Offset(x,y-17),dark?Colors.white: _navy,10); _txt(c,days[i],Offset(x+bw/2-3,s.height-16),dark?Colors.white60:const Color(0xFF7A879F),10);} }
void _txt(Canvas c,String t,Offset o,Color color,double size){final tp=TextPainter(text:TextSpan(text:t,style:TextStyle(color:color,fontSize:size,fontWeight:FontWeight.w600)),textDirection:TextDirection.ltr)..layout();tp.paint(c,o);} @override bool shouldRepaint(covariant BarsPainter old)=>old.p!=p||old.dark!=dark; }

class NeedsAttention extends StatelessWidget { const NeedsAttention({super.key}); @override Widget build(BuildContext context)=>_Panel(title:'Needs attention today',icon:Icons.error_outline_rounded,iconColor:_red,children:const[_MiniRow(icon:Icons.payments_outlined,color:_red,value:'12',title:'Students with overdue fees',subtitle:'PKR 240,000 pending'),_MiniRow(icon:Icons.person_off_outlined,color:_amber,value:'8',title:'Students absent today',subtitle:'Follow-up recommended'),_MiniRow(icon:Icons.approval_outlined,color:_violet,value:'6',title:'Pending approvals',subtitle:'Leave / documents / applications')]); }
class AiInsightCard extends StatelessWidget { const AiInsightCard({super.key}); @override Widget build(BuildContext context)=>_Panel(title:'AI insights',icon:Icons.auto_awesome_rounded,iconColor:_violet,children:const[_Insight(title:'Attendance improved by 5%',subtitle:"This week's average is 92%, compared with 87% last week.",color:_green),_Insight(title:'Fee collection is 18% higher',subtitle:'You are on track to meet this term’s collection target.',color:_violet)]); }
class UpcomingEvents extends StatelessWidget { const UpcomingEvents({super.key}); @override Widget build(BuildContext context)=>_Panel(title:'Upcoming events',icon:Icons.event_outlined,iconColor:_blue,children:const[_Event(date:'24 Apr',title:'Parent Teacher Meeting',time:'10:00 AM – 12:00 PM'),_Event(date:'26 Apr',title:'Inter-School Science Exhibition',time:'9:00 AM – 4:00 PM'),_Event(date:'30 Apr',title:'Monthly Fee Submission Deadline',time:'All day')]); }
class QuickActions extends StatelessWidget { const QuickActions({super.key}); @override Widget build(BuildContext context)=>_Panel(title:'Quick actions',icon:Icons.bolt_rounded,iconColor:_blue,children:[GridView.count(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),crossAxisCount:2,crossAxisSpacing:10,mainAxisSpacing:10,childAspectRatio:2.4,children:[_Action(label:'Add student',icon:Icons.person_add_alt_1_outlined,color:_blue),_Action(label:'Collect fee',icon:Icons.credit_card_outlined,color:_green),_Action(label:'Attendance',icon:Icons.fact_check_outlined,color:_violet),_Action(label:'Send notice',icon:Icons.campaign_outlined,color:_amber)])]); }
class _Panel extends StatelessWidget { final String title; final IconData icon; final Color iconColor; final List<Widget> children; const _Panel({required this.title,required this.icon,required this.iconColor,required this.children}); @override Widget build(BuildContext context)=>Container(padding:const EdgeInsets.all(18),decoration:cardDecoration(context),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[Icon(icon,color:iconColor,size:20),const SizedBox(width:8),Text(title,style:Theme.of(context).textTheme.titleLarge)]),const SizedBox(height:12),...children])); }
class _MiniRow extends StatelessWidget {final IconData icon;final Color color;final String value,title,subtitle;const _MiniRow({required this.icon,required this.color,required this.value,required this.title,required this.subtitle});@override Widget build(BuildContext context)=>Padding(padding:const EdgeInsets.symmetric(vertical:9),child:Row(children:[Container(width:38,height:38,decoration:BoxDecoration(color:color.withOpacity(.09),borderRadius:BorderRadius.circular(11)),child:Icon(icon,color:color,size:20)),const SizedBox(width:11),SizedBox(width:32,child:Text(value,style:TextStyle(color:color,fontWeight:FontWeight.w700,fontSize:18))),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontWeight:FontWeight.w600,fontSize:13)),const SizedBox(height:2),Text(subtitle,style:TextStyle(fontSize:11.5,color:Theme.of(context).colorScheme.onSurfaceVariant))]))]));}
class _Insight extends StatelessWidget {final String title,subtitle;final Color color;const _Insight({required this.title,required this.subtitle,required this.color});@override Widget build(BuildContext context)=>Container(margin:const EdgeInsets.only(bottom:9),padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:color.withOpacity(.055),borderRadius:BorderRadius.circular(14)),child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[Icon(Icons.trending_up_rounded,color:color),const SizedBox(width:10),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontWeight:FontWeight.w700,fontSize:13)),const SizedBox(height:3),Text(subtitle,style:TextStyle(fontSize:11.8,height:1.35,color:Theme.of(context).colorScheme.onSurfaceVariant))]))]));}
class _Event extends StatelessWidget {final String date,title,time;const _Event({required this.date,required this.title,required this.time});@override Widget build(BuildContext context)=>Padding(padding:const EdgeInsets.symmetric(vertical:9),child:Row(children:[Container(width:48,padding:const EdgeInsets.symmetric(vertical:8),decoration:BoxDecoration(color:_blue.withOpacity(.08),borderRadius:BorderRadius.circular(12)),child:Center(child:Text(date.replaceAll(' ','\n'),textAlign:TextAlign.center,style:const TextStyle(color:_blue,fontWeight:FontWeight.w700,fontSize:11)))),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontWeight:FontWeight.w600,fontSize:13)),const SizedBox(height:2),Text(time,style:TextStyle(fontSize:11.5,color:Theme.of(context).colorScheme.onSurfaceVariant))]))]));}
class _Action extends StatelessWidget {final String label;final IconData icon;final Color color;const _Action({required this.label,required this.icon,required this.color});@override Widget build(BuildContext context)=>InkWell(borderRadius:BorderRadius.circular(14),onTap:(){},child:Container(padding:const EdgeInsets.symmetric(horizontal:12),decoration:BoxDecoration(color:color.withOpacity(.07),borderRadius:BorderRadius.circular(14)),child:Row(children:[Icon(icon,color:color,size:19),const SizedBox(width:8),Expanded(child:Text(label,style:const TextStyle(fontWeight:FontWeight.w600,fontSize:12.2)))])));}

class StudentsScreen extends StatefulWidget {final AppController controller;const StudentsScreen({super.key,required this.controller});@override State<StudentsScreen> createState()=>_StudentsScreenState();}
class _StudentsScreenState extends State<StudentsScreen>{String grade='All';String fee='All';@override Widget build(BuildContext context){final q=widget.controller.search.toLowerCase();final list=widget.controller.students.where((s)=>(q.isEmpty||('${s.name} ${s.id} ${s.guardian}'.toLowerCase().contains(q)))&&(grade=='All'||s.grade==grade)&&(fee=='All'||s.fee==fee)).toList();return Column(children:[Padding(padding:const EdgeInsets.fromLTRB(18,16,18,10),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Students',style:Theme.of(context).textTheme.headlineMedium),const SizedBox(height:3),Text('Manage student information and records.',style:TextStyle(color:Theme.of(context).colorScheme.onSurfaceVariant,fontSize:12.5))])),FilledButton.icon(onPressed:()=>_showAdd(context),icon:const Icon(Icons.add),label:const Text('Add'))]),const SizedBox(height:14),TextField(onChanged:widget.controller.setSearch,decoration:const InputDecoration(prefixIcon:Icon(Icons.search_rounded),hintText:'Search by name, ID or guardian...')),const SizedBox(height:10),Row(children:[Expanded(child:_Drop(value:grade,items:const['All','Grade 10','Grade 9','Grade 8','Grade 7'],onChanged:(v)=>setState(()=>grade=v))),const SizedBox(width:10),Expanded(child:_Drop(value:fee,items:const['All','Paid','Pending','Overdue'],onChanged:(v)=>setState(()=>fee=v)))]),const SizedBox(height:8),Text('${list.length} students',style:TextStyle(fontSize:12,color:Theme.of(context).colorScheme.onSurfaceVariant))])),Expanded(child:list.isEmpty?const Center(child:Text('No students found')):ListView.separated(padding:const EdgeInsets.fromLTRB(18,4,18,110),itemCount:list.length,separatorBuilder:(_,__)=>const SizedBox(height:8),itemBuilder:(_,i)=>StudentCard(student:list[i],onDelete:()=>_confirmDelete(context,list[i]))))]);}
void _showAdd(BuildContext context){showModalBottomSheet(context:context,isScrollControlled:true,showDragHandle:true,builder:(ctx)=>AddStudentSheet(onAdd:widget.controller.addStudent));}
void _confirmDelete(BuildContext context,Student s){showDialog(context:context,builder:(ctx)=>AlertDialog(title:const Text('Delete student?'),content:Text('Remove ${s.name} from the demo?'),actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('Cancel')),FilledButton(onPressed:(){widget.controller.deleteStudent(s.id);Navigator.pop(ctx);},style:FilledButton.styleFrom(backgroundColor:_red),child:const Text('Delete'))]));}}
class _Drop extends StatelessWidget {final String value;final List<String> items;final ValueChanged<String> onChanged;const _Drop({required this.value,required this.items,required this.onChanged});@override Widget build(BuildContext context)=>DropdownButtonFormField<String>(value:value,isExpanded:true,decoration:const InputDecoration(contentPadding:EdgeInsets.symmetric(horizontal:14,vertical:12)),items:items.map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),onChanged:(v){if(v!=null)onChanged(v);} );}
class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback onDelete;
  const StudentCard({super.key, required this.student, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final feeColor = student.fee == 'Paid' ? _green : student.fee == 'Overdue' ? _red : _amber;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: cardDecoration(context),
      child: Row(
        children: [
          CircleAvatar(radius: 26, backgroundImage: AssetImage(student.image)),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(student.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: feeColor.withOpacity(.1), borderRadius: BorderRadius.circular(999)),
                      child: Text(student.fee, style: TextStyle(color: feeColor, fontWeight: FontWeight.w700, fontSize: 10.5)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('${student.id}  •  ${student.grade} ${student.section}', style: TextStyle(fontSize: 11.5, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Guardian', style: TextStyle(fontSize: 10.5, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                          Text(student.guardian, style: const TextStyle(fontSize: 12.2, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${student.attendance}% attendance', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 3),
                        SizedBox(
                          width: 90,
                          child: LinearProgressIndicator(
                            value: student.attendance / 100,
                            minHeight: 5,
                            borderRadius: BorderRadius.circular(99),
                            color: _green,
                            backgroundColor: _green.withOpacity(.1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (v) { if (v == 'delete') onDelete(); },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'profile', child: ListTile(leading: Icon(Icons.person_outline), title: Text('View profile'), contentPadding: EdgeInsets.zero)),
              PopupMenuItem(value: 'attendance', child: ListTile(leading: Icon(Icons.fact_check_outlined), title: Text('Attendance'), contentPadding: EdgeInsets.zero)),
              PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete_outline, color: _red), title: Text('Delete', style: TextStyle(color: _red)), contentPadding: EdgeInsets.zero)),
            ],
          ),
        ],
      ),
    );
  }
}

class AddStudentSheet extends StatefulWidget{final ValueChanged<Student> onAdd;const AddStudentSheet({super.key,required this.onAdd});@override State<AddStudentSheet> createState()=>_AddStudentSheetState();}
class _AddStudentSheetState extends State<AddStudentSheet>{final name=TextEditingController(),guardian=TextEditingController();String grade='Grade 7';@override Widget build(BuildContext context)=>Padding(padding:EdgeInsets.fromLTRB(20,0,20,20+MediaQuery.viewInsetsOf(context).bottom),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Add student',style:Theme.of(context).textTheme.headlineMedium),const SizedBox(height:18),TextField(controller:name,decoration:const InputDecoration(labelText:'Student name')),const SizedBox(height:12),TextField(controller:guardian,decoration:const InputDecoration(labelText:'Guardian name')),const SizedBox(height:12),DropdownButtonFormField<String>(value:grade,decoration:const InputDecoration(labelText:'Grade'),items:['Grade 10','Grade 9','Grade 8','Grade 7'].map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),onChanged:(v)=>setState(()=>grade=v??grade)),const SizedBox(height:18),SizedBox(width:double.infinity,height:50,child:FilledButton(onPressed:(){if(name.text.trim().isEmpty)return;widget.onAdd(Student(id:'STU${1000+math.Random().nextInt(800)}',name:name.text.trim(),grade:grade,section:'A',guardian:guardian.text.trim().isEmpty?'Guardian':guardian.text.trim(),attendance:95,fee:'Pending',image:'assets/images/student-08.jpg'));Navigator.pop(context);},child:const Text('Add student')))]));}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final status = <String, String>{};

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 110),
      children: [
        Text('Attendance', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text('Track and manage daily student attendance.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 16),
        const Row(
          children: [
            Expanded(child: _StatSmall(label: 'Present', value: '38', color: _green)),
            SizedBox(width: 10),
            Expanded(child: _StatSmall(label: 'Absent', value: '3', color: _red)),
            SizedBox(width: 10),
            Expanded(child: _StatSmall(label: 'Late', value: '1', color: _amber)),
          ],
        ),
        const SizedBox(height: 14),
        const SectionCard(
          title: 'Attendance trend',
          subtitle: 'Last 14 days',
          trailing: 'Class 10 – A',
          child: SizedBox(height: 180, child: AttendanceBars()),
        ),
        const SizedBox(height: 14),
        ...demoStudents.take(8).map((s) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: cardDecoration(context),
          child: Row(
            children: [
              CircleAvatar(backgroundImage: AssetImage(s.image)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(s.id, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              SegmentedButton<String>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: 'P', label: Text('P')),
                  ButtonSegment(value: 'A', label: Text('A')),
                  ButtonSegment(value: 'L', label: Text('L')),
                ],
                selected: {status[s.id] ?? 'P'},
                onSelectionChanged: (v) => setState(() => status[s.id] = v.first),
              ),
            ],
          ),
        )),
      ],
    );
  }
}

class _StatSmall extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatSmall({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: cardDecoration(context),
    child: Column(children: [
      Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w700)),
      const SizedBox(height: 3),
      Text(label, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
    ]),
  );
}

class FinanceScreen extends StatelessWidget{const FinanceScreen({super.key});@override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.fromLTRB(18,16,18,110),children:[Row(children:[Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Fees & Finance',style:Theme.of(context).textTheme.headlineMedium),const SizedBox(height:3),Text('Collection, dues and school finance.',style:TextStyle(color:Theme.of(context).colorScheme.onSurfaceVariant))])),FilledButton.icon(onPressed:(){},icon:const Icon(Icons.add),label:const Text('Collect'))]),const SizedBox(height:16),const Row(children:[Expanded(child:_FinanceMetric(label:'Collected',value:'PKR 1.84M',color:_green)),SizedBox(width:10),Expanded(child:_FinanceMetric(label:'Outstanding',value:'PKR 628K',color:_red))]),const SizedBox(height:10),const Row(children:[Expanded(child:_FinanceMetric(label:'Overdue',value:'PKR 214K',color:_amber)),SizedBox(width:10),Expanded(child:_FinanceMetric(label:'Monthly revenue',value:'PKR 482K',color:_violet))]),const SizedBox(height:14),SectionCard(title:'Monthly fee collections',subtitle:'Collected vs outstanding',trailing:'Jan – Jun',child:const SizedBox(height:190,child:RevenueChart())),const SizedBox(height:14),Text('Recent invoices',style:Theme.of(context).textTheme.titleLarge),const SizedBox(height:10),...demoStudents.take(7).map((s){final overdue=s.fee=='Overdue';return Container(margin:const EdgeInsets.only(bottom:8),padding:const EdgeInsets.all(13),decoration:cardDecoration(context),child:Row(children:[CircleAvatar(radius:21,backgroundImage:AssetImage(s.image)),const SizedBox(width:10),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(s.name,style:const TextStyle(fontWeight:FontWeight.w600)),Text('${s.id} • ${s.grade}',style:TextStyle(fontSize:11,color:Theme.of(context).colorScheme.onSurfaceVariant))])),Column(crossAxisAlignment:CrossAxisAlignment.end,children:[Text(overdue?'PKR 45,000':'PKR 38,000',style:const TextStyle(fontWeight:FontWeight.w700)),Text(s.fee,style:TextStyle(fontSize:11,color:overdue?_red:s.fee=='Paid'?_green:_amber,fontWeight:FontWeight.w600))]) ]));})]);}
class _FinanceMetric extends StatelessWidget{final String label,value;final Color color;const _FinanceMetric({required this.label,required this.value,required this.color});@override Widget build(BuildContext context)=>Container(padding:const EdgeInsets.all(14),decoration:cardDecoration(context),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Container(width:34,height:34,decoration:BoxDecoration(color:color.withOpacity(.1),borderRadius:BorderRadius.circular(10)),child:Icon(Icons.payments_outlined,color:color,size:19)),const SizedBox(height:10),Text(label,style:TextStyle(fontSize:11.5,color:Theme.of(context).colorScheme.onSurfaceVariant)),const SizedBox(height:3),FittedBox(child:Text(value,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w700))) ]));}

class MoreScreen extends StatelessWidget{final AppController controller;const MoreScreen({super.key,required this.controller});@override Widget build(BuildContext context){final items=[('Admissions',Icons.person_add_alt_outlined,_blue),('Academics',Icons.menu_book_outlined,_violet),('Staff',Icons.badge_outlined,_green),('Communication',Icons.forum_outlined,_amber),('Reports & Analytics',Icons.query_stats_outlined,_blue),('Library',Icons.local_library_outlined,_violet),('Transport',Icons.directions_bus_outlined,_green),('Inventory',Icons.inventory_2_outlined,_amber),('Events',Icons.event_note_outlined,_blue),('Settings',Icons.settings_outlined,Colors.blueGrey)];return ListView(padding:const EdgeInsets.fromLTRB(18,16,18,110),children:[Text('More',style:Theme.of(context).textTheme.headlineMedium),const SizedBox(height:4),Text('Explore the rest of Scholentra.',style:TextStyle(color:Theme.of(context).colorScheme.onSurfaceVariant)),const SizedBox(height:18),GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:items.length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:12,mainAxisSpacing:12,childAspectRatio:1.25),itemBuilder:(_,i){final x=items[i];return InkWell(borderRadius:BorderRadius.circular(20),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>GenericModuleScreen(title:x.$1,icon:x.$2,color:x.$3))),child:Container(padding:const EdgeInsets.all(16),decoration:cardDecoration(context),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Container(width:42,height:42,decoration:BoxDecoration(color:x.$3.withOpacity(.1),borderRadius:BorderRadius.circular(13)),child:Icon(x.$2,color:x.$3)),const Spacer(),Text(x.$1,style:const TextStyle(fontWeight:FontWeight.w700,fontSize:14)),const SizedBox(height:3),Text('Open module',style:TextStyle(fontSize:11.5,color:Theme.of(context).colorScheme.onSurfaceVariant))])));}),const SizedBox(height:16),ListTile(shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(18)),tileColor:Theme.of(context).colorScheme.surface,leading:const Icon(Icons.logout_rounded,color:_red),title:const Text('Sign out'),onTap:controller.logout)]);}}
class GenericModuleScreen extends StatelessWidget{final String title;final IconData icon;final Color color;const GenericModuleScreen({super.key,required this.title,required this.icon,required this.color});@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:Text(title)),body:ListView(padding:const EdgeInsets.all(18),children:[Container(height:140,padding:const EdgeInsets.all(20),decoration:BoxDecoration(gradient:LinearGradient(colors:[color.withOpacity(.15),color.withOpacity(.04)]),borderRadius:BorderRadius.circular(24)),child:Row(children:[Container(width:58,height:58,decoration:BoxDecoration(color:color.withOpacity(.12),borderRadius:BorderRadius.circular(18)),child:Icon(icon,color:color,size:28)),const SizedBox(width:16),Expanded(child:Column(mainAxisAlignment:MainAxisAlignment.center,crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:Theme.of(context).textTheme.headlineMedium),const SizedBox(height:5),Text('Interactive Scholentra demo module',style:TextStyle(color:Theme.of(context).colorScheme.onSurfaceVariant))]))])),const SizedBox(height:16),const Row(children:[Expanded(child:_StatSmall(label:'Active',value:'248',color:_blue)),SizedBox(width:10),Expanded(child:_StatSmall(label:'Pending',value:'18',color:_amber)),SizedBox(width:10),Expanded(child:_StatSmall(label:'Today',value:'32',color:_green))]),const SizedBox(height:14),SectionCard(title:'Overview',subtitle:'Recent activity and trends',trailing:'This month',child:const SizedBox(height:180,child:RevenueChart())),const SizedBox(height:14),...List.generate(5,(i)=>Container(margin:const EdgeInsets.only(bottom:8),padding:const EdgeInsets.all(14),decoration:cardDecoration(context),child:ListTile(contentPadding:EdgeInsets.zero,leading:CircleAvatar(backgroundColor:color.withOpacity(.1),child:Icon(icon,color:color,size:18)),title:Text('$title item ${i+1}',style:const TextStyle(fontWeight:FontWeight.w600)),subtitle:const Text('Sample data • Updated recently'),trailing:const Icon(Icons.chevron_right_rounded))))]));}

class AiFab extends StatefulWidget {
  const AiFab({super.key});
  @override
  State<AiFab> createState() => _AiFabState();
}

class _AiFabState extends State<AiFab> {
  @override
  Widget build(BuildContext context) => FloatingActionButton(
    onPressed: () => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const AiSheet(),
    ),
    backgroundColor: _violet,
    foregroundColor: Colors.white,
    child: const Icon(Icons.auto_awesome_rounded),
  );
}

class AiSheet extends StatefulWidget {
  const AiSheet({super.key});
  @override
  State<AiSheet> createState() => _AiSheetState();
}

class _AiSheetState extends State<AiSheet> {
  final input = TextEditingController();
  final messages = <String>[
    'Hi, I’m Scholentra AI. Ask about fees, attendance, students or school performance.'
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .72,
      child: Padding(
        padding: EdgeInsets.fromLTRB(18, 0, 18, 16 + MediaQuery.viewInsetsOf(context).bottom),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [_blue, _violet]),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
                ),
                const SizedBox(width: 11),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Scholentra AI', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
                      Text('School intelligence assistant', style: TextStyle(fontSize: 11.5)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (_, i) => Align(
                  alignment: i == 0 ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 310),
                    decoration: BoxDecoration(
                      color: i == 0 ? _violet.withOpacity(.08) : _blue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      messages[i],
                      style: TextStyle(
                        color: i == 0 ? Theme.of(context).colorScheme.onSurface : Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: input,
                    decoration: const InputDecoration(hintText: 'Ask Scholentra AI...'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: () {
                    final q = input.text.trim();
                    if (q.isEmpty) return;
                    setState(() {
                      messages.add(q);
                      messages.add(
                        q.toLowerCase().contains('fee')
                            ? 'Fee collection this month is PKR 1.84M, up 18%. Outstanding fees are PKR 628K.'
                            : q.toLowerCase().contains('attendance')
                                ? 'Attendance today is 92%. Eight students require follow-up.'
                                : 'I found the relevant demo data. Open the related module for detailed records.',
                      );
                    });
                    input.clear();
                  },
                  icon: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Student {final String id,name,grade,section,guardian,fee,image;final int attendance;const Student({required this.id,required this.name,required this.grade,required this.section,required this.guardian,required this.attendance,required this.fee,required this.image});}
const demoStudents=[
Student(id:'STU001',name:'Aarav Sharma',grade:'Grade 10',section:'A',guardian:'Rajesh Sharma',attendance:96,fee:'Paid',image:'assets/images/student-01.png'),
Student(id:'STU002',name:'Diya Patel',grade:'Grade 10',section:'A',guardian:'Meera Patel',attendance:92,fee:'Pending',image:'assets/images/student-02.png'),
Student(id:'STU003',name:'Rohan Mehta',grade:'Grade 9',section:'B',guardian:'Amit Mehta',attendance:88,fee:'Paid',image:'assets/images/student-03.png'),
Student(id:'STU004',name:'Kiara Nair',grade:'Grade 9',section:'B',guardian:'Suresh Nair',attendance:94,fee:'Paid',image:'assets/images/student-04.jpg'),
Student(id:'STU005',name:'Vivaan Singh',grade:'Grade 8',section:'A',guardian:'Pooja Singh',attendance:90,fee:'Overdue',image:'assets/images/student-05.jpg'),
Student(id:'STU006',name:'Ananya Reddy',grade:'Grade 8',section:'A',guardian:'Kiran Reddy',attendance:87,fee:'Paid',image:'assets/images/student-06.jpg'),
Student(id:'STU007',name:'Ishaan Khan',grade:'Grade 7',section:'C',guardian:'Imran Khan',attendance:91,fee:'Pending',image:'assets/images/student-07.jpg'),
Student(id:'STU008',name:'Myra Verma',grade:'Grade 7',section:'C',guardian:'Neha Verma',attendance:89,fee:'Paid',image:'assets/images/student-08.jpg'),
];
