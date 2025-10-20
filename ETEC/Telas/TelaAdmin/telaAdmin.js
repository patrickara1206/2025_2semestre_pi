document.addEventListener('DOMContentLoaded', function() {
    
    // --- LÓGICA DE NAVEGAÇÃO ENTRE SEÇÕES ---
    const navLinks = document.querySelectorAll('.nav-link');
    const sections = document.querySelectorAll('.conteudo-secao');

    navLinks.forEach(link => {
        link.addEventListener('click', (event) => {
            event.preventDefault();
            
            const targetId = link.getAttribute('data-target');
            
            // Esconde todas as seções
            sections.forEach(section => {
                section.classList.remove('ativo');
            });

            // Mostra a seção alvo
            const targetSection = document.getElementById(targetId);
            if (targetSection) {
                targetSection.classList.add('ativo');
            }

            // Atualiza o estado 'active' nos links de navegação
            navLinks.forEach(navLink => {
                navLink.classList.remove('active');
            });
            link.classList.add('active');
        });
    });

    // --- LÓGICA DO MODAL ---
    const modal = document.getElementById('userModal');
    const abrirModalBtn = document.getElementById('abrirModalBtn');
    const fecharModalBtn = document.getElementById('fecharModalBtn');
    const cancelarModalBtn = document.getElementById('cancelarModalBtn');
    const userForm = document.getElementById('formUsuario');

    const abrirModal = () => modal.classList.add('visivel');
    const fecharModal = () => modal.classList.remove('visivel');

    abrirModalBtn.addEventListener('click', abrirModal);
    fecharModalBtn.addEventListener('click', fecharModal);
    cancelarModalBtn.addEventListener('click', fecharModal);

    // Fecha ao clicar fora do card
    modal.addEventListener('click', (event) => {
        if (event.target === modal) {
            fecharModal();
        }
    });

    userForm.addEventListener('submit', (event) => {
        event.preventDefault();
        const nome = document.getElementById('nome').value;
        alert(`Usuário "${nome}" cadastrado com sucesso! (Simulação)`);
        userForm.reset();
        fecharModal();
    });

    // --- LÓGICA DE ACESSIBILIDADE ---
    const body = document.body;
    const html = document.documentElement;

    // Dropdown de Acessibilidade
    const accessibilityBtn = document.getElementById('accessibilityBtn');
    const accessibilityDropdown = document.getElementById('accessibilityDropdown');

    accessibilityBtn.addEventListener('click', (event) => {
        event.stopPropagation();
        accessibilityDropdown.classList.toggle('show');
    });

    // Fecha o dropdown se clicar fora
    window.addEventListener('click', (event) => {
        if (!accessibilityBtn.contains(event.target) && !accessibilityDropdown.contains(event.target)) {
            accessibilityDropdown.classList.remove('show');
        }
    });


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

    // Controle de Fonte
    const increaseFontBtn = document.getElementById('increase-font');
    const decreaseFontBtn = document.getElementById('decrease-font');
    const FONT_STEP = 0.1; // Incremento/decremento em rem

    increaseFontBtn.addEventListener('click', (e) => {
        e.preventDefault();
        changeFontSize(FONT_STEP);
    });
    decreaseFontBtn.addEventListener('click', (e) => {
        e.preventDefault();
        changeFontSize(-FONT_STEP);
    });

    function changeFontSize(step) {
        const currentSize = parseFloat(getComputedStyle(html).getPropertyValue('--font-size-base'));
        const newSize = Math.max(0.7, currentSize + step); // Limite mínimo de 0.7rem
        html.style.setProperty('--font-size-base', `${newSize}rem`);
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

    // --- LÓGICA VLibras ---
    new window.VLibras.Widget('https://vlibras.gov.br/app');
});

