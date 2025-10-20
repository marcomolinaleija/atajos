# Atajos de Teclado con AutoHotkey

Este script de AutoHotkey proporciona una serie de atajos y herramientas para mejorar la productividad en Windows. Ofrece un menú centralizado para acceder a diversas funciones del sistema, aplicaciones y utilidades personalizadas.

## Requisitos

- [AutoHotkey](https.www.autohotkey.com/) instalado en tu sistema.

## Cómo Empezar

1.  Asegúrate de tener AutoHotkey instalado.
2.  Ejecuta el archivo `atajos.ahk`.
3.  El script se ejecutará en segundo plano y mostrará un ícono en la bandeja del sistema.

## Menú Principal

Para acceder al menú principal, presiona la combinación de teclas:

**`Shift + F1`**

Este menú te dará acceso a todas las funcionalidades del script, organizadas en las siguientes categorías:

### Sistema

-   **Seleccionar Dispositivos:** Abre la configuración de sonido de Windows.
-   **Abrir el Registro de Windows:** Inicia `regedit`.
-   **Mezclador de Volumen:** Abre el mezclador de volumen de Windows.
-   **Ver Información del Sistema:** Abre `msinfo32`.
-   **Saber Versión de Windows:** Muestra la versión de Windows con `winver`.
-   **Panel de Control:** Abre el Panel de Control.
-   **Programar el Apagado:** Permite programar el apagado del equipo en un tiempo determinado (formato HH:MM).
-   **Forzar el Cierre de un Programa:** Pide el nombre de un proceso para forzar su cierre.

### Archivos y Carpetas

-   **Abrir Programas de Inicio:** Abre la carpeta de programas que inician con Windows.
-   **Archivos Temporales:** Abre la carpeta de archivos temporales.
-   **AppData:** Abre la carpeta `AppData\Roaming`.

### Aplicaciones

-   **Spotify:** Inicia Spotify.
-   **Word:** Inicia Microsoft Word.
-   **WhatsApp:** Abre la aplicación de escritorio de WhatsApp.
-   **Unigram:** Abre la aplicación de Unigram y permite abrir un chat directamente con un usuario.
-   **ml-player:** Inicia un reproductor de música personalizado.

### Herramientas

-   **Documentación:** Abre un archivo de documentación local.
-   **Convertir Enlace de Google Drive:** Convierte un enlace de Google Drive a un enlace de descarga directa.
-   **Convertir número de WhatsApp:** Convierte un número de teléfono del portapapeles a un enlace directo de WhatsApp (`wa.me`).
-   **Buscar en RAE:** Busca la definición de una palabra en el diccionario de la RAE.
-   **Convertir audio con FFmpeg:** Permite seleccionar un archivo de audio para convertirlo a otro formato usando FFmpeg.
-   **Filtrar enlaces:** Extrae y muestra una lista de enlaces encontrados en el texto del portapapeles, permitiendo copiarlos o abrirlos.

## Gestor de Atajos y Rutas

El script incluye dos gestores para personalizar tu experiencia:

-   **Gestionar Atajos de teclado:** Permite crear tus propias combinaciones de teclas para ejecutar cualquiera de las acciones disponibles en el script.
-   **Gestionar Rutas/Ejecutables:** Permite definir rutas a tus carpetas o programas favoritos y asignarles un atajo de teclado opcional para un acceso rápido.

## Atajos Adicionales

-   **`NumpadDel`**: Simula la combinación `Shift + F10` para abrir el menú contextual.

## Configuración

El script crea una carpeta llamada `atajos_data` en "Mis Documentos" para guardar la configuración de los atajos y las rutas en los archivos `hotkeys.ini` y `paths.ini`.
