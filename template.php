<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Nonograma</title>
    <style>
        body { display: flex; flex-direction: column; align-items: center; margin: 0; padding: 20px; }
        form { display: flex; flex-direction: column; align-items: center; }
        input[type="number"] { width: 8ch; }
        .buttons { margin-bottom: 10px; }
        .grid { display: grid; grid-gap: 1px; background: #333; margin: 20px 0; border: 2px solid #333; }
        .cell { width: 30px; height: 30px; background: #fff; cursor: pointer; }
        .filled { background: #000; }
        pre { width: 80%; max-width: 600px; overflow-x: auto; background: #f4f4f4; padding: 10px; }
    </style>
</head>
<body>
<form method="post" id="form">
    <div>
        <label>Files: <input type="number" name="rows" value="<?= $rows ?>"></label>
        <label>Columnes: <input type="number" name="cols" value="<?= $cols ?>"></label>
    </div>
    <div class="buttons">
        <button type="submit" name="action" value="check">Comprobar</button>
        <button type="submit" name="action" value="solve">Resolver</button>
        <button type="submit" name="action" value="gen">Generar</button>
    </div>
    <div>
        <label>Pistas Filas: <input type="text" name="pistasF" value='<?= htmlspecialchars($pistasF, ENT_QUOTES) ?>'></label>
    </div>
    <div>
        <label>Pistas Columnas: <input type="text" name="pistasC" value='<?= htmlspecialchars($pistasC, ENT_QUOTES) ?>'></label>
    </div>
    <input type="hidden" name="casillas" id="casillas" value='<?= htmlspecialchars($casillas, ENT_QUOTES) ?>'>

    <div id="grid" class="grid" style="grid-template-columns: repeat(<?= $cols ?>, 30px);"></div>
</form>

<pre>Resultado: <?php print_r($sol); ?></pre>

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
            state = Array.from({ length: rows }, () => Array(cols).fill(0));
        }
        rowsInput.value = rows;
        colsInput.value = cols;
        console.log(state)
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