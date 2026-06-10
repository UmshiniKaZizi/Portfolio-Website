// js/section-scroll.js
document.addEventListener('DOMContentLoaded', () => {

    const panels = Array.from(document.querySelectorAll('.panel'));
    const arrowUp = document.getElementById('nav-arrow-up');
    const arrowDown = document.getElementById('nav-arrow-down');

    let currentPanelIndex = 0;


    function updateArrowControls() {
        arrowUp.style.opacity = currentPanelIndex === 0 ? "0.3" : "1";
        arrowUp.style.pointerEvents = currentPanelIndex === 0 ? "none" : "auto";

        arrowDown.style.opacity = currentPanelIndex === panels.length - 1 ? "0.3" : "1";
        arrowDown.style.pointerEvents = currentPanelIndex === panels.length - 1 ? "none" : "auto";
    }


    function scrollToPanel(indexTarget) {
        if (indexTarget >= 0 && indexTarget < panels.length) {

            if (panels[currentPanelIndex].classList.contains('scroll-locked') && indexTarget > currentPanelIndex) {
                console.log("Section state locked. Interact directly with main call-to-action arrow.");
                return;
            }

            currentPanelIndex = indexTarget;

            panels[currentPanelIndex].scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });

            updateArrowControls();

            // Skill BarAnimation
            const activePanel = panels[currentPanelIndex];

            if (activePanel.id === "home-skills") {

                document.querySelectorAll(".skill-fill").forEach(bar => {
                    bar.style.width = bar.dataset.width;
                });

            }
        }
    }


    arrowUp.addEventListener('click', () => scrollToPanel(currentPanelIndex - 1));
    arrowDown.addEventListener('click', () => scrollToPanel(currentPanelIndex + 1));


    document.querySelectorAll('.cta-arrow').forEach(cta => {
        cta.addEventListener('click', () => {
            const associatedHero = cta.closest('.panel');
            associatedHero.classList.remove('scroll-locked');
            scrollToPanel(currentPanelIndex + 1);
        });
    });


    updateArrowControls();
});

document.addEventListener("DOMContentLoaded", () => {

    const btn = document.getElementById("viewCodeBtn");

    if (btn) {
        btn.addEventListener("click", () => {
            window.location.href = "access control.html";
        });
    }

});