import places from 'places.js';

const initAutocomplete = () => {
    const addressInput = document.getElementById('yacht_Address');
    if (addressInput) {
        places({ container: addressInput });
    }
};

export { initAutocomplete };