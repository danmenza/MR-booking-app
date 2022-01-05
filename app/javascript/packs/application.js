// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"

// External imports
import "channels";
import "bootstrap";
import "select2";

Rails.start()
Turbolinks.start()

document.addEventListener('turbolinks:load', () => {

    $('#share_select').select2();
});

function phoneNumberFormatter() {
    // grab the value of what the user is typing into the input
    const inputField = document.querySelectorAll("artist_phone", "user_phone");

    // next, we're going to format this input with the `formattPhoneNumber` function, which we'll write next.
    const formattedInputValue = formatPhoneNumber(inputField.value);

    // Then we'll set the value of the inputField to the formattedValue we generated with the formattPhoneNumber
    inputField.value = formattedInputValue;
}

function formatPhoneNumber(value) {
    // if input value is falsy eg if the user deletes the input, then just return
    if (!value) return value;

    // clean the input for any non-digit values.
    const phoneNumber = value.replace(/[^\d]/g, "");

    // phoneNumberLength is used to know when to apply our formatting for the phone number
    const phoneNumberLength = phoneNumber.length;

    // we need to return the value with no formatting if its less then four digits
    // this is to avoid weird behavior that occurs if you  format the area code to early
    if (phoneNumberLength < 4) return phoneNumber;

    // if phoneNumberLength is greater than 4 and less the 7 we start to return
    // the formatted number
    if (phoneNumberLength < 7) {
        return `(${phoneNumber.slice(0, 3)}) ${phoneNumber.slice(3)}`;
    }

    // finally, if the phoneNumberLength is greater then seven, we add the last
    // bit of formatting and return it.
    return `(${phoneNumber.slice(0, 3)}) ${phoneNumber.slice(
      3,
      6
    )}-${phoneNumber.slice(6, 9)}`;
}