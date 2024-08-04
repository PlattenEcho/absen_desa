import 'package:absen_desa/controller/storage_controller.dart';
import 'package:absen_desa/main.dart';
import 'package:absen_desa/model/pengguna.dart';
import 'package:absen_desa/services/crypt.dart';
import 'package:absen_desa/ui/shared/theme.dart';
import 'package:absen_desa/ui/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

Future<void> createUser(BuildContext context, String namaLengkap,
    String jabatan, String username, String password) async {
  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: kWhiteColor,
        ),
      ),
    );

    if (namaLengkap != "" && jabatan != "" && username != "") {
      final response = await supabase
          .from('users')
          .select('username')
          .eq('username', username)
          .limit(1);

      if (response.isEmpty) {
        String encryptedPassword = encryptMyData(password);

        await supabase.from('users').insert({
          'nama_lengkap': namaLengkap,
          'jabatan': jabatan,
          'username': username,
          'password': encryptedPassword,
          'role': 2
        });
        Navigator.pop(context);

        Navigator.pushReplacementNamed(context, '/login-page');
        showToast(context, "Akun sudah dibuat, silahkan login");
      } else {
        Navigator.pop(context);

        showToast(context, "Username yang anda masukkan sudah dipakai");
      }
    } else {
      Navigator.pop(context);

      showToast(context, "Masih ada kolom yang kosong, mohon diisi");
    }
  } catch (e) {
    Navigator.pop(context);

    showToast(context, e.toString());
    print(e.toString());
  }
}

Future<void> authenticateUser(
    BuildContext context, String username, String password) async {
  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: kWhiteColor,
        ),
      ),
    );

    final response = await supabase
        .from('users')
        .select(
            'id, username, password, nama_lengkap, jabatan, role, created_at')
        .eq('username', username)
        .limit(1);

    if (response.isNotEmpty) {
      final user = response[0];
      String encryptedPassword = user['password'];
      String decryptedPassword = decryptMyData(encryptedPassword);

      if (decryptedPassword == password) {
        StorageController storageController = Get.find<StorageController>();
        storageController.saveData('isLoggedIn', true);

        final localUser = Pengguna.fromMap(user);
        storageController.saveData('user', localUser.toMap());
        Navigator.pop(context);

        Navigator.pushReplacementNamed(context, '/main-page');
        showToast(context, "Login berhasil, selamat datang $username");
      } else {
        Navigator.pop(context);

        showToast(
            context, "Login gagal, silahkan cek ulang username atau password");
      }
    } else {
      Navigator.pop(context);

      showToast(
          context, "Login gagal, silahkan cek ulang username atau password");
    }
  } catch (e) {
    Navigator.pop(context);

    showToast(context, e.toString());
    print(e.toString());
  }
}
