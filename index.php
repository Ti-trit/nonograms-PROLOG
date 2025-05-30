<?php
// logic.php: maneja la lógica de comunicación con SWI-Prolog

function run_swipl(string $query): string {
    $cmd = sprintf("swipl -q -g '%s' -t halt nonograma.pl", addslashes($query));
    exec($cmd, $output);
    return implode("\n", $output);
}

// Recoger y sanitizar parámetros
function getParam(string $name, $default = null) {
    if (!isset($_POST[$name])) {
        return $default;
    }
    return $_POST[$name];
}

$action   = getParam('action', '');
$rows     = (int) getParam('rows', 5);
$cols     = (int) getParam('cols', 5);
$pistasF  = getParam('pistasF', '[]');
$pistasC  = getParam('pistasC', '[]');
$casillas = getParam('casillas', '[]');
$result   = null;

// Ejecutar acción según botón pulsado
switch ($action) {
    case 'check':
    case 'solve':
        $query  = sprintf("nonograma(%s,%s,%s).", $pistasF, $pistasC, $casillas);
        $result = run_swipl($query);
        break;
    case 'gen':
        $query  = sprintf("generar_nonograma(%d,%d,%s,%s,%s).", $rows, $cols, $pistasF, $pistasC, $casillas);
        $result = run_swipl($query);
        break;
}

// Decodificar JSON si aplica
$sol = json_decode($result, true) ?: $result;

// Pasar variables a la plantilla
$templateData = compact('rows','cols','pistasF','pistasC','casillas','sol');

// Renderizar plantilla
include 'template.php';
?>