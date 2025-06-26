<!DOCTYPE html>
<html lang="es">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nonograma</title>
    <link rel="stylesheet" href="style/main.css">
</head>

<?php
// Cargar idioma seleccionado o por defecto 'es'
$idioma = $_GET['lang'] ?? $_COOKIE['lang'] ?? 'es';
setcookie('lang', $idioma, time() + 3600 * 24 * 30, '/'); // Guardar preferencia

// Cargar traducciones desde archivo externo
$traducciones = [];
if (file_exists("lang/$idioma.php")) {
    include "lang/$idioma.php";
} else {
    include "lang/es.php";
}
function t($clave) {
    global $traducciones;
    return $traducciones[$clave] ?? $clave;
}

// Detectar idiomas disponibles automáticamente
$idiomas_disponibles = [];
foreach (glob(__DIR__ . '/lang/*.php') as $file) {
    $code = basename($file, '.php');
    $idiomas_disponibles[] = $code;
}
?>

<header>
    <?php foreach ($idiomas_disponibles as $lang): ?>
        <button onclick="window.location.search='?lang=<?= $lang ?>'"<?= $idioma === $lang ? ' style="font-weight:bold"' : '' ?>><?= strtoupper($lang) ?></button>
    <?php endforeach; ?>
    <a href="https://github.com/Ti-trit/nonograms-PROLOG" target="_blank"><img src="assets/icon/github.svg" width="45" height="45"></img></a>
</header>
<h1><?= t('Nonograma') ?></h1>
<div class="container">
    <div>

        <form method="post" id="form">
            <div class="numbers">
                <div class="ro-cols">
                    <label><?= t('Filas') ?> <input type="number" name="rows" value="<?= $rows ?>"></label>
                </div>
                <div class="ro-cols">
                    <label><?= t('Columnas') ?> <input type="number" name="cols" value="<?= $cols ?>"></label>
                </div>
            </div>
            <div class="buttons">
                <button type="submit" name="action" value="check"><?= t('Comprobar') ?></button>
                <button type="submit" name="action" value="solve"><?= t('Resolver') ?></button>
                <button type="submit" name="action" value="gen"><?= t('Generar') ?></button>
            </div>
            <div class="wrapper">
    
                <div class="ro-cols rows">
                    <label><?= t('Pistas Filas') ?> <input type="text" name="pistasF" value='<?= htmlspecialchars($pistasF, ENT_QUOTES) ?>'></label>
                </div>
                <div class="ro-cols cols">
                    <label><?= t('Pistas Columnas') ?> <input type="text" name="pistasC" value='<?= htmlspecialchars($pistasC, ENT_QUOTES) ?>'></label>
                </div>
            </div>
            <input type="hidden" name="casillas" id="casillas" value='<?= htmlspecialchars($casillas, ENT_QUOTES) ?>'>
    
            <div id="grid" class="grid" style="grid-template-columns: repeat(<?= $cols ?>, 30px);"></div>
        </form>
        <pre><?= t('Resultado') ?>: <?php print_r($sol); ?></pre>
        
    </div>
    <section>
        <div>
            <p> <span><?= t('Generar') ?></span> --> <?= t('Generar_desc') ?> </p>
            <p> <span><?= t('Comprobar') ?></span> --> <?= t('Comprobar_desc') ?></p>
            <p> <span><?= t('Resolver') ?></span> --> <?= t('Resolver_desc') ?> </p>
            <p> <span><?= t('Autores') ?></span> --> Khaoula Ikkene, Daniel García Vázquez</p>
        </div>
    </section>
</div>
<!-- <pre>Resultado: <?php print_r($sol); ?></pre> -->

<script>
    let rows = <?= $rows ?>;
    let cols = <?= $cols ?>;
    let state;

    const rowsInput = document.querySelector('input[name="rows"]');
    const colsInput = document.querySelector('input[name="cols"]');
    const grid = document.getElementById('grid');

    function initState() {
        try {
            state = JSON.parse('<?= addslashes($casillas) ?>');
        } catch {
            state = null;
        }
        if (!Array.isArray(state) || state.length !== rows || state.some(r => !Array.isArray(r) || r.length !== cols)) {
            state = Array.from({
                length: rows
            }, () => Array(cols).fill(0));
        }
        rowsInput.value = rows;
        colsInput.value = cols;
    }

    function draw() {
        grid.style.gridTemplateColumns = `repeat(${cols}, 30px)`;
        grid.innerHTML = '';
        state.forEach((r, i) => {
            r.forEach((c, j) => {
                const cell = document.createElement('div');
                cell.className = 'cell' + (c ? ' filled' : '');
                cell.addEventListener('click', () => {
                    state[i][j] = 1 - state[i][j];
                    draw();
                });
                grid.appendChild(cell);
            });
        });
        document.getElementById('casillas').value = JSON.stringify(state);
    }

    function updateSize() {
        rows = parseInt(rowsInput.value) || 0;
        cols = parseInt(colsInput.value) || 0;
        initState();
        draw();
    }

    rowsInput.addEventListener('input', updateSize);
    colsInput.addEventListener('input', updateSize);

    initState();
    draw();
</script>
</body>

</html>