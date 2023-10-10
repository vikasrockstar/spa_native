document.addEventListener('DOMContentLoaded', function () {

    const allCookies = document.cookie;
    let locale = 'en';

    const [cookieName, cookieValue] = allCookies.trim().split('=');
    locale = cookieValue;

    const thanksMessageElement = document.getElementById('thanksMessage');
    switch (locale) {
        case 'ar':
            thanksMessageElement.textContent = 'MyTips شكراً لاستعمالك';
            break;
        case 'fr':
            thanksMessageElement.textContent = "Merci d'avoir utilisé MyTips";
            break;
        default:
            thanksMessageElement.textContent = 'Thanks for using MyTips';
            break;
    }
});
