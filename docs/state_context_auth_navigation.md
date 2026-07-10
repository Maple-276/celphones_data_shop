# State Context: Autenticación y Navegación (Login & Drawer)

## Arquitectura y Diseño
Se ha implementado un flujo de navegación principal y una vista de inicio de sesión utilizando la misma arquitectura MVC y diseño responsivo preestablecido.

## Componentes Añadidos

### `auth_controller.dart`
Maneja el estado y la lógica de inicio de sesión. Actualmente utiliza un retraso (`Future.delayed`) para simular una petición de red (mock). Gestiona los controladores de texto del Email y Password, así como el estado de carga (`isLoading`).

### `login_screen.dart`
Pantalla inicial de la aplicación.
- Centrada y restringida a un máximo de 400px de ancho (`ConstrainedBox`) para no deformarse en web/escritorio.
- Muestra un formulario básico con validaciones mock.
- Al hacer login exitoso, reemplaza la ruta (`pushReplacement`) hacia el `MainLayoutScreen`.

### `main_layout_screen.dart`
Es el "Scaffold Padre" o Layout Principal.
- Contiene el `AppBar` global y el menú lateral (`Drawer`).
- Mantiene el índice de la pantalla seleccionada (`_selectedIndex`) y renderiza la vista correspondiente en su `body`.

### `app_drawer.dart`
Widget separado que contiene la estructura del menú lateral, incluyendo un `UserAccountsDrawerHeader` (información del usuario actual) y los items de navegación (Inicio, Nueva Compra, Cerrar Sesión).

## Modificaciones a la Estructura Existente
- **`purchase_form_screen.dart`**: Perdió su propio `Scaffold` y `AppBar`. Ahora es un Widget puro que se inyecta en el body de `MainLayoutScreen`.
- **`main.dart`**: La propiedad `home` del `MaterialApp` ahora apunta a `LoginScreen` como punto de entrada de la aplicación.

## Próximos Pasos (Pendientes)
- Reemplazar la lógica de autenticación (mock) por un servicio real (e.g. Firebase Auth, API REST).
- Implementar la vista del "Dashboard/Inicio".
- Manejo de estado global para conocer la sesión del usuario a través de un servicio de autenticación compartido en lugar de un controlador local por pantalla.
