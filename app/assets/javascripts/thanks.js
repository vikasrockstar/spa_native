document.addEventListener('DOMContentLoaded', function () {

    const allCookies = document.cookie;
    let locale = 'en';

    const [cookieName, cookieValue] = allCookies.trim().split('=');
    locale = cookieValue;

    const thanksMessageElement = document.getElementById('thanksMessage');
    switch (locale) {
        case 'ar':
            thanksMessageElement.textContent = 'شكراً لاستعمالك MyTips';
            break;
        case 'fr':
            thanksMessageElement.textContent = "Merci d'avoir utilisé My Tips";
            break;
        default:
            thanksMessageElement.textContent = 'Thanks for using My Tips';
            break;
    }
});
