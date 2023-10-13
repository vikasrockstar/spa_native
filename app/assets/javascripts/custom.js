document.cookie = `locale=en; expires=Fri, 31 Dec 9999 23:59:59 GMT; path=/`;
document.addEventListener('DOMContentLoaded', function () {
  var form = document.querySelector('.form');
  const localeSelect = document.getElementById('locale-select');
  const amountHeading = document.getElementById('amount-heading');
  const ratingHeading = document.getElementById('rating-heading');
  const reviewHeading = document.getElementById('review-heading');
  const ratings = document.getElementById('ratings');
  const payButton = document.getElementById('pay-button');

  form.addEventListener('submit', function (event) {
    var amountField = form.querySelector('input[name="payment[amount]"]');
    var amountValue = amountField.value.trim();

    const alertMessages = {
      'en': {
        amountEmptyMessage: 'Amount cannot be empty',
        amountLessThanTwoMessage: 'Amount cannot be less than 2',
      },
      'fr': {
        amountEmptyMessage: 'Le montant ne peut pas être vide',
        amountLessThanTwoMessage: 'Le montant ne peut pas être inférieur à 2',
      },
      'ar': {
        amountEmptyMessage:'لا يمكن أن يكون المبلغ فارغًا',
        amountLessThanTwoMessage: 'لا يمكن أن يكون المبلغ أقل من 2',
      },
    };

    let locale = 'en';
    const allCookies = document.cookie;
    const [cookieName, cookieValue] = allCookies.trim().split('=');
    locale = cookieValue;

    if (amountValue === '') {
      event.preventDefault();
      document.getElementById("demo").innerHTML = "*";
      document.getElementById("demo").style.color = 'red';
      alert(alertMessages[locale].amountEmptyMessage);
    } else if (amountValue < 2) {
      event.preventDefault();
      document.getElementById("demo").innerHTML = "*";
      document.getElementById("demo").style.color = 'red';
      alert(alertMessages[locale].amountLessThanTwoMessage);
    }
  });

  const setLanguageCookie = (locale) => {
    document.cookie = `locale=${locale}; expires=Fri, 31 Dec 9999 23:59:59 GMT; path=/`;
  };

  const updateHeadingText = (locale) => {
    if (locale === 'en') {
      amountHeading.innerText = "Amount (AED)";
      ratingHeading.innerText = "Rating";
      reviewHeading.innerText = "Review";
      ratings.innerText = "Ratings";
      payButton.innerText = "Pay";
    }
    if (locale === 'fr') {
      amountHeading.innerText = "Montant (AED)";
      ratingHeading.innerText = "Note";
      reviewHeading.innerText = "Commentaires";
      ratings.innerText = "Notes";
      payButton.innerText = "Paiement";
    }
    if (locale === 'ar') {
      amountHeading.innerText = "المبلغ (درهم)";
      ratingHeading.innerText = "ملاحظة";
      reviewHeading.innerText = "تعليق";
      ratings.innerText = "ملاحظات";
      payButton.innerText = "يدفع";
    }
  };

  localeSelect.addEventListener('change', function () {
    const selectedLocale = localeSelect.value;
    setLanguageCookie(selectedLocale);
    updateHeadingText(selectedLocale);
  });

  const currentLocale = localeSelect.value;
  updateHeadingText(currentLocale);
});