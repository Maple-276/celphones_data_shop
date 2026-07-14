# Patrón de diseño — Celphones Data Shop

Guía para duplicar el estilo del `LoginScreen` en cualquier pantalla nueva.
Fuente de verdad: [`lib/views/login_screen.dart`](../lib/views/login_screen.dart).

## Paleta (`AppColors`)

| Token | Uso |
|-------|-----|
| `primary` / `primaryDark` | Gradiente de fondo, botones principales, acentos |
| `accent` | Detalles secundarios (ámbar) |
| `background` | Fondo de pantallas internas (crema) |
| `surface` (blanco) | Tarjetas y superficies |
| `textPrimary` / `textSecondary` | Títulos / subtítulos y texto de apoyo |
| `error` / `success` | Estados |

## Esqueleto de pantalla

```
Scaffold
└─ Container(gradient: primary → primaryDark, topLeft → bottomRight)
   └─ SafeArea
      └─ Center
         └─ SingleChildScrollView(padding: 24)
            └─ ConstrainedBox(maxWidth: 400)
               └─ [entrada] TweenAnimationBuilder  ← fade + slide-up al montar
                  └─ Column(min)
                     ├─ Cabecera (ícono en círculo + título + subtítulo, en blanco)
                     └─ Card(elevation: 8, radius: 20, color: surface)
                        └─ Padding(28) → contenido de la pantalla
```

## Reglas de estilo

- **Fondo:** gradiente `primary → primaryDark` (`topLeft → bottomRight`).
- **Contenido:** siempre dentro de una `Card` blanca, `elevation: 8`, `borderRadius: 20`, `Padding(28)`.
- **Ancho máx.:** `400` para que en web/tablet no se estire.
- **Botón principal:** `FilledButton`, `height: 52`, `radius: 12`, `backgroundColor: primary`, texto `bold 16`.
- **Botón secundario:** `OutlinedButton`, mismo tamaño, `side: primary`, `foreground: textPrimary`.
- **Inputs:** `OutlineInputBorder` + `prefixIcon`.
- **Cabecera:** ícono blanco en círculo con sombra (`blurRadius: 16`, `offset (0,6)`), título `bold 26` blanco, subtítulo blanco al 85%.

## Micro-animaciones (marca de la casa)

Reutilizables tal cual del login:

1. **Entrada** — `TweenAnimationBuilder` 0→1, `easeOutCubic` 550 ms: `Opacity` + `Transform.translate(y: (1-t)*28)`.
2. **Cambio de texto** — helper `_switchText`: `AnimatedSwitcher` 250 ms con `FadeTransition`, `key: ValueKey(text)`.
3. **Reflow suave** — `AnimatedSize` 250 ms `easeInOut` cuando el contenido crece/encoge.
4. **Shake de error** — `AnimationController` 400 ms + `Transform.translate(x: sin(t·π·4)·10·(1-t))` al fallar una acción.

## Checklist para una pantalla nueva

- [ ] Fondo con gradiente `primary → primaryDark`.
- [ ] `SafeArea` + `Center` + `SingleChildScrollView(24)` + `ConstrainedBox(400)`.
- [ ] Contenido en `Card` blanca (elev 8 / radius 20 / padding 28).
- [ ] Entrada con `TweenAnimationBuilder` (fade + slide-up).
- [ ] Botones `52 px` / radius `12`, colores de `AppColors`.
- [ ] Textos con `textPrimary` / `textSecondary`.
