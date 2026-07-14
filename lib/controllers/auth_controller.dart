import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Web OAuth client ID de Firebase (Consola > Authentication > Google > "ID de cliente web").
// En Android es OBLIGATORIO para que Google devuelva un idToken. En iOS puede ir vacío.
// ponytail: constante única; muévela a --dart-define si algún día tienes varios entornos.
const String _googleServerClientId =
    '1098307965896-6n9be1c2037ng9rk2tco00dsf8dcv3ir.apps.googleusercontent.com';

class AuthController extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? errorMessage;

  static bool _gsiReady = false; // GoogleSignIn.initialize() solo se llama una vez.

  Future<bool> signInWithEmail() async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      return true; // el auth gate de main.dart detecta la sesión y navega.
    } on FirebaseAuthException catch (e) {
      errorMessage = switch (e.code) {
        'invalid-email' => 'Correo inválido',
        'user-not-found' || 'wrong-password' || 'invalid-credential' =>
          'Correo o contraseña incorrectos',
        _ => 'Error: ${e.code}',
      };
      return false;
    } catch (_) {
      errorMessage = 'No se pudo iniciar sesión';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      if (kIsWeb) {
        // En web no hay flujo nativo: Firebase abre un popup de Google.
        await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
      } else {
        if (!_gsiReady) {
          await GoogleSignIn.instance.initialize(
            serverClientId: _googleServerClientId,
          );
          _gsiReady = true;
        }
        final account = await GoogleSignIn.instance.authenticate();
        final idToken = account.authentication.idToken;
        final credential = GoogleAuthProvider.credential(idToken: idToken);
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
      return true; // el auth gate de main.dart detecta la sesión y navega.
    } on GoogleSignInException catch (e) {
      // El usuario cancelando no es un error que mostrar.
      if (e.code != GoogleSignInExceptionCode.canceled) {
        errorMessage = 'Error de Google: ${e.code.name}';
      }
      return false;
    } on FirebaseAuthException catch (e) {
      // Popup cerrado por el usuario tampoco es error que mostrar.
      const cancels = {'popup-closed-by-user', 'cancelled-popup-request'};
      if (!cancels.contains(e.code)) errorMessage = 'Error: ${e.code}';
      return false;
    } catch (_) {
      errorMessage = 'No se pudo iniciar sesión';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Crea la cuenta y envía el correo de verificación.
  /// Devuelve true si se registró (aunque el correo aún esté sin verificar).
  Future<bool> signUpWithEmail() async {
    if (passwordController.text != confirmPasswordController.text) {
      errorMessage = 'Las contraseñas no coinciden';
      notifyListeners();
      return false;
    }
    _isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      await cred.user?.sendEmailVerification();
      return true; // el auth gate de main.dart detecta la sesión y navega.
    } on FirebaseAuthException catch (e) {
      errorMessage = switch (e.code) {
        'invalid-email' => 'Correo inválido',
        'email-already-in-use' => 'Ese correo ya está registrado',
        'weak-password' => 'La contraseña debe tener al menos 6 caracteres',
        _ => 'Error: ${e.code}',
      };
      return false;
    } catch (_) {
      errorMessage = 'No se pudo crear la cuenta';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ID token de Firebase para autenticar las llamadas al Worker.
  static Future<String?> idToken() =>
      FirebaseAuth.instance.currentUser?.getIdToken() ?? Future.value(null);

  static Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await FirebaseAuth.instance.signOut();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
