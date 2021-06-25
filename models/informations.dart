class Informations {
  String project;  //ชื่อโปรเจค
  String customer; //ชื่อลูกค้า
  String province; //ชื่อจังหวัด
  String phone;  //เบอร์โทร
  DateTime date;  //วันที่ เวลา บันทึกรายการ
  var ratedpower;
  var ratedvoltage;
  var percentz;
  var lowvoltage;
  var qc;
  var step;

  Informations({required this.ratedvoltage, required this.project,required this.customer,required this.province,required this.phone,required this.date,required this.ratedpower,required this.lowvoltage,required this.percentz,required this.qc,required this.step});
}