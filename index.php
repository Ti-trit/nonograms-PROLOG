<?php
// logic.php: maneja la lógica de comunicación con SWI-Prolog

function run_swipl(string $query): array {
    $cmd = sprintf("swipl -q -g \"%s\" -t halt .\\nonograma.pl", addslashes($query));
    echo '<script>console.log(' .  json_encode($cmd) . ');</script>';

    exec($cmd, $output, $status);
    //echo '<script>console.log(' .  json_encode($output) . ');</script>';
    //echo '<script>console.log(' .  json_encode($status) . ');</script>';

    return [$status, $output];
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
$pistasF  = getParam('pistasF', '[[], [], [], [], []]');
$pistasC  = getParam('pistasC', '[[], [], [], [], []]');
$casillas = getParam('casillas', '[[0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0]]');
$result   = null;

// Ejecutar acción según botón pulsado
$query = "";
switch ($action) {
    case 'check':
        $query  = sprintf("nonograma(%s,%s,%s).", $pistasF, $pistasC, $casillas);
        break;
    case 'solve':
        $query  = sprintf("nonograma(%s,%s,Caselles), print(Caselles).", $pistasF, $pistasC);

        break;
    case 'gen':
        $query  = sprintf("bagof((PF, PC, C),genera_nonograma(%d, %d, PF, PC, C), R), write(R).", $rows, $cols);
        break;
}
$result = run_swipl($query);
echo '<script>console.log(' .  json_encode($result) . ');</script>';
// Reemplazar paréntesis por corchetes
$result_json = str_replace(['(', ')'], ['[', ']'], $result[1]);

$sol = "test";
switch($action){
    case 'check':
        echo '<script>console.log(' .  json_encode($result[0]) . ');</script>';
        $sol = $result[0] == 0 ? "true": "false";
        break;
    case 'solve':
        echo '<script>console.log(' .  json_encode($result_json) . ');</script>';
        $sol = $result[0] == 0 ? "true": "false";
        if($result[0] == 0){
            
            $array = json_decode($result_json[0], true);
            echo '<script>console.log(' .  json_encode($array) . ');</script>';
            $casillas = json_encode($array);
        }else{
            echo '<script>console.log("lol: ");</script>';
        }
        break;
    case 'gen':
        echo '<script>console.log(' .  json_encode($result_json[0]) . ');</script>';
        $array = json_decode($result_json[0], true);
        $pistasF = json_encode($array[0][0]);
        $pistasC = json_encode($array[0][1]);
        $casillas = json_encode($array[0][2]);
        break;
}
// Decodificar JSON si aplica

// $sol = $result;


// $pistasF = implode("\n", $sol[0]); 
// Pasar variables a la plantilla
$templateData = compact('rows','cols','pistasF','pistasC','casillas','sol');

// Renderizar plantilla
include 'template.php';
?>