#Persistent
#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
global atajosDataFolder := A_MyDocuments . "\atajos_data"
global hotkeyFilePath := atajosDataFolder . "\hotkeys.ini"
if !FileExist(atajosDataFolder)
FileCreateDir, %atajosDataFolder%
global offScheduled := false
global hotkeyArray := []
global actionList := []
global RowNumber := 0
global pathsFilePath := atajosDataFolder . "\paths.ini"
global pathsArray := [] ; To store path objects {name: "...", path: "...", hotkey: "..."}
InitializeActionList()
LoadHotkeys()
LoadPaths() ; Call LoadPaths on script start
SoundBeep, 400, 400
TrayTip, programa iniciado, el programa atajos está en ejecución, 5, 1
Menu, Sistema, Add, Seleccionar Dispositivos, s
Menu, Sistema, Add, Abrir el Registro de Windows, rg
Menu, Sistema, Add, Mezclador de Volumen, m
Menu, Sistema, Add, Ver Información del Sistema, i
Menu, Sistema, Add, Saber Versión de Windows, win
Menu, Sistema, Add, Panel de Control, c
Menu, Sistema, Add, Programar el Apagado, manejarApagado
Menu, Sistema, Add, Forzar el Cierre de un Programa, close
Menu, Archivos, Add, Abrir Programas de Inicio, home
Menu, Archivos, Add, Archivos Temporales, temp
Menu, Archivos, Add, AppData, appdata
menu, UnigramMenu, add, abrir unigram, uni
menu, UnigramMenu, add, abrir unigram directamente ha un contacto, openContact
menu, apps, Add, spotify, sp
menu, apps, Add, word, ww
menu, apps, Add, what sapp, wha
menu, apps, Add, unigram, :UnigramMenu
menu, apps, Add, ml-player, ml
menu, herramientas, Add, Documentación, doc
Menu, Herramientas, Add, Convertir Enlace de Google Drive, converted
menu, herramientas, Add, convertir un número de teléfono de what sapp en un enlace directo desde el portapapeles, ConvertWha
menu, herramientas, Add, Buscar la definición de una palabra en la rae, buscarRae
menu, herramientas, Add, Convertir un audio utilizando ffmpeg, fmp
menu, herramientas, Add, Filtrar enlaces para copiar o ejecutar en el texto del portapapeles, links
menu, herramientas, Add, Subir archivo, UploadFiles
Menu, menuName, Add, Sistema, :Sistema
Menu, menuName, Add, Archivos y Carpetas, :Archivos
menu, menuName, Add, aplicaciones, :apps
Menu, menuName, Add, Herramientas, :Herramientas
Menu, menuName, Add, Gestionar Atajos de teclado, ShowHotkeyManager
Menu, menuName, Add, Gestionar Rutas/Ejecutables, ShowPathManager
Menu, menuName,  Add, Salir del Script, x
+f1::
Menu, menuName, Show
return
manejarApagado:
if (offScheduled) {
Gosub, cancelarApagado
} else {
Gosub, shut
}
return
s:
run mmsys.cpl
return
rg:
run regedit
return
m:
run sndvol.exe
return
i:
run msinfo32
return
win:
run winver
return
c:
run control
return
home:
run `shell:startup`
return
temp:
run %temp%
return
appdata:
run %appdata%
return
sp:
run, spotify://
return
ww:
run, winword
return
uni:
run, tg://
return
openContact:
InputBox, contact, Ingresa el nombre de usuario, Nombre de usuario:
if (ErrorLevel == 1) {
MsgBox, 0, Cancelado, Has cancelado la entrada del nombre de usuario.
return
}
if (contact = "") {
MsgBox, 0, Error, No has ingresado ningún nombre de usuario. Por favor, ingrésalo para continuar.
return
}
url := "tg://resolve?domain=" contact
Run, %url%
return
wha:
run, whatsapp://
return
ml:
UserProfile := A_UserProfile
MLPlayerPath := UserProfile "\AppData\Local\ml-player\ml-player.exe"
If FileExist(MLPlayerPath)
{
Run, %MLPlayerPath%
}
Else
{
MsgBox, El archivo ml-player.exe no se encontró en la ruta especificada.
}
return
close:
inputBox, programa, ¿Cuál es el programa a cerrar?, Escribe aquí
if (ErrorLevel = 1) {
return
}
while (programa = "") {
msgBox, 64, Error., Necesitas escribir algo para cerrar.
return
}
msgBox, 16, Muy bien., Se cerrará %programa%.exe
run taskkill /im %programa%.exe
return
shut:
SoundBeep, 200, 300
InputBox, tiempo_apagado, ¿Cuánto tiempo quieres que pase antes de que se apague la PC?, Escribe aquí en formato HH:MM
if (ErrorLevel or tiempo_apagado = "") {
MsgBox, 0, Operación cancelada, No se proporcionó tiempo de apagado, o la operación fue cancelada.
return
}
if !RegExMatch(tiempo_apagado, "^\s*(\d{1,2}):(\d{2})\s*$", partes) {
MsgBox, 0, Error en el formato, Por favor, introduce el tiempo en formato HH:MM.
return
}
tiempo_en_segundos := (partes1 * 3600) + (partes2 * 60)
MsgBox, 4, , ¿Quieres forzar el cierre de las aplicaciones antes de apagar? (Sí/No)
ifMsgBox Yes
comandoShutdown := "shutdown.exe -s -f -t " . tiempo_en_segundos
else
comandoShutdown := "shutdown.exe -s -t " . tiempo_en_segundos
Run %comandoShutdown%, Hide
offScheduled := true
Menu, Sistema, Rename, Programar el Apagado, Cancelar Apagado Programado
return
cancelarApagado:
Run, shutdown.exe /a, Hide
offScheduled := false
Menu, Sistema, Rename, Cancelar Apagado Programado, Programar el Apagado
return
doc:
FilePath := "C:\Program Files (x86)\atajos\doc.html"
If FileExist(FilePath) {
Run, %FilePath%
} else {
MsgBox, El archivo doc.html no se encuentra en la ubicación especificada.
}
return
converted:
SoundBeep, 500, 70
InputBox, link, Convertidor de Enlaces, Por favor introduce el enlace de Google Drive
if (link != "") {
if (IsGoogleDriveLink(link)) {
convertedLink := ConvertGoogleDriveLink(link)
} else {
MsgBox, El enlace no es de Google Drive.
return
}
MsgBox, El enlace convertido es: %convertedLink%
Clipboard := convertedLink
}
return
IsGoogleDriveLink(link) {
return RegExMatch(link, "drive\.google\.com\/file\/d\/[a-zA-Z0-9_-]+")
}
ConvertGoogleDriveLink(link) {
RegExMatch(link, "drive\.google\.com\/file\/d\/([a-zA-Z0-9_-]+)", match)
file_id := match1
return "https://drive.google.com/uc?export=download&id=" . file_id
}
x:
SoundBeep, 1200, 250
TrayTip, Programa finalizado correctamente., El programa atajos ha finalizado.
exitApp
return
buscarRae:
InputBox, rae, Escribe la definición a buscar:, Ingresa un término de búsqueda.
if (ErrorLevel = 1) {
MsgBox, 0, Listo, Operación cancelada.
return
}
if (rae = "") {
MsgBox, 64, Error., No puedes dejar el campo sin texto
return
}
run https://dle.rae.es/%rae%
return
fmp:
FileSelectFile, inputFile, 3,, Selecciona el archivo de entrada de audio, Audio Files (*.mp3; *.wav; *.aac; *.flac; *.ogg; *.m4a)
if (inputFile = "")
{
MsgBox, Has cancelado la selección del archivo de entrada.
return
}
FileSelectFile, outputFile, S,, Escribe el nombre del archivo de salida de audio, Audio Files (*.mp3; *.wav; *.aac; *.flac; *.ogg; *.m4a)
if (outputFile = "")
{
MsgBox, Has cancelado la selección del archivo de salida.
return
}
ffmpegCommand := "ffmpeg -i """ inputFile """ """ outputFile """"
RunWait, %ComSpec% /c %ffmpegCommand%, , Hide
MsgBox, El comando FFmpeg ha sido ejecutado.`n`nComando:`n%ffmpegCommand%
return
ConvertWha:
ClipSaved := ClipboardAll
phonePattern := "(\+?\d{1,3})?[-.\s]?\(?\d{1,4}\)?[-.\s]?\d{1,4}[-.\s]?\d{1,9}"
if (RegExMatch(Clipboard, phonePattern, phoneNumber)) {
cleanPhoneNumber := RegExReplace(phoneNumber, "\D")
if (StrLen(cleanPhoneNumber) >= 10 && StrLen(cleanPhoneNumber) <= 12) {
waLink := "https://wa.me/" . cleanPhoneNumber
Run % waLink
} else {
MsgBox, 0, Error, El número no tiene entre 10 y 12 dígitos.
}
} else {
MsgBox, 0, Error, No se encontró un número de teléfono.
}
Clipboard := ClipSaved
return
links:
contenidoPortapapeles := Clipboard
regex := "https?://\S+"
enlaces := []
Loop
{
if RegExMatch(contenidoPortapapeles, regex, enlace)
{
enlaces.Push(enlace)
contenidoPortapapeles := StrReplace(contenidoPortapapeles, enlace)
}
else
break
}
if (enlaces.Length() = 0)
{
MsgBox, 16, Error, No se encontraron enlaces en el texto del portapapeles.
Return
}
Gui, New
Gui, Add, text,, &Lista de enlaces
Gui, Add, ListBox, vListaEnlaces w600 r10,
For each, enlace in enlaces
GuiControl,, ListaEnlaces, %enlace%
Gui, Add, Button, gCopiarEnlace x10 y+10 w120, &Copiar Enlace
Gui, Add, Button, gAbrirEnlace x+10 y+-25 w120, &Abrir Enlace
Gui, Add, Button, gCloseList x+10 y+-25 w120, &Salir de la lista
Gui, Show,, Enlaces Encontrados
Return
CopiarEnlace:
GuiControlGet, enlaceSeleccionado,, ListaEnlaces
if (enlaceSeleccionado != "")
{
Clipboard := enlaceSeleccionado
MsgBox, El enlace ha sido copiado al portapapeles:`n%enlaceSeleccionado%
Gui, Destroy
}
else
{
MsgBox, Por favor, selecciona un enlace de la lista.
}
Return
AbrirEnlace:
GuiControlGet, enlaceSeleccionado,, ListaEnlaces
if (enlaceSeleccionado != "")
{
Run, %enlaceSeleccionado%
Gui, Destroy
}
else
{
MsgBox, Por favor, selecciona un enlace de la lista.
}
Return
CloseList:
Gui, Destroy
Return
NumpadDel::
Send, +{F10}
return
FormatHotkey(hotkeyString) {
static keyMap := {"#": "Win", "!": "Alt", "^": "Ctrl", "+": "Shift"}
formattedHotkey := ""
keys := StrSplit(hotkeyString)
for _, key in keys {
if (keyMap.HasKey(key)) {
formattedHotkey .= keyMap[key] . "+"
} else {
formattedHotkey .= key
}
}
return RTrim(formattedHotkey, "+")
}
InitializeActionList() {
global actionList
actionList := ["Seleccionar Dispositivos", "Abrir el Registro de Windows", "Mezclador de Volumen", "Ver Información del Sistema", "Saber Versión de Windows", "Panel de Control", "Programar el Apagado", "Forzar el Cierre de un Programa", "Abrir Programas de Inicio", "Archivos Temporales", "AppData", "Abrir Spotify", "Abrir Word", "Abrir WhatsApp", "Abrir Unigram", "Abrir ML-Player", "Documentación", "Convertir Enlace de Google Drive", "Convertir número de WhatsApp", "Buscar en RAE", "Convertir audio con FFmpeg", "Filtrar enlaces para copiar o ejecutar en el texto del portapapeles", "Gestionar Atajos de teclado", "Gestionar Rutas/Ejecutables", "Subir archivo"]
}
ShowHotkeyManager:
Gui, New, , Gestor de Atajos de teclado
Gui, Add, Text, x10 y10 w100, Ingresa la combinación de teclas:
Gui, Add, Hotkey, x10 y30 w100 vHotkeyInput
Gui, Add, Text, x120 y10 w200, &Selecciona una acción:
actionListString := ""
for index, action in actionList {
actionListString .= action . "|"
}
actionListString := RTrim(actionListString, "|")
Gui, Add, DropDownList, x120 y30 w200 vActionInput, %actionListString%
Gui, Add, Button, x330 y30 w100 gAddHotkey, &Añadir Atajo
Gui, Add, Text, x120 y60 w200, &Lista de atajos:
Gui, Add, ListView, x10 y90 w420 h200 vHotkeyList gHotkeyListClick -Multi, Atajo|Acción
Gui, Add, Button, x330 y300 w100 gDeleteHotkey, &Eliminar Atajo
Gui, Add, Button, x330 y330 w100 GCloseInterfaz1, &Cerrar la interfaz
LoadHotkeys()
Gui, Show, w440 h370
return
HotkeyListClick:
return
AddHotkey:
Gui, Submit, NoHide
if (HotkeyInput != "" and ActionInput != "") {
formattedHotkey := FormatHotkey(HotkeyInput)
for index, hotkey in hotkeyArray {
if (hotkey.key == HotkeyInput) {
hotkeyArray[index].action := ActionInput
LV_Modify(index, "Col2", ActionInput)
Hotkey, %HotkeyInput%, ExecuteHotkey
SaveHotkeys()
return
}
}
hotkeyArray.Push({key: HotkeyInput, action: ActionInput})
LV_Add("", formattedHotkey, ActionInput)
MsgBox, 48, Información, El atajo se ha añadido correctamente.
Hotkey, %HotkeyInput%, ExecuteHotkey
GuiControl,, HotkeyInput
GuiControl, Choose, ActionInput, 0
SaveHotkeys()
}
return
DeleteHotkey:
RowNumber := LV_GetNext(0)
if (RowNumber > 0)
{
LV_GetText(formattedKey, RowNumber, 1)
LV_GetText(action, RowNumber, 2)
for index, hotkey in hotkeyArray
{
if (FormatHotkey(hotkey.key) == formattedKey && hotkey.action == action)
{
key := hotkey.key
LV_Delete(RowNumber)
hotkeyArray.RemoveAt(index)
Hotkey, %key%, Off
SaveHotkeys()
MsgBox, 48, Atajo eliminado: %formattedKey% - %action%
break
}
}
}
else
{
MsgBox, 16, Por favor, selecciona un atajo para eliminar.
}
return
ExecuteHotkey:
for index, hotkey in hotkeyArray {
if (A_ThisHotkey = hotkey.key) {
ExecuteAction(hotkey.action)
break
}
}
return
ExecuteAction(action) {
static actionMap := {"Seleccionar Dispositivos": "s"
,"Abrir el Registro de Windows": "rg"
,"Mezclador de Volumen": "m"
,"Ver Información del Sistema": "i"
,"Saber Versión de Windows": "win"
,"Panel de Control": "c"
,"Programar el Apagado": "manejarApagado"
,"Forzar el Cierre de un Programa": "close"
,"Abrir Programas de Inicio": "home"
,"Archivos Temporales": "temp"
,"AppData": "appdata"
,"Abrir Spotify": "sp"
,"Abrir Word": "ww"
,"Abrir WhatsApp": "wha"
,"Abrir Unigram": "uni"
,"Abrir ML-Player": "ml"
,"Documentación": "doc"
,"Convertir Enlace de Google Drive": "converted"
,"Convertir número de WhatsApp": "ConvertWha"
,"Buscar en RAE": "buscarRae"
,"Convertir audio con FFmpeg": "fmp"
, "Gestionar Atajos de teclado": "ShowHotkeyManager"
, "Gestionar Rutas/Ejecutables": "ShowPathManager"
, "Filtrar enlaces para copiar o ejecutar en el texto del portapapeles": "links"
, "Subir archivo": "UploadFiles"}
if (actionMap.HasKey(action)) {
label := actionMap[action]
if (IsLabel(label)) {
Gosub, %label%
} else {
MsgBox, Etiqueta no encontrada: %label%
}
} else {
MsgBox, Acción no reconocida: %action%
}
}
SaveHotkeys() {
global hotkeyFilePath
IniDelete, %hotkeyFilePath%, Hotkeys
for index, hotkey in hotkeyArray {
IniWrite, % hotkey.action, %hotkeyFilePath%, Hotkeys, % hotkey.key
}
}
LoadHotkeys() {
global hotkeyFilePath, hotkeyArray
hotkeyArray := []
; LV_Delete() ; This LV_Delete() is for ShowHotkeyManager's ListView, should not be called here.
if FileExist(hotkeyFilePath) {
IniRead, sections, %hotkeyFilePath%
Loop, Parse, sections, `n
{
if (A_LoopField = "Hotkeys") {
IniRead, keys, %hotkeyFilePath%, Hotkeys
Loop, Parse, keys, `n
{
StringSplit, keyValue, A_LoopField, =
key := keyValue1
action := keyValue2
if (key != "" and action != "") {
hotkeyArray.Push({key: key, action: action})
; formattedKey := FormatHotkey(key) ; No need to add to ListView here
tempKey := key ; Use a temporary variable for Hotkey command
Hotkey, %tempKey%, ExecuteHotkey
}
}
}
}
}
}

SavePaths() {
global pathsFilePath, pathsArray
IniDelete, %pathsFilePath%, Paths ; Clear existing section
IniDelete, %pathsFilePath%, PathHotkeys ; Clear existing hotkey section
for index, pathObj in pathsArray {
IniWrite, % pathObj.path, %pathsFilePath%, Paths, % pathObj.name ; Store path
if (pathObj.hotkey != "") {
IniWrite, % pathObj.hotkey, %pathsFilePath%, PathHotkeys, % pathObj.name ; Store hotkey separately
}
}
}

LoadPaths() {
global pathsFilePath, pathsArray
pathsArray := []
if FileExist(pathsFilePath) {
IniRead, sections, %pathsFilePath%
Loop, Parse, sections, `n
{
if (A_LoopField = "Paths") {
IniRead, pathNames, %pathsFilePath%, Paths
Loop, Parse, pathNames, `n
{
StringSplit, nameValue, A_LoopField, =
name := nameValue1
path := nameValue2
if (name != "" and path != "") {
hotkey := ""
IniRead, hotkey, %pathsFilePath%, PathHotkeys, %name% ; Read associated hotkey
pathObj := {name: name, path: path, hotkey: hotkey}
pathsArray.Push(pathObj)
if (hotkey != "") {
tempHotkey := hotkey ; Use a temporary variable for Hotkey command
Hotkey, %tempHotkey%, ExecutePath
}
}
}
}
}
}
}

ExecutePath:
; This function will be called when a hotkey for a path is pressed
for index, pathObj in pathsArray {
if (A_ThisHotkey = pathObj.hotkey) {
Run, % pathObj.path
break
}
}
return

ShowPathManager:
Gui, PathManager:New, , Gestor de Rutas/Ejecutables
Gui, PathManager:Add, Text, x10 y10 w100, &Nombre:
Gui, PathManager:Add, Edit, x10 y30 w150 vPathNameInput
Gui, PathManager:Add, Text, x170 y10 w250, &Ruta (Carpeta o Ejecutable):
Gui, PathManager:Add, Edit, x170 y30 w250 vPathLocationInput
Gui, PathManager:Add, Button, x430 y30 w80 gSelectFileOrFolder, &Explorar...
Gui, PathManager:Add, Text, x10 y60 w100, &Atajo (Opcional):
Gui, PathManager:Add, Hotkey, x10 y80 w150 vPathHotkeyInput
Gui, PathManager:Add, Button, x170 y80 w100 gAddPath, &Añadir
Gui, PathManager:Add, Button, x280 y80 w100 gEditPath, &Editar
Gui, PathManager:Add, Button, x390 y80 w100 gDeletePath, &Eliminar
Gui, PathManager:Add, Text, x10 y110 w400, &Lista de Rutas/Ejecutables:
Gui, PathManager:Add, ListView, x10 y130 w500 h200 vPathList gPathListClick -Multi, Nombre|Ruta|Atajo
Gui, PathManager:Add, Button, x400 y340 w110 gClosePathManager, &Cerrar
UpdatePathListView()
Gui, PathManager:Show, w520 h370
return

PathListClick:
if (A_GuiEvent = "DoubleClick") {
Gosub, EditPath
} else {
selectedRow := LV_GetNext(0)
if (selectedRow > 0) {
LV_GetText(name, selectedRow, 1)
LV_GetText(path, selectedRow, 2)
LV_GetText(hotkey, selectedRow, 3)
GuiControl, PathManager:, PathNameInput, %name%
GuiControl, PathManager:, PathLocationInput, %path%
GuiControl, PathManager:, PathHotkeyInput, %hotkey%
}
}
return

SelectFileOrFolder:
FileSelectFolder, selectedFolder, , 3, Selecciona una Carpeta
if (selectedFolder != "") {
GuiControl, PathManager:, PathLocationInput, %selectedFolder%
} else {
FileSelectFile, selectedFile, , , Selecciona un Archivo
if (selectedFile != "") {
GuiControl, PathManager:, PathLocationInput, %selectedFile%
}
}
return

AddPath:
Gui, PathManager:Submit, NoHide
if (PathNameInput = "" or PathLocationInput = "") {
MsgBox, 16, Error, El nombre y la ruta no pueden estar vacíos.
return
}

; Check if name already exists
for index, pathObj in pathsArray {
if (pathObj.name = PathNameInput) {
MsgBox, 16, Error, Ya existe una ruta con ese nombre.
return
}
}

; Check if path exists
if (!FileExist(PathLocationInput)) {
MsgBox, 16, Error, La ruta especificada no existe.
return
}

; Unregister old hotkey if it exists and is being reused
if (PathHotkeyInput != "") {
for index, pathObj in pathsArray {
if (pathObj.hotkey = PathHotkeyInput) {
MsgBox, 16, Error, El atajo de teclado ya está en uso por otra ruta.
return
}
}
}

pathObj := {name: PathNameInput, path: PathLocationInput, hotkey: PathHotkeyInput}
pathsArray.Push(pathObj)
SavePaths()
if (PathHotkeyInput != "") {
tempHotkey := PathHotkeyInput ; Use a temporary variable for Hotkey command
Hotkey, %tempHotkey%, ExecutePath
}
UpdatePathListView()
GuiControl, PathManager:, PathNameInput,
GuiControl, PathManager:, PathLocationInput,
GuiControl, PathManager:, PathHotkeyInput,
MsgBox, 64, Información, Ruta añadida correctamente.
return

EditPath:
Gui, PathManager:Submit, NoHide
selectedRow := LV_GetNext(0)
if (selectedRow = 0) {
MsgBox, 16, Error, Por favor, selecciona una ruta para editar.
return
}

; Get original name from ListView
LV_GetText(originalName, selectedRow, 1)

; Find the object in pathsArray
foundIndex := 0
for index, pathObj in pathsArray {
if (pathObj.name = originalName) {
foundIndex := index
break
}
}

if (foundIndex = 0) {
MsgBox, 16, Error, No se encontró la ruta original para editar.
return
}

; Check if new name conflicts with others (excluding itself)
for index, pathObj in pathsArray {
if (index != foundIndex && pathObj.name = PathNameInput) {
MsgBox, 16, Error, Ya existe otra ruta con el nuevo nombre.
return
}
}

; Check if path exists
if (!FileExist(PathLocationInput)) {
MsgBox, 16, Error, La ruta especificada no existe.
return
}

; Unregister old hotkey if it changed
if (pathsArray[foundIndex].hotkey != "" && pathsArray[foundIndex].hotkey != PathHotkeyInput) {
tempOldHotkey := pathsArray[foundIndex].hotkey ; Use a temporary variable
Hotkey, %tempOldHotkey%, Off
}

; Check if new hotkey conflicts with others (excluding itself)
if (PathHotkeyInput != "") {
for index, pathObj in pathsArray {
if (index != foundIndex && pathObj.hotkey = PathHotkeyInput) {
MsgBox, 16, Error, El atajo de teclado ya está en uso por otra ruta.
return
}
}
}

; Update the object
pathsArray[foundIndex].name := PathNameInput
pathsArray[foundIndex].path := PathLocationInput
pathsArray[foundIndex].hotkey := PathHotkeyInput

SavePaths()

; Register new hotkey
if (PathHotkeyInput != "") {
tempNewHotkey := PathHotkeyInput ; Use a temporary variable
Hotkey, %tempNewHotkey%, ExecutePath
}

UpdatePathListView()
GuiControl, PathManager:, PathNameInput,
GuiControl, PathManager:, PathLocationInput,
GuiControl, PathManager:, PathHotkeyInput,
MsgBox, 64, Información, Ruta editada correctamente.
return

DeletePath:
selectedRow := LV_GetNext(0)
if (selectedRow = 0) {
MsgBox, 16, Error, Por favor, selecciona una ruta para eliminar.
return
}

LV_GetText(nameToDelete, selectedRow, 1)

; Find the object in pathsArray
foundIndex := 0
for index, pathObj in pathsArray {
if (pathObj.name = nameToDelete) {
foundIndex := index
break
}
}

if (foundIndex = 0) {
MsgBox, 16, Error, No se encontró la ruta para eliminar.
return
}

MsgBox, 4, Confirmar, ¿Estás seguro de que quieres eliminar la ruta "%nameToDelete%"?
IfMsgBox No
return

; Unregister hotkey
if (pathsArray[foundIndex].hotkey != "") {
tempHotkey := pathsArray[foundIndex].hotkey ; Use a temporary variable
Hotkey, %tempHotkey%, Off
}

pathsArray.RemoveAt(foundIndex)
SavePaths()
UpdatePathListView()
GuiControl, PathManager:, PathNameInput,
GuiControl, PathManager:, PathLocationInput,
GuiControl, PathManager:, PathHotkeyInput,
MsgBox, 64, Información, Ruta eliminada correctamente.
return

UpdatePathListView() {
global pathsArray
Gui, PathManager:Default
LV_Delete()
for index, pathObj in pathsArray {
LV_Add("", pathObj.name, pathObj.path, pathObj.hotkey)
}
LV_ModifyCol(1, "AutoHdr")
LV_ModifyCol(2, "AutoHdr")
LV_ModifyCol(3, "AutoHdr")
}

PathManager_GuiClose:
ClosePathManager:
Gui, PathManager:Destroy
return

GuiEscape:
CloseInterfaz:
Gui, Destroy
return
UploadFiles:
Gui, +LabelGui
Gui, Font, s10
Gui, Add, Text, x10 y10, Seleccione un archivo para subir:
Gui, Add, Button, x10 y35 w150 h30 gSelectFile, Seleccionar &Archivo
Gui, Add, Text, x10 y80, Archivo seleccionado:
Gui, Add, Edit, x170 y35 w270 h30 vSelectedFile ReadOnly
Gui, Add, Text, x10 y80, &Nombre personalizado para el enlace (opcional):
Gui, Add, Edit, x10 y105 w430 h30 vCustomPath
Gui, Add, Text, x10 y140 cGray
Gui, Add, Text, x10 y175, &Tiempo de expiración en horas:
Gui, Add, Edit, x10 y200 w100 h30 vExpireTime, 24
Gui, Add, Button, x10 y245 w150 h30 gUploadFile Default, &Subir Archivo
Gui, Add, Button, x10 y245 w150 h30 GCloseInterfaz, &Cerrar
Gui, Add, Progress, x10 y290 w430 h20 vProgressBar
Gui, Add, Text, x10 y320 w430 vStatus
Gui, Show, w450 h350, Subir Archivo - Marco ML
return
SelectFile:
FileSelectFile, filePath, 3,, Seleccionar archivo para subir
if (filePath) {
GuiControl,, SelectedFile, %filePath%
SoundPlay *-1
}
return
ValidateCustomPath(customPath, checkUrl) {
if (!customPath)
return true
http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
url := checkUrl . "?name=" . customPath
try {
http.Open("GET", url, false)
http.Send()
response := http.ResponseText
if (InStr(response, """exists"":true")) {
return false
}
return true
} catch e {
MsgBox, 16, Error de validación, No se pudo verificar el nombre personalizado.`nError: %e%
return false
}
}
UploadFile:
Gui, Submit, NoHide
if (!SelectedFile) {
MsgBox, 48, Archivo requerido, Por favor, selecciona primero un archivo para subir.
return
}
FileGetSize, fileSize, %SelectedFile%
if (fileSize > 1073741824) {
MsgBox, 48, Archivo demasiado grande, El archivo supera el límite de 1GB permitido.`nPor favor, selecciona un archivo más pequeño.
return
}
if (ExpireTime <= 0 || ExpireTime > 168) {
MsgBox, 48, Tiempo inválido, El tiempo de expiración debe estar entre 1 y 168 horas (7 días).
return
}
if (CustomPath) {
GuiControl,, Status, Verificando disponibilidad del nombre...
if (!ValidateCustomPath(CustomPath, "https://marco-ml.com/files/api/check.php")) {
MsgBox, 48, Nombre no disponible, El nombre personalizado "%CustomPath%" ya está en uso.`nPor favor, elija otro nombre.
return
}
}
http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
url := "https://marco-ml.com/files/api/upload.php"
boundary := "------------------------" . A_Now . A_MSec
FileRead, fileContent, *c %SelectedFile%
SplitPath, SelectedFile, fileName
GuiControl,, Status, Preparando archivo para subir...
GuiControl,, ProgressBar, 20
data := "--" boundary "`r`n"
data .= "Content-Disposition: form-data; name=""file""; filename=""" fileName """`r`n"
data .= "Content-Type: application/octet-stream`r`n`r`n"
data .= fileContent
data .= "`r`n"
if (CustomPath) {
data .= "--" boundary "`r`n"
data .= "Content-Disposition: form-data; name=""custom_path""`r`n`r`n"
data .= CustomPath "`r`n"
}
data .= "--" boundary "`r`n"
data .= "Content-Disposition: form-data; name=""expire""`r`n`r`n"
data .= ExpireTime "`r`n"
data .= "--" boundary "--`r`n"
try {
GuiControl,, Status, Subiendo archivo...
GuiControl,, ProgressBar, 40
http.Open("POST", url, true)
http.SetRequestHeader("Content-Type", "multipart/form-data; boundary=" boundary)
http.Send(data)
GuiControl,, ProgressBar, 70
http.WaitForResponse()
GuiControl,, ProgressBar, 90
response := http.ResponseText
if (RegExMatch(response, """download_link"":""([^""]+)""", downloadLink)) {
GuiControl,, ProgressBar, 100
downloadLink1 := RegExReplace(downloadLink1, "\\\/", "/")
Clipboard := downloadLink1
successMsg := "¡Archivo subido exitosamente!`n`n"
successMsg .= "El enlace ha sido copiado al portapapeles:`n"
successMsg .= downloadLink1 "`n`n"
successMsg .= "Presiona Aceptar para continuar."
SoundPlay *64
MsgBox, 64, Subida Exitosa, %successMsg%
GuiControl,, SelectedFile,
GuiControl,, CustomPath,
GuiControl,, ExpireTime, 24
GuiControl,, Status, Listo para nueva subida
} else {
throw "Respuesta del servidor inválida"
}
} catch e {
GuiControl,, ProgressBar, 0
SoundPlay *16
MsgBox, 16, Error de subida, Ha ocurrido un error al subir el archivo:`n%e%
}
return
GuiClose:
CloseInterfaz1:
Gui, Destroy
return