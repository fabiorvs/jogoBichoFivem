let bichoSelecionado = null;

$(document).ready(function () {
  $("#valor").mask("000.000.000,00", { reverse: true });
});

// Seleção do bicho
document.querySelectorAll(".bicho-button").forEach((button) => {
  button.addEventListener("click", () => {
    bichoSelecionado = button.getAttribute("data-bicho");
    document
      .querySelectorAll(".bicho-button")
      .forEach((btn) => btn.classList.remove("selected"));
    button.classList.add("selected");
  });
});

// Enviar aposta
document.getElementById("apostar").addEventListener("click", () => {
  // Converter formato BR para número decimal
  let valor = document.getElementById("valor").value;
  valor = valor.replace(/\./g, "").replace(",", ".");

  if (!bichoSelecionado) {
    Swal.fire({
      title: "Erro",
      text: "Selecione um bicho para apostar!",
    });
    return;
  }

  if (!valor || valor <= 0) {
    Swal.fire({
      title: "Erro",
      text: "Insira um valor válido para apostar!",
    });
    return;
  }

  // Envia a aposta para o servidor
  fetch(`https://${GetParentResourceName()}/registrarAposta`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      bicho: parseInt(bichoSelecionado),
      valor: parseFloat(valor),
    }),
  })
    .then(() => {
      // Após sucesso, limpar a seleção do bicho e o campo de valor
      bichoSelecionado = null;
      document.getElementById("valor").value = ""; // Limpa o campo de valor
      document
        .querySelectorAll(".bicho-button")
        .forEach((button) => button.classList.remove("selected")); // Desmarca o botão
    })
    .catch((error) => {
      console.error("Erro ao registrar aposta:", error);
      Swal.fire({
        title: "Erro",
        text: "Ocorreu um problema ao registrar a aposta. Tente novamente mais tarde.",
      });
    });
});

// Função para fechar a interface do jogo
function closeGameUI() {
  fetch(`https://${GetParentResourceName()}/hideUI`, { method: "POST" });
  document.getElementById("gameContainer").style.display = "none";
  fetch(`https://${GetParentResourceName()}/nuiFocus`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ focus: false }),
  });
}

// Sair do jogo
document.getElementById("sair").addEventListener("click", () => {
  closeGameUI();
});

// Configuração para exibir ou ocultar a interface
// Exibir Resultado
window.addEventListener("message", (event) => {
  switch (event.data.action) {
    case "showUI":
      document.getElementById("gameContainer").style.display = "block";
      break;

    case "hideUI":
      document.getElementById("gameContainer").style.display = "none";
      break;

    case "showResult":
      Swal.fire({
        title: event.data.title,
        html: event.data.message,
      }).then(() => {
        // Fecha a interface após o resultado
        fetch(`https://${GetParentResourceName()}/hideUI`, { method: "POST" })
          .then(() => {
            document.getElementById("gameContainer").style.display = "none";
            fetch(`https://${GetParentResourceName()}/nuiFocus`, {
              method: "POST",
              headers: { "Content-Type": "application/json" },
              body: JSON.stringify({ focus: false }),
            });
          })
          .catch((error) => {
            console.error("Erro ao ocultar a interface:", error);
          });
      });
      break;

    default:
      console.warn("Ação desconhecida:", event.data.action);
      break;
  }
});

// Inicialmente ocultar a interface
document.getElementById("gameContainer").style.display = "none";

// Função para fechar a interface do jogo
function closeGameUI() {
  fetch(`https://${GetParentResourceName()}/hideUI`, { method: "POST" });
  document.getElementById("gameContainer").style.display = "none";
  fetch(`https://${GetParentResourceName()}/nuiFocus`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ focus: false }),
  });
}

// Array com nomes e números dos bichos
const bichosMap = [
  { numero: 1, nome: "Avestruz" },
  { numero: 2, nome: "Águia" },
  { numero: 3, nome: "Burro" },
  { numero: 4, nome: "Cachorro" },
  { numero: 5, nome: "Borboleta" },
  { numero: 6, nome: "Cabra" },
  { numero: 7, nome: "Carneiro" },
  { numero: 8, nome: "Camelo" },
  { numero: 9, nome: "Cobra" },
  { numero: 10, nome: "Coelho" },
  { numero: 11, nome: "Cavalo" },
  { numero: 12, nome: "Elefante" },
  { numero: 13, nome: "Galo" },
  { numero: 14, nome: "Gato" },
  { numero: 15, nome: "Jacaré" },
  { numero: 16, nome: "Leão" },
  { numero: 17, nome: "Macaco" },
  { numero: 18, nome: "Porco" },
  { numero: 19, nome: "Pavão" },
  { numero: 20, nome: "Peru" },
  { numero: 21, nome: "Touro" },
  { numero: 22, nome: "Tigre" },
  { numero: 23, nome: "Urso" },
  { numero: 24, nome: "Veado" },
  { numero: 25, nome: "Vaca" },
];

// Função para obter o número pelo nome do bicho
function getNumeroBicho(nome) {
  const bicho = bichosMap.find((b) => b.nome === nome);
  return bicho ? bicho.numero : null;
}

function showRotatingAnimation(prizes) {
  const animationContainer = document.getElementById("animationContainer");
  const prize1 = document.getElementById("prize1");
  const prize2 = document.getElementById("prize2");
  const prize3 = document.getElementById("prize3");

  // Mostrar a animação
  animationContainer.style.display = "flex";

  // Lista de imagens (substitua pelo caminho correto)
  const imagens = [
    "imagens/1.png",
    "imagens/2.png",
    "imagens/3.png",
    "imagens/4.png",
    "imagens/5.png",
    "imagens/6.png",
    "imagens/7.png",
    "imagens/8.png",
    "imagens/9.png",
    "imagens/10.png",
    "imagens/11.png",
    "imagens/12.png",
    "imagens/13.png",
    "imagens/14.png",
    "imagens/15.png",
    "imagens/16.png",
    "imagens/17.png",
    "imagens/18.png",
    "imagens/19.png",
    "imagens/20.png",
    "imagens/21.png",
    "imagens/22.png",
    "imagens/23.png",
    "imagens/24.png",
    "imagens/25.png",
  ];

  let interval1, interval2, interval3;

  // Função para iniciar a rotação das imagens
  function startRotation(imgElement) {
    let index = 0;
    return setInterval(() => {
      imgElement.src = imagens[index];
      index = (index + 1) % imagens.length;
    }, 100); // Troca de imagem a cada 100ms
  }

  // Iniciar a rotação para cada prêmio
  interval1 = startRotation(prize1);
  interval2 = startRotation(prize2);
  interval3 = startRotation(prize3);

  // Parar a rotação após um tempo e definir as imagens finais
  setTimeout(() => {
    clearInterval(interval1);
    const numero1 = getNumeroBicho(prizes[0]);
    prize1.src = `imagens/${numero1}.png`; // Define a imagem final do 1º prêmio
  }, 3000); // 3 segundos

  setTimeout(() => {
    clearInterval(interval2);
    const numero2 = getNumeroBicho(prizes[1]);
    prize2.src = `imagens/${numero2}.png`; // Define a imagem final do 2º prêmio
  }, 4000); // 4 segundos

  setTimeout(() => {
    clearInterval(interval3);
    const numero3 = getNumeroBicho(prizes[2]);
    prize3.src = `imagens/${numero3}.png`; // Define a imagem final do 3º prêmio
  }, 5000); // 5 segundos

  // Ocultar a animação após todos os prêmios serem exibidos
  setTimeout(() => {
    animationContainer.style.display = "none";
  }, 6000); // 6 segundos
}

// Receber os prêmios sorteados do servidor
window.addEventListener("message", (event) => {
  if (event.data.action === "showAnimation") {
    showRotatingAnimation(event.data.prizes);
  }
});
