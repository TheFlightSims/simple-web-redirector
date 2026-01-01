// Please see documentation at https://learn.microsoft.com/aspnet/core/client-side/bundling-and-minification
// for details on configuring this project to bundle and minify static web assets.

// Write your JavaScript code.

'use strict'

const aliasModel = /^[A-Za-z0-9]+$/i

// Get the current Href and return it into the input box
document.addEventListener('DOMContentLoaded', () => {
    document.getElementById("curr-href-location").innerHTML = window.location.href;
});

// Display in case the connection is insecure
document.addEventListener('DOMContentLoaded', () => {
    const protocol = window.location.protocol;
    const el = document.getElementById('displayOnNoSecure')

    if (!el) {
        return;
    }

    if (protocol !== 'https:') {
        el.classList.remove('d-none');
        el.classList.add('show');
    } else {
        el.classList.add('d-none');
        el.classList.remove('show');
    }
});

// Redirect to URL
function startRedirecting() {
    const alias = document.getElementById('aliasInput');
    const inputWarnBox = document.getElementById('input-warning-box');

    if (!alias) {
        return;
    }

    if (!inputWarnBox) {
        return;
    }

    const aliasInput = alias.value.trim();

    // If the alias matches
    if (aliasModel.test(aliasInput)) {
        alias.classList.remove('is-invalid');
        inputWarnBox.classList.add('d-none');        
    } else {
        alias.classList.add('is-invalid');
        inputWarnBox.classList.remove('d-none');
        return;
    }

    const UrlHref = window.location.href;
    const redirectUrl = (UrlHref.endsWith === '/') ? (UrlHref + aliasInput) : (UrlHref.replace('#', '') + aliasInput)

    window.location.href = redirectUrl;
}