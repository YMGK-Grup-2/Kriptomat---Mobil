import 'dart:async'; //gerekli kütüphaneleri ekledik pubspec.yaml sayfasına giderek bunları görebilirsin
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

void main() {
  runApp(new MaterialApp(
    title: "Ymgk Proje",
    home: LandingScreen(),
    debugShowCheckedModeBanner: false,//debug modunu kaldırdık
  ));
}

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  File imageFile; //resmi kaydedeceğimiz değişken
  String sifreliFile; //şifrelenmiş resmin uzantısını kaydediyoruz buraya
  bool _secildimi = false; //resmin seçilme durumunu kontrol ettiğimiz değişken
  //Galeriden resim seçme metotu
  _openGallary(BuildContext context) async {
    var picture =
        imageFile = await ImagePicker.pickImage(source: ImageSource.gallery); //atama işlemi yapılıyor
    this.setState(() {
      imageFile = picture;
      String boyut = imageFile.lengthSync().toString();
      int son = boyut.length - 3;
      int _boyut =
          int.parse(imageFile.lengthSync().toString().substring(0, son));
      if (_boyut > 1000) {//boyut kontrolü yapıyoruz bunun sebebi eğer boyut sınırdan yüksekse dönüş işlemi uzun sürüyor
        imageFile = null;
        _secildimi = false;
        yeniimage = null;
        Fluttertoast.showToast(  //bekleme işlemi çok uzun olacağı için 1Mb boyut sınırı koyduk
            timeInSecForIosWeb: 2, 
            msg: "1 MB Altında Dosya Seçiniz!!", //kullanıcıya burada uyarı veriyoruz
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });

    Navigator.of(context).pop();
  }
  //Kamerayı açma butonu
  _openCamera(BuildContext context) async {
    var picture =
        imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    this.setState(() {
      imageFile = picture;
      String boyut = imageFile.lengthSync().toString();
      int son = boyut.length - 3;
      int _boyut =
          int.parse(imageFile.lengthSync().toString().substring(0, son));
      print(_boyut);

      if (_boyut > 1000) {//boyut kontrolü yapıyoruz eğer sınırdan büyükse değikenlerimizi ilk konumuna getiriyoruz
        imageFile = null;
        _secildimi = false;
        yeniimage = null;
        Fluttertoast.showToast( //burada resmin boyutuyla ilgili uyarı veriyoruz
            timeInSecForIosWeb: 2,
            msg: "1 MB Altında Dosya Seçiniz!!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });
    Navigator.of(context).pop();
  }
  //Resim ekle butonuna basıldığında bu kısım çalışıyor kullanıcıya resim ya da kamera mı seçmek istediği soruluyor
  Future<void> _showChoiceDiolog(BuildContext context) { 
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Ekleme yönteminizi seçiniz."), //Başlık metni
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Galeri"), 
                    onTap: () {
                      _openGallary(context);//Galeri seçilirse bu metotu çağırıyoruz
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Kamera"),
                    onTap: () {
                      _openCamera(context); //kamera seçilirse bu metotu çalıştırıyoruz
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
  //Resim seçilmişse gösteriyoruz seçilmemişse mesaj gösteriyoruz
  Widget _decideImageView() {
    if (imageFile == null) { //resim seçilmemişse burası çalışır
      return Text(
        "Henüz resim Seçilmedi!",
        style: TextStyle(   //göstrilen mesajın stil yarları yapılıyor
            fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
      );
    } else {//Eğer seçilmişse resmi gösteriyoruz
      return Container(
          height: 200, child: Image.file(imageFile, width: 400, height: 400));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //Responsive bir yapıda olması için boyutları Mediaquery metoduyla tüm cihazlara uygun hale getiriyoruz
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      appBar: AppBar( //Uygulamamızın ana ekranı bu kısımda çalışıyor üst kısım Appbar diye adlandırılıyor
        title: Text("YMGK GRUP 2"), 
        centerTitle: mounted,
        backgroundColor: Colors.orange[700],
      ),
      body: Container( //uygulamanın gövdesi butonlar resim gösterme kısımları burada
        color: Colors.black,
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(height: size.height * 0.30, child: _decideImageView()),//bu kısım seçilen resmi gösterdiğimiz kısım 
              RaisedButton( //Resim ekle butonunu burada tanımladık
                shape: RoundedRectangleBorder( //butonun şekillerini ayarlıyoruz
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.red)),
                color: Colors.orange[700],
                onPressed: () { //butona basıldığında bu kısım çalışıyor
                  setState(() { //tekrar resim seçme işlemi yapılırsa eski resim kaldırılıyor
                    _secildimi = false; 
                    imageFile = null;
                    yeniimage = null;
                  });

                  _showChoiceDiolog(context); //resim seçme ekranı gösteriliyor
                },
                child: Text(
                  "Resim Ekle", 
                  style: TextStyle(//Resim ekle yazısının stil ayarları yapılıyor
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 19.0),
                ),
              ),
              Container(height: size.height * 0.30, child: _sifreliImage()),//Şİfreli resmi gösterme, beklerken yükleme gifi gösterme işlemlerini yaptığımız metot burada çalışıyor
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.40,
                    child: RaisedButton( //resim şifreleme metotu burada çalışıyor
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.red)),
                      color: Colors.orange[700],
                      onPressed: () {
                        _sifrele(); //Apiyle haberleşme şifreleme işlemleri bu metotla yapılıyor
                      },
                      child: Text(//butonun yazısının özellikleri yapılıyor 
                        "Resmi Şifrele",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 19.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: size.width * 0.40,
                    child: RaisedButton(//Şİfreyi çözme butonumuz 
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.red)),
                      color: Colors.orange[700],
                      onPressed: () {
                        if (yeniimage != null) {//resmin şifreleme işleminin olup olmadığını kontrol ediyoruz
                          decrypt();//şifrelenmiş resim varsa bu metotla resmin şifresini kaldırıyoruz
                        } else {
                          Fluttertoast.showToast(//eğer şifreleme işlemi yapılmadıysa henüz uyarı mesajı veriyoruz
                              timeInSecForIosWeb: 2,
                              msg: "Resim Şifrelenmedi!!!",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.red,
                              textColor: Colors.white);
                        }
                      },
                      child: Text(//butonda yazan metnin stil özelliklerini yaptık
                        "Şifreyi Çöz",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 19.0),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Timer timer;
  void decrypt() {//şifreyi çözme metotu apide sorun yaşadığımız için bu kısımda atadığımız sayaç ile resmi gösterdiğimiz yerden kaldırıyoruz 
    yeniimage = null;
    _secildimi = true;
    Fluttertoast.showToast(//kaldırılma işlemi yapılırken bu kısımda işlem yapıldığını belirten uyarı mesajı veriyoruz
        timeInSecForIosWeb: 2,
        msg: "Şifreleme kaldırılıyor. \nLütfen Bekleyiniz...!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white);
    int _start = 10;
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(() {
        if (_start < 1) {//10 saniye bekleyip resmi kaldırıyoruz
          timer.cancel();
          Fluttertoast.showToast(//Resmin kaldırıldığını belirten mesaj belirtiyoruz
              timeInSecForIosWeb: 2,
              msg: "Şifreleme kaldırıldı.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white);
          setState(() {//işlem tamamlandıktan sonra değişkenlerimizi sıfırlıyoruz
            imageFile = null;
            yeniimage = null;
            _secildimi = false;
          });
        } else {
          _start = _start - 1;
        }
      }),
    );
  }

  String yeniimage;

  _sifrele() async {//apiyle haberleştiğimiz kısım
    print(imageFile.path);

    setState(() {
      _secildimi = true;//resmin seçildiğini belirtiyoruz
    });
    imageFile.readAsBytes().then((response) {
      var tmpByte = response;

      var mpFile = http.MultipartFile.fromBytes('photo', tmpByte,//bu ksıımda apiye post işlemi yapıyoruz
          filename: basename(imageFile.path));
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://webmenudemo.online/api/File/Upload'));
      request.files.add(mpFile);
 
      request.send().then((response) {
        if (response.statusCode == 200) {//Apiden cevap gelmişse eğer bu ksım çalışıyor
          response.stream.bytesToString().then((value) {
            print("GELDİ");
            print(value);

            setState(() {
              var tmpVal = value.substring(1, value.length - 1);

              yeniimage = tmpVal.toString();//gelen değeri değişkene atıyoruz gerekli işlemler için
            });
          });
        }
      });
    });
  }
  ////bekleme işlemini kontrol ediyoruz işlem tamamlanınca şifreli resmi gösteriyoruz 
  Widget _sifreliImage() {
    if (yeniimage != null) {//değişkenin kontrolünü yapıyoruz
      return Container(//eğer boş değilse resmi gösteriyoruz
        height: 200,
        child: Image.network('http://' + yeniimage),
      );
    } else if (_secildimi == true && yeniimage == null) {//eğer resim seçilmiş ve şifrelenmemiş ise burası çalışır
      return Image.asset("assets/images/yukleme.gif");//yukleme yapılırken kullanıcıya yükleme işleminin yapıldığını belirtmek amacıyla gif gösteriyoruz
    } else {
      return Text(//eğer şifreleme işlemi yapılmamışsa resmin beklendiğini belirten mesaj gösteriyoruz
        "Resim Bekleniyor...",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      );
    }
  }
}
