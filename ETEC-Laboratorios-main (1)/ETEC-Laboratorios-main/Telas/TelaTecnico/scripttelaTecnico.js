document.addEventListener("DOMContentLoaded", function () {
    const sections = document.querySelectorAll("section");
    const navItems = document.querySelectorAll("nav ul li");

    function mostrarSection(tagId) {
        sections.forEach(section => {
            section.style.display = section.id === tagId ? "block" : "none";
        });
    }

    navItems.forEach(li => {
        li.addEventListener("click", function () {
            const tag = li.getAttribute("tag");
            mostrarSection(tag);
        });
    });

    // Exibe apenas a primeira section ao carregar
    mostrarSection("item-1");
});