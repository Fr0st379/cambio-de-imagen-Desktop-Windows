# Cambiador de fondo de pantalla aleatorio

Script de PowerShell que elige una imagen aleatoria de una carpeta y la establece como fondo de escritorio en Windows. Evita repetir la imagen usada en la ejecución anterior.

## Características

- Selecciona una imagen aleatoria de una carpeta (`.jpg`, `.jpeg` y `.png`).
- No repite la última imagen usada (guarda su ruta en un archivo de registro).
- Si solo hay una imagen en la carpeta, la usa igualmente.
- Si la carpeta no tiene imágenes válidas, termina sin hacer nada.
- Aplica el fondo al instante, sin cerrar sesión ni reiniciar.
- Estilo de ajuste configurable (rellenar, ajustar, etc.).

## Requisitos

- Windows 10 u 11
- PowerShell 5.1 o superior

## Configuración

Edita la variable `$folder` al inicio del script con la ruta de tu carpeta de imágenes:

```powershell
$folder = "C:\Users\TuUsuario\Pictures\Fondos"
```

### Estilo del fondo

El valor de `WallpaperStyle` define cómo se ajusta la imagen:

| Valor | Estilo     |
|-------|------------|
| `0`   | Centrar    |
| `2`   | Estirar    |
| `6`   | Ajustar    |
| `10`  | Rellenar   |
| `22`  | Expandir   |

Por defecto el script usa `10` (rellenar).

## Uso

Ejecútalo desde PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\cambiar-fondo.ps1
```

### Ejecución automática (Programador de tareas)

Para cambiar el fondo automáticamente, por ejemplo al iniciar sesión o cada cierto tiempo:

1. Abre el **Programador de tareas** y crea una tarea básica.
2. Elige el desencadenador (al iniciar sesión, cada hora, etc.).
3. En la acción, selecciona **Iniciar un programa** y configura:
   - **Programa:** `powershell.exe`
   - **Argumentos:** `-WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\ruta\cambiar-fondo.ps1"`

## Cómo funciona

1. Lista los archivos de imagen de la carpeta indicada.
2. Lee de `%APPDATA%\last_wallpaper.txt` la última imagen utilizada.
3. Filtra esa imagen de la lista y elige una al azar entre las restantes.
4. Guarda la nueva selección en el archivo de registro.
5. Configura el estilo del fondo en el registro de Windows (`HKCU:\Control Panel\Desktop`).
6. Aplica el fondo mediante la API `SystemParametersInfo` de `user32.dll`.
7. Refresca los parámetros de usuario con `UpdatePerUserSystemParameters`.

## Archivos generados

| Archivo | Descripción |
|---------|-------------|
| `%APPDATA%\last_wallpaper.txt` | Ruta de la última imagen aplicada |

## Notas

- Solo se leen las imágenes de la carpeta indicada, no de sus subcarpetas.
- Si la política de ejecución de PowerShell bloquea el script, usa el parámetro `-ExecutionPolicy Bypass` como en el ejemplo. 
