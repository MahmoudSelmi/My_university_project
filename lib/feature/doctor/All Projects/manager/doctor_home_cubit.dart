import 'package:flutter_bloc/flutter_bloc.dart';
import 'doctor_home_states.dart';

class DoctorHomeCubit extends Cubit<DoctorHomeStates> {
  // لستة المشاريع النشطة
  List<Map<String, dynamic>> activeProjects = [
    {
      "title": "E-Commerce Platform",
      "leader": "محمود سلمي",
      "desc": "نظام دفع آمن وإدارة مخزون متكاملة.",
      "members": ["محمود سلمي", "عبادي", "عبد الله أنور"],
    },
  ];

  // لستة طلبات الإشراف (الـ 10 اللي اتفقنا عليهم)
  List<Map<String, dynamic>> pendingRequestsList = [
    {
      "title": "Smart City IoT",
      "leader": "أحمد حسن",
      "desc": "نظام ذكي لإدارة أعمدة الإنارة.",
    },
    {
      "title": "Tele-Medicine App",
      "leader": "إبراهيم عادل",
      "desc": "تطبيق لربط المرضى بالأطباء.",
    },
    {
      "title": "Blockchain Voting",
      "leader": "ياسين حسن",
      "desc": "نظام تصويت إلكتروني آمن.",
    },
    {
      "title": "AR Museum Guide",
      "leader": "ليلى إبراهيم",
      "desc": "دليل سياحي للمتاحف بالواقع المعزز.",
    },
    {
      "title": "Cyber Security Suite",
      "leader": "مريم يوسف",
      "desc": "أداة لاكتشاف الثغرات في الشبكات.",
    },
    {
      "title": "Green Energy Tracker",
      "leader": "خالد منصور",
      "desc": "مراقبة إنتاج الطاقة الشمسية.",
    },
    {
      "title": "Food Waste Reducer",
      "leader": "سارة أحمد",
      "desc": "منصة لربط المطاعم بالجمعيات الخيرية.",
    },
    {
      "title": "Auto Attendance",
      "leader": "عمر فاروق",
      "desc": "تسجيل حضور الطلاب بالتعرف على الوجوه.",
    },
    {
      "title": "Stock Predictor",
      "leader": "نور الشريف",
      "desc": "استخدام الـ ML للتنبؤ بأسعار الأسهم.",
    },
    {
      "title": "Blind Assistant",
      "leader": "هاني رمزي",
      "desc": "تطبيق يساعد المكفوفين عبر الكاميرا.",
    },
  ];

  // أول ما الكيوبيت يفتح، يبعت الداتا فوراً
  DoctorHomeCubit() : super(DoctorHomeInitial()) {
    getHomeData();
  }

  static DoctorHomeCubit get(context) => BlocProvider.of(context);

  void getHomeData() {
    // بنبعت الحالة Success فوراً بالداتا اللي فوق
    emit(
      DoctorHomeSuccess(List.from(activeProjects), {
        "totalProjects": activeProjects.length,
        "pendingActions": pendingRequestsList.length,
      }, pendingRequests: List.from(pendingRequestsList)),
    );
  }

  void acceptRequest(int index) {
    var p = pendingRequestsList.removeAt(index);
    activeProjects.add({
      ...p,
      "members": ["محمود سلمي", "عضو جديد 1", "عضو جديد 2"],
    });
    getHomeData(); // تحديث البيانات في كل الصفحات
  }

  void rejectRequest(int index) {
    pendingRequestsList.removeAt(index);
    getHomeData();
  }
}
