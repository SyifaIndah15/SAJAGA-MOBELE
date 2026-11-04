class Validator {
  // Validasi alamat email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }

    final emailRegex =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }

    return null;
  }

  // Validasi kata sandi: minimal 8 karakter
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kata sandi tidak boleh kosong';
    }

    if (value.length < 8) {
      return 'Kata sandi minimal 8 karakter';
    }

    return null;
  }

  // Validasi konfirmasi kata sandi
  static String? validateConfirmPassword(
    String? value,
    String password,
  ) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi kata sandi tidak boleh kosong';
    }

    if (value != password) {
      return 'Kata sandi baru tidak sama';
    }

    return null;
  }

  // Validasi kolom wajib diisi
  static String? validateRequired(
    String? value,
    String fieldName,
  ) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    return null;
  }
}