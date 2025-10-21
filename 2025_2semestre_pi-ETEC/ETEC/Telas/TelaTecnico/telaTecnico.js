document.addEventListener("DOMContentLoaded", function () {
    // --- NAVEGAÇÃO ---
    const sections = document.querySelectorAll("section");
    const navLinks = document.querySelectorAll(".nav-link");

    function mostrarSection(tagId) {
        sections.forEach(section => {
            section.style.display = section.id === tagId ? "block" : "none";
        });

        // Atualiza classe ativa nos links
        navLinks.forEach(link => {
            if (link.getAttribute('data-target') === tagId) {
                link.classList.add('active');
            } else {
                link.classList.remove('active');
            }
        });
    }

    navLinks.forEach(link => {
        link.addEventListener("click", function (e) {
            e.preventDefault();
            const tagId = this.getAttribute("data-target");
            mostrarSection(tagId);
        });
    });

    // Mostra a primeira seção por padrão
    mostrarSection("item-1");

    // Funcionalidade do dropdown de acessibilidade
    const btnAcessibilidade = document.getElementById('accessibilityBtn');
    const dropdownAcessibilidade = document.getElementById('accessibilityDropdown');

    btnAcessibilidade.addEventListener('click', function() {
        dropdownAcessibilidade.classList.toggle('show');
    });

    // Fechar o dropdown quando clicar fora dele
    window.addEventListener('click', function(event) {
        if (!event.target.matches('.botao-acessibilidade')) {
            if (dropdownAcessibilidade.classList.contains('show')) {
                dropdownAcessibilidade.classList.remove('show');
            }
        }
    });

    // --- LÓGICA DE ACESSIBILIDADE ---
    const body = document.body;
    const html = document.documentElement;

    // Modo Escuro
    const darkModeToggle = document.getElementById('toggle-dark-mode');
    darkModeToggle.addEventListener('click', (e) => {
        e.preventDefault();
        body.classList.toggle('dark-mode');
        // Salva a preferência no localStorage
        localStorage.setItem('darkMode', body.classList.contains('dark-mode'));
    });

    // Carrega a preferência de Modo Escuro ao carregar a página
    if (localStorage.getItem('darkMode') === 'true') {
        body.classList.add('dark-mode');
    }

    // Controle de Zoom do Texto
    const MIN_FONT_SIZE = 0.8;
    const MAX_FONT_SIZE = 2.0;
    const STEP_SIZE = 0.1;

    function updateFontSize(direction) {
        const root = document.documentElement;
        const currentSize = parseFloat(getComputedStyle(root).getPropertyValue('--font-size-base'));
        let newSize = currentSize + (direction * STEP_SIZE);
        
        // Limitar tamanho mínimo e máximo
        newSize = Math.min(Math.max(newSize, MIN_FONT_SIZE), MAX_FONT_SIZE);
        
        root.style.setProperty('--font-size-base', newSize);
        
        // Salvar preferência no localStorage
        localStorage.setItem('fontSize', newSize);
    }

    // Aumentar fonte
    document.getElementById('increase-font').addEventListener('click', (e) => {
        e.preventDefault();
        updateFontSize(1);
    });

    // Diminuir fonte
    document.getElementById('decrease-font').addEventListener('click', (e) => {
        e.preventDefault();
        updateFontSize(-1);
    });

    // Carregar tamanho da fonte salvo
    const savedFontSize = localStorage.getItem('fontSize');
    if (savedFontSize) {
        document.documentElement.style.setProperty('--font-size-base', savedFontSize);
    }

    // Modos de Daltonismo
    const colorModeLinks = document.querySelectorAll('#accessibilityDropdown [data-mode]');
    colorModeLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const mode = link.getAttribute('data-mode');
            body.classList.remove('protanopia', 'deuteranopia', 'tritanopia');
            if(mode !== 'normal') {
                body.classList.add(mode);
            }
        });
    });

    // Lógica do botão sair atualizada
    const botaoSair = document.getElementById('botaoSair');
    botaoSair.addEventListener('click', function() {
        const confirmacao = confirm('Deseja realmente sair do sistema?');
        if (confirmacao) {
            localStorage.clear();
            window.location.href = '../TelaLogin/TelaLogin.html';
        }
    });
});