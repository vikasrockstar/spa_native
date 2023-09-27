document.addEventListener('DOMContentLoaded', function () {

    const allCookies = document.cookie;
    console.log(`All Cookies: ${allCookies}`);

    const cookiesArray = allCookies.split(';');

    let locale = 'en';

    for (const cookie of cookiesArray) {
        const [cookieName, cookieValue] = cookie.trim().split('=');
        if (cookieName === 'locale') {
            locale = cookieValue;
            break;
        }
    }

    const thanksMessageElement = document.getElementById('thanksMessage');
    switch (locale) {
        case 'ar':
            thanksMessageElement.textContent = 'شكرا لاستخدام My Tips';
            break;
        case 'fr':
            thanksMessageElement.textContent = "Merci d'avoir utilisé My Tips";
            break;
        default:
            thanksMessageElement.textContent = 'Thanks for using My Tips';
            break;
    }
});
