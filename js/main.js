document.addEventListener('DOMContentLoaded', () => {
    
    // Code for the navigation bar
    const navigationLinks = [
        { name: 'Home', route: 'index.html', isDropdown: false },
        { 
            name: 'Expertise', 
            isDropdown: true, 
            children: [
                { name: 'Electronics', route: 'electronics.html' },
                { name: 'Software Development', route: 'software development.html' },
                { name: 'Game Development', route: 'game development.html' }
            ]
        },
        { name: 'Contact', route: 'index.html', hash: 'home-contact', isDropdown: false }
    ];

    // Find the header container
    const headerContainer = document.getElementById('global-header');
    
    if (headerContainer) {
        // Find the current page 
        const currentPage = window.location.pathname.split('/').pop() || 'index.html';

        // Start building the nav
        let headerMarkup = `<div class="logo">MM</div><nav class="js-nav-container">`;

        
        navigationLinks.forEach(item => {
            if (item.isDropdown) {
               
                headerMarkup += `
                    <div class="dropdown">
                        <button class="dropbtn">${item.name}</button>
                        <div class="dropdown-content">`;
                
                item.children.forEach(child => {
                    const isActive = currentPage === child.route ? 'active' : '';
                    headerMarkup += `<button class="nav-custom-btn ${isActive}" data-route="${child.route}">${child.name}</button>`;
                });

                headerMarkup += `</div></div>`;
            } else {
                
                const isActive = (currentPage === item.route && !item.hash) ? 'active' : '';
                const hashData = item.hash ? `data-hash="${item.hash}"` : '';
                headerMarkup += `<button class="nav-custom-btn ${isActive}" data-route="${item.route}" ${hashData}>${item.name}</button>`;
            }
        });

        headerMarkup += `</nav>`;
        
       
        headerContainer.innerHTML = headerMarkup;
    }

    // page transition
    const customButtons = document.querySelectorAll('.nav-custom-btn');
    
    
    document.body.classList.add('page-loaded');

    customButtons.forEach(button => {
        button.addEventListener('click', () => {
            const destinationPage = button.getAttribute('data-route');
            const destinationHash = button.getAttribute('data-hash');

            
            document.body.classList.add('page-exiting');

           
            setTimeout(() => {
                if (destinationHash) {
                    window.location.href = `${destinationPage}#${destinationHash}`;
                } else {
                    window.location.href = destinationPage;
                }
            }, 300);
        });
    });
});