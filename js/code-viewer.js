document.addEventListener("DOMContentLoaded", () => {

    // ELEMENT REFERENCES
    const codeDisplay = document.getElementById("code-display");
    const lineNumbers = document.getElementById("line-numbers");
    const copyButton = document.getElementById("copy-btn");

    if (!codeDisplay || !lineNumbers || !copyButton) return;

    // FETCH SOURCE FILE
    fetch("assets/access_control.asm")
        .then(response => {
            if (!response.ok) throw new Error("Failed to fetch file");
            return response.text();
        })
        .then(code => {

            const lines = code.split("\n");

            // Build line numbers off-DOM to prevent flicker
            const fragment = document.createDocumentFragment();
            lines.forEach((_, index) => {
                const line = document.createElement("div");
                line.textContent = index + 1;
                fragment.appendChild(line);
            });

            lineNumbers.innerHTML = "";
            lineNumbers.appendChild(fragment);

            // Inject code after line numbers are ready
            codeDisplay.textContent = code;

        })
        .catch(err => {
            console.error(err);
            codeDisplay.textContent = "Unable to load source file.";
        });

    // COPY TO CLIPBOARD 
    copyButton.addEventListener("click", async () => {
        try {
            await navigator.clipboard.writeText(codeDisplay.textContent);

            copyButton.textContent = "Copied!";
            setTimeout(() => copyButton.textContent = "Copy", 1500);

        } catch (err) {
            console.error(err);
            copyButton.textContent = "Failed";
        }
    });

});