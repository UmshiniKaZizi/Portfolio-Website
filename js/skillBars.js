console.log("skillBars.js loaded");

document.addEventListener("DOMContentLoaded", () => {

    const skillsSection = document.querySelector("#home-skills");

    const observer = new IntersectionObserver((entries) => {

        entries.forEach(entry => {

            if (entry.isIntersecting) {

                setTimeout(() => {
                    document.querySelectorAll(".skill-fill").forEach(bar => {
                        bar.style.width = bar.dataset.width;
                    });
                }, 600);

                observer.disconnect();
            }
        });

    }, { threshold: 1.0 });

    observer.observe(skillsSection);

});