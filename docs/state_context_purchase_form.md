# State Context: Formulario de Compra de Equipos (Purchase Form)

## Arquitectura y Diseño
Para la maquetación del formulario de compra de dispositivos móviles, se implementó una arquitectura basada en **Modelo-Vista-Controlador (MVC)**, con el objetivo de separar la lógica de negocio, la estructura de datos y la interfaz gráfica. 

Se priorizó mantener los archivos pequeños y manejables (evitando archivos gigantes) dividiendo la vista en múltiples componentes (widgets).

## Estructura de Archivos
- **`lib/core/theme/app_colors.dart`**: Define la paleta de colores global para mantener consistencia.
- **`lib/models/purchase_model.dart`**: Entidad que almacena todos los datos requeridos (vendedor, equipo, imágenes, firma).
- **`lib/controllers/purchase_controller.dart`**: Maneja el estado de la UI (`ChangeNotifier`), controla los campos de texto (`TextEditingController`), y gestiona la captura de fotos y firma.
- **`lib/views/purchase_form_screen.dart`**: Pantalla principal que orquesta los componentes del formulario.
- **`lib/views/widgets/`**:
  - `personal_info_section.dart`: Campos de nombre, teléfono y cédula.
  - `device_info_section.dart`: Campos del equipo (IMEI, SN, detalles, precio, etc.).
  - `media_capture_section.dart`: Botones y visualización previa para las fotos del equipo y cédula usando `image_picker`.
  - `signature_section.dart`: Lienzo para capturar la firma usando el plugin `signature`.

## Dependencias Añadidas
- `image_picker`: ^1.1.2 (Para acceso a la cámara/galería).
- `signature`: ^6.3.0 (Para el canvas de dibujo de la firma).

## Próximos Pasos (Pendientes)
- Integrar lógica de almacenamiento local (e.g. SQLite, Hive) o remoto (API/Firebase) al ejecutar el método `submit()` del controlador.
- Validaciones estrictas de campos en el controlador (actualmente es un mockup).
- Gestión del estado en caso de cerrar la aplicación para no perder los datos del formulario.
