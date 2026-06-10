document.addEventListener("DOMContentLoaded", () => {

    // NAVIGATION LINKS
    const navigationLinks = [
        { name: "Home", route: "index.html", isDropdown: false },
        {
            name: "Expertise",
            isDropdown: true,
            children: [
                { name: "Electronics", route: "electronics.html" },
                { name: "Software Development", route: "software development.html" },
                { name: "Game Development", route: "game development.html" },
            ],
        },
        {
            name: "Contact",
            route: "index.html",
            hash: "home-contact",
            isDropdown: false,
        },
    ];

    // BUILD HEADER NAV
    const headerContainer = document.getElementById("global-header");

    if (headerContainer) {
        const currentPage =
            window.location.pathname.split("/").pop() || "index.html";

        let headerMarkup = `
  <div class="logo">MM</div>

  <button class="hamburger" aria-label="Toggle Menu">☰</button>

  <nav class="js-nav-container">
`;

        navigationLinks.forEach((item) => {
            if (item.isDropdown) {
                headerMarkup += `
                    <div class="dropdown">
                        <button class="dropbtn">${item.name}</button>
                        <div class="dropdown-content">`;

                item.children.forEach((child) => {
                    const isActive = currentPage === child.route ? "active" : "";
                    headerMarkup += `<button class="nav-custom-btn ${isActive}" data-route="${child.route}">${child.name}</button>`;
                });

                headerMarkup += `</div></div>`;
            } else {
                const isActive =
                    currentPage === item.route && !item.hash ? "active" : "";
                const hashData = item.hash ? `data-hash="${item.hash}"` : "";
                headerMarkup += `<button class="nav-custom-btn ${isActive}" data-route="${item.route}" ${hashData}>${item.name}</button>`;
            }
        });

        headerMarkup += `</nav>`;
        headerContainer.innerHTML = headerMarkup;

        // DROPDOWN TOGGLE
        document.querySelectorAll(".dropbtn").forEach((btn) => {
            btn.addEventListener("click", (e) => {
                e.stopPropagation();
                const content = btn.nextElementSibling;
                const isOpen = content.style.display === "block";

                document.querySelectorAll(".dropdown-content")
                    .forEach((d) => (d.style.display = "none"));

                content.style.display = isOpen ? "none" : "block";
            });
        });

        // Close dropdown when clicking outside
        document.addEventListener("click", () => {
            document.querySelectorAll(".dropdown-content")
                .forEach((d) => (d.style.display = "none"));
        });

        // PAGE TRANSITION
        const customButtons = document.querySelectorAll(".nav-custom-btn");

        document.body.classList.add("page-loaded");

        customButtons.forEach((button) => {
            button.addEventListener("click", () => {
                const destinationPage = button.getAttribute("data-route");
                const destinationHash = button.getAttribute("data-hash");

                document.body.classList.add("page-exiting");

                setTimeout(() => {
                    if (destinationHash) {
                        window.location.href = `${destinationPage}#${destinationHash}`;
                    } else {
                        window.location.href = destinationPage;
                    }
                }, 300);
            });
        });

        // HAMBURGER MENU
        const hamburger = document.querySelector(".hamburger");
        const navContainer = document.querySelector(".js-nav-container");

        if (hamburger && navContainer) {
            hamburger.addEventListener("click", () => {
                navContainer.classList.toggle("nav-open");
                hamburger.classList.toggle("active");
            });
        }
    }

    // EXPERTISE CARDS DATA
    const expertiseCards = [
        {
            title: "Electronics",
            description:
                "Explore projects involving Arduino, microcontrollers, embedded programming, and electronics design.",
            image: "assets/images/electronics/elec.png",
            link: "electronics.html",
        },
        {
            title: "Software Development",
            description:
                "View software projects showcasing problem solving, application development, and programming expertise.",
            image: "assets/images/software/software.png",
            link: "software engineering.html",
        },
        {
            title: "Game Development",
            description:
                "Discover game projects built with Unity, C#, and interactive design principles.",
            image: "assets/images/games/game.png",
            link: "game development.html",
        },
    ];

    // PLACE EXPERTISE CARDS INTO CONTAINER
    function renderExpertiseCards() {
        const container = document.getElementById("expertise-container");

        if (!container) return;

        container.innerHTML = expertiseCards
            .map(
                (card) => `
            <a href="${card.link}" class="expertise-card">
                <img src="${card.image}" alt="${card.title}">
                <div class="card-content">
                    <h3>${card.title}</h3>
                    <p>${card.description}</p>
                </div>
            </a>
        `
            )
            .join("");
    }

    renderExpertiseCards();

    // This is to stop form from reloading page
    const form = document.getElementById("contact-form");

    if (form) {
        form.addEventListener("submit", (e) => {

            e.preventDefault(); // stop reload first

            const email = document.getElementById("form-email").value;

            if (!email.includes("@")) {
                alert("Please enter a valid email address.");
                return;
            }

            console.log("Form submitted successfully");

            alert("Message captured successfully!");

            form.reset();
        });
    }
});