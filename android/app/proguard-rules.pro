# Reglas de R8 para el build de release.
# Flutter y Firebase ya traen las suyas; aquí solo lo que suele hacer falta.

# ponytail: solo estas dos líneas. Si un plugin peta en release por reflexión,
# añade su -keep aquí (mira el logcat del crash para saber la clase).
-dontwarn com.google.android.play.core.**
-keep class io.flutter.plugins.** { *; }
