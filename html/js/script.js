let bichoSelecionado = null;

// Seleção do bicho
document.querySelectorAll('.bicho-button').forEach(button => {
    button.addEventListener('click', () => {
        bichoSelecionado = button.getAttribute('data-bicho');
        document.querySelectorAll('.bicho-button').forEach(btn => btn.classList.remove('selected'));
        button.classList.add('selected');
    });
});

// Enviar aposta
document.getElementById('apostar').addEventListener('click', () => {
    // Converter formato BR para número decimal
    let valor = document.getElementById('valor').value;
    valor = valor.replace(/\./g, '').replace(',', '.');

    if (!bichoSelecionado) {
        Swal.fire({
            icon: 'error',
            title: 'Erro',
            text: 'Selecione um bicho para apostar!'
        });
        return;
    }

    if (!valor || valor <= 0) {
        Swal.fire({
            icon: 'error',
            title: 'Erro',
            text: 'Insira um valor válido para apostar!'
        });
        return;
    }

    // Envia a aposta para o servidor
    fetch(`https://${GetParentResourceName()}/registrarAposta`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ bicho: parseInt(bichoSelecionado), valor: parseFloat(valor) })
    })
        .then(() => {
            // Após sucesso, limpar a seleção do bicho e o campo de valor
            bichoSelecionado = null;
            document.getElementById('valor').value = ''; // Limpa o campo de valor
            document.querySelectorAll('.bicho-button').forEach(button => button.classList.remove('selected')); // Desmarca o botão
        })
        .catch(error => {
            console.error("Erro ao registrar aposta:", error);
            Swal.fire({
                icon: 'error',
                title: 'Erro',
                text: 'Ocorreu um problema ao registrar a aposta. Tente novamente mais tarde.'
            });
        });
});

// Função para fechar a interface do jogo
function closeGameUI() {
    fetch(`https://${GetParentResourceName()}/hideUI`, { method: 'POST' });
    document.getElementById('gameContainer').style.display = 'none';
    fetch(`https://${GetParentResourceName()}/nuiFocus`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ focus: false })
    });
}


// Sair do jogo
document.getElementById('sair').addEventListener('click', () => {
    closeGameUI();
});

// Configuração para exibir ou ocultar a interface
// Exibir Resultado
window.addEventListener('message', (event) => {
    switch (event.data.action) {
        case 'showUI':
            document.getElementById('gameContainer').style.display = 'block';
            break;

        case 'hideUI':
            document.getElementById('gameContainer').style.display = 'none';
            break;

        case 'showResult':
            Swal.fire({
                icon: event.data.icon,
                title: event.data.title,
                html: event.data.message
            }).then(() => {
                // Fecha a interface após o resultado
                fetch(`https://${GetParentResourceName()}/hideUI`, { method: 'POST' })
                    .then(() => {
                        document.getElementById('gameContainer').style.display = 'none';
                        fetch(`https://${GetParentResourceName()}/nuiFocus`, {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({ focus: false })
                        });
                    })
                    .catch((error) => {
                        console.error('Erro ao ocultar a interface:', error);
                    });
            });
            break;

        default:
            console.warn('Ação desconhecida:', event.data.action);
            break;
    }
});

// Inicialmente ocultar a interface
document.getElementById('gameContainer').style.display = 'none';

// Função para fechar a interface do jogo
function closeGameUI() {
    fetch(`https://${GetParentResourceName()}/hideUI`, { method: 'POST' });
    document.getElementById('gameContainer').style.display = 'none';
    fetch(`https://${GetParentResourceName()}/nuiFocus`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ focus: false })
    });
}

$(document).ready(function () {
    $('#valor').mask('000.000.000,00', { reverse: true });
});