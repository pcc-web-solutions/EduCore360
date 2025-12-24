document.addEventListener('DOMContentLoaded', () => {
    const modals = {
        addCountyModal: new bootstrap.Modal(document.getElementById('addCountyModal')),
        addSubCountyModal: new bootstrap.Modal(document.getElementById('addSubCountyModal')),
    };

    document.body.addEventListener('change', (event) => {
        const target = event.target;
        if (target.matches('[data-modal-trigger]')) {
            const selectedValue = target.value;
            const modalId = target.dataset.modalTrigger;

            if (selectedValue === 'addNew' && modals[modalId]) {
                modals[modalId].show();
            }
        }
    });

    document.getElementById('addCountyForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        const newCountyName = document.getElementById('newCountyName').value;

        await fetch('/add-county', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ name: newCountyName }),
        });

        const countySelect = document.getElementById('county');
        const newOption = document.createElement('option');
        newOption.value = newCountyName;
        newOption.textContent = newCountyName;
        countySelect.appendChild(newOption);
        countySelect.value = newCountyName;

        modals.addCountyModal.hide();
    });
});