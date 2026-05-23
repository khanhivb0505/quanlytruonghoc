// =============================================
// BÀI TẬP: HỆ THỐNG QUẢN LÝ TRƯỜNG HỌC
// Viết theo kiểu dễ hiểu cho người mới học Dart
// =============================================

import 'dart:io';

// ----- Lớp cha Person -----
class Person {
  String id;
  String name;
  int age;
  String gender;

  Person(this.id, this.name, this.age, this.gender);
}

// ----- Lớp Student kế thừa Person -----
class Student extends Person {
  String grade; // lớp học (vd: 10A1)

  // Mỗi lớp chỉ có 1 điểm -> dùng 2 danh sách song song
  List<String> idLopDaNhapDiem = [];
  List<double> diemCacLop = [];

  Student(String id, String name, int age, String gender, this.grade)
      : super(id, name, age, gender);

  // Kiểm tra học sinh có trong lớp không
  bool coTrongLop(Classroom lop) {
    for (int i = 0; i < lop.students.length; i++) {
      if (lop.students[i].id == id) {
        return true;
      }
    }
    return false;
  }

  // Nhập 1 điểm cho 1 lớp (mỗi lớp chỉ nhập 1 lần)
  bool nhapDiem(String idLop, double diem) {
    for (int i = 0; i < idLopDaNhapDiem.length; i++) {
      if (idLopDaNhapDiem[i] == idLop) {
        print('Lớp này đã có điểm rồi. Mỗi lớp chỉ nhập 1 điểm.');
        return false;
      }
    }
    idLopDaNhapDiem.add(idLop);
    diemCacLop.add(diem);
    return true;
  }

  // Lấy điểm của học sinh tại 1 lớp
  double? layDiem(String idLop) {
    for (int i = 0; i < idLopDaNhapDiem.length; i++) {
      if (idLopDaNhapDiem[i] == idLop) {
        return diemCacLop[i];
      }
    }
    return null; // chưa có điểm
  }

  // Tính điểm TB = tổng điểm các lớp đã đăng ký / số lớp đã có điểm
  double tinhDiemTrungBinh(List<Classroom> danhSachLop) {
    double tong = 0;
    int dem = 0;

    for (int i = 0; i < danhSachLop.length; i++) {
      if (coTrongLop(danhSachLop[i])) {
        double? diem = layDiem(danhSachLop[i].id);
        if (diem != null) {
          tong = tong + diem;
          dem++;
        }
      }
    }

    if (dem == 0) {
      return 0;
    }
    return tong / dem;
  }

  void hienThi(List<Classroom> danhSachLop) {
    print('--- Thông tin học sinh ---');
    print('ID: $id');
    print('Họ tên: $name');
    print('Tuổi: $age');
    print('Giới tính: $gender');
    print('Lớp học: $grade');

    print('Các lớp đã đăng ký:');
    bool coLop = false;
    for (int i = 0; i < danhSachLop.length; i++) {
      if (coTrongLop(danhSachLop[i])) {
        coLop = true;
        double? diem = layDiem(danhSachLop[i].id);
        if (diem == null) {
          print('  - ${danhSachLop[i].name}: Chưa có điểm');
        } else {
          print('  - ${danhSachLop[i].name}: $diem');
        }
      }
    }
    if (!coLop) {
      print('  (Chưa đăng ký lớp nào)');
    }

    if (idLopDaNhapDiem.isEmpty) {
      print('Điểm trung bình các lớp: Chưa có');
    } else {
      double tb = tinhDiemTrungBinh(danhSachLop);
      print('Điểm trung bình các lớp: ${tb.toStringAsFixed(2)}');
    }
  }
}

// ----- Lớp Teacher kế thừa Person -----
class Teacher extends Person {
  String subject;
  double salary;

  Teacher(
    String id,
    String name,
    int age,
    String gender,
    this.subject,
    this.salary,
  ) : super(id, name, age, gender);

  void hienThi() {
    print('--- Thông tin giáo viên ---');
    print('ID: $id');
    print('Họ tên: $name');
    print('Tuổi: $age');
    print('Giới tính: $gender');
    print('Môn dạy: $subject');
    print('Lương: $salary');
  }
}

// ----- Lớp Classroom -----
class Classroom {
  String id;
  String name;
  List<Student> students = [];
  Teacher? teacher;

  Classroom(this.id, this.name);

  void themHocSinh(Student hs) {
    for (int i = 0; i < students.length; i++) {
      if (students[i].id == hs.id) {
        print('Học sinh ${hs.name} đã có trong lớp $name.');
        return;
      }
    }
    students.add(hs);
    print('Đã thêm ${hs.name} vào lớp $name.');
  }

  void ganGiaoVien(Teacher gv) {
    teacher = gv;
    print('Đã gán ${gv.name} phụ trách lớp $name.');
  }

  // Điểm TB của lớp = tổng điểm học sinh trong lớp / số HS đã có điểm
  double tinhDiemTrungBinhLop() {
    double tong = 0;
    int dem = 0;

    for (int i = 0; i < students.length; i++) {
      double? diem = students[i].layDiem(id);
      if (diem != null) {
        tong = tong + diem;
        dem++;
      }
    }

    if (dem == 0) {
      return 0;
    }
    return tong / dem;
  }

  void hienThi(List<Classroom> danhSachLop) {
    print('');
    print('=== Lớp: $name (ID: $id) ===');

    if (teacher != null) {
      print('Giáo viên: ${teacher!.name} - Môn: ${teacher!.subject}');
    } else {
      print('Giáo viên: Chưa gán');
    }

    print('Số học sinh: ${students.length}');

    if (students.isEmpty) {
      return;
    }

    // Kiểm tra có ai có điểm chưa
    bool coDiem = false;
    for (int i = 0; i < students.length; i++) {
      if (students[i].layDiem(id) != null) {
        coDiem = true;
        break;
      }
    }

    if (coDiem) {
      double tbLop = tinhDiemTrungBinhLop();
      print('Điểm TB lớp: ${tbLop.toStringAsFixed(2)}');
    } else {
      print('Điểm TB lớp: Chưa có');
    }

    print('Danh sách học sinh:');
    for (int i = 0; i < students.length; i++) {
      Student hs = students[i];
      double? diemLop = hs.layDiem(id);
      String diemText = diemLop == null ? 'Chưa có' : diemLop.toString();

      double tbHS = hs.tinhDiemTrungBinh(danhSachLop);
      String tbText = hs.idLopDaNhapDiem.isEmpty ? 'Chưa có' : tbHS.toStringAsFixed(2);

      print('  - ${hs.name} | Điểm lớp: $diemText | ĐTB các lớp: $tbText');
    }
  }
}

// ----- Quản lý trường -----
class School {
  List<Student> students = [];
  List<Teacher> teachers = [];
  List<Classroom> classrooms = [];

  Student? timHocSinhTheoId(String id) {
    for (int i = 0; i < students.length; i++) {
      if (students[i].id == id) {
        return students[i];
      }
    }
    return null;
  }

  // Tìm theo ID hoặc tên
  Student? timHocSinh(String tuKhoa) {
    Student? hs = timHocSinhTheoId(tuKhoa);
    if (hs != null) {
      return hs;
    }

    for (int i = 0; i < students.length; i++) {
      if (students[i].name == tuKhoa) {
        return students[i];
      }
    }
    return null;
  }

  Teacher? timGiaoVien(String id) {
    for (int i = 0; i < teachers.length; i++) {
      if (teachers[i].id == id) {
        return teachers[i];
      }
    }
    return null;
  }

  Classroom? timLop(String id) {
    for (int i = 0; i < classrooms.length; i++) {
      if (classrooms[i].id == id) {
        return classrooms[i];
      }
    }
    return null;
  }

  void ganHocSinhVaoLop(String idHS, String idLop) {
    Student? hs = timHocSinhTheoId(idHS);
    if (hs == null) {
      print('Không tìm thấy học sinh ID: $idHS');
      return;
    }

    Classroom? lop = timLop(idLop);
    if (lop == null) {
      print('Không tìm thấy lớp ID: $idLop');
      return;
    }

    lop.themHocSinh(hs);
  }

  void ganGiaoVienVaoLop(String idGV, String idLop) {
    Teacher? gv = timGiaoVien(idGV);
    if (gv == null) {
      print('Không tìm thấy giáo viên ID: $idGV');
      return;
    }

    Classroom? lop = timLop(idLop);
    if (lop == null) {
      print('Không tìm thấy lớp ID: $idLop');
      return;
    }

    lop.ganGiaoVien(gv);
  }

  void nhapDiemChoLop(String tuKhoa, String idLop) {
    Student? hs = timHocSinh(tuKhoa);
    if (hs == null) {
      print('Không tìm thấy học sinh: $tuKhoa');
      return;
    }

    Classroom? lop = timLop(idLop);
    if (lop == null) {
      print('Không tìm thấy lớp ID: $idLop');
      return;
    }

    if (!hs.coTrongLop(lop)) {
      print('Học sinh chưa đăng ký lớp ${lop.name}');
      return;
    }

    print('');
    print('Nhập điểm cho ${hs.name} - lớp ${lop.name}');
    stdout.write('Nhập điểm (mỗi lớp chỉ 1 điểm): ');
    String? input = stdin.readLineSync();
    double? diem = double.tryParse(input ?? '');

    if (diem == null) {
      print('Điểm không hợp lệ!');
      return;
    }

    bool ok = hs.nhapDiem(idLop, diem);
    if (!ok) {
      return;
    }

    print('Đã nhập điểm $diem cho lớp ${lop.name}');
    double tb = hs.tinhDiemTrungBinh(classrooms);
    print('Điểm TB các lớp đã đăng ký: ${tb.toStringAsFixed(2)}');
  }

  void baoCao() {
    print('');
    print('========== BÁO CÁO ==========');

    if (classrooms.isEmpty) {
      print('Chưa có lớp học.');
      return;
    }

    for (int i = 0; i < classrooms.length; i++) {
      classrooms[i].hienThi(classrooms);
    }

    print('');
    print('--- Điểm TB từng học sinh ---');
    for (int i = 0; i < students.length; i++) {
      Student hs = students[i];
      if (hs.idLopDaNhapDiem.isEmpty) {
        print('${hs.name}: Chưa có');
      } else {
        double tb = hs.tinhDiemTrungBinh(classrooms);
        print('${hs.name}: ${tb.toStringAsFixed(2)}');
      }
    }
  }
}

// =============================================
// HÀM NHẬP DỮ LIỆU
// =============================================

Student nhapHocSinh() {
  print('');
  print('--- Nhập học sinh ---');
  stdout.write('ID: ');
  String id = stdin.readLineSync() ?? '';
  stdout.write('Họ tên: ');
  String name = stdin.readLineSync() ?? '';
  stdout.write('Tuổi: ');
  int age = int.parse(stdin.readLineSync() ?? '0');
  stdout.write('Giới tính: ');
  String gender = stdin.readLineSync() ?? '';
  stdout.write('Lớp học: ');
  String grade = stdin.readLineSync() ?? '';

  return Student(id, name, age, gender, grade);
}

Teacher nhapGiaoVien() {
  print('');
  print('--- Nhập giáo viên ---');
  stdout.write('ID: ');
  String id = stdin.readLineSync() ?? '';
  stdout.write('Họ tên: ');
  String name = stdin.readLineSync() ?? '';
  stdout.write('Tuổi: ');
  int age = int.parse(stdin.readLineSync() ?? '0');
  stdout.write('Giới tính: ');
  String gender = stdin.readLineSync() ?? '';
  stdout.write('Môn dạy: ');
  String subject = stdin.readLineSync() ?? '';
  stdout.write('Lương: ');
  double salary = double.parse(stdin.readLineSync() ?? '0');

  return Teacher(id, name, age, gender, subject, salary);
}

Classroom nhapLop() {
  print('');
  print('--- Nhập lớp học ---');
  stdout.write('ID lớp: ');
  String id = stdin.readLineSync() ?? '';
  stdout.write('Tên lớp: ');
  String name = stdin.readLineSync() ?? '';

  return Classroom(id, name);
}

void hienMenu() {
  print('');
  print('========== MENU ==========');
  print('1. Thêm giáo viên');
  print('2. Thêm học sinh');
  print('3. Thêm lớp học');
  print('4. Gán giáo viên vào lớp');
  print('5. Gán học sinh vào lớp + nhập điểm');
  print('6. Xem thông tin học sinh');
  print('7. Xem thông tin giáo viên');
  print('8. Xem báo cáo');
  print('0. Thoát');
  print('==========================');
}

// =============================================
// HÀM MAIN
// =============================================

void main() {
  School truong = School();

  while (true) {
    hienMenu();
    stdout.write('Chọn: ');
    String? chon = stdin.readLineSync();

    if (chon == '1') {
      Teacher gv = nhapGiaoVien();
      truong.teachers.add(gv);
      print('Đã thêm giáo viên ${gv.name}');
    } else if (chon == '2') {
      Student hs = nhapHocSinh();
      truong.students.add(hs);
      print('Đã thêm học sinh ${hs.name}');
    } else if (chon == '3') {
      Classroom lop = nhapLop();
      truong.classrooms.add(lop);
      print('Đã thêm lớp ${lop.name}');
    } else if (chon == '4') {
      stdout.write('ID giáo viên: ');
      String idGV = stdin.readLineSync() ?? '';
      stdout.write('ID lớp: ');
      String idLop = stdin.readLineSync() ?? '';
      truong.ganGiaoVienVaoLop(idGV, idLop);
    } else if (chon == '5') {
      stdout.write('ID học sinh: ');
      String idHS = stdin.readLineSync() ?? '';
      stdout.write('ID lớp: ');
      String idLop = stdin.readLineSync() ?? '';
      truong.ganHocSinhVaoLop(idHS, idLop);

      print('');
      print('Bước tiếp: nhập điểm cho học sinh');
      stdout.write('Nhập ID hoặc tên học sinh: ');
      String tuKhoa = stdin.readLineSync() ?? '';
      truong.nhapDiemChoLop(tuKhoa, idLop);
    } else if (chon == '6') {
      stdout.write('Nhập ID hoặc tên học sinh: ');
      String tuKhoa = stdin.readLineSync() ?? '';
      Student? hs = truong.timHocSinh(tuKhoa);
      if (hs == null) {
        print('Không tìm thấy học sinh');
      } else {
        hs.hienThi(truong.classrooms);
      }
    } else if (chon == '7') {
      stdout.write('ID giáo viên: ');
      String id = stdin.readLineSync() ?? '';
      Teacher? gv = truong.timGiaoVien(id);
      if (gv == null) {
        print('Không tìm thấy giáo viên');
      } else {
        gv.hienThi();
      }
    } else if (chon == '8') {
      truong.baoCao();
    } else if (chon == '0') {
      print('Tạm biệt!');
      break;
    } else {
      print('Chọn sai, vui lòng chọn lại.');
    }
  }
}
