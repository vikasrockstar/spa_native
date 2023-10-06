document.cookie = `locale=en; expires=Fri, 31 Dec 9999 23:59:59 GMT; path=/`;
document.addEventListener('DOMContentLoaded', function () {
  var form = document.querySelector('.form');
  const localeSelect = document.getElementById('locale-select');
  const businessIdHeading = document.getElementById('business-id-heading');
  const amountHeading = document.getElementById('amount-heading');
  const ratingHeading = document.getElementById('rating-heading');
  const reviewHeading = document.getElementById('review-heading');
  const ratings = document.getElementById('ratings');
  const payButton = document.getElementById('pay-button');

  form.addEventListener('submit', function (event) {
    var amountField = form.querySelector('input[name="payment[amount]"]');
    var amountValue = amountField.value.trim();

    if (amountValue === '') {
      event.preventDefault();
      document.getElementById("demo").innerHTML = "*";
      document.getElementById("demo").style.color = 'red';
      alert('Amount cannot be empty');
    }
    else if (amountValue < 2) {
      event.preventDefault();
      document.getElementById("demo").innerHTML = "*";
      document.getElementById("demo").style.color = 'red';
      alert('Amount cannot be less than 2');
    }
  });

  const setLanguageCookie = (locale) => {
    document.cookie = `locale=${locale}; expires=Fri, 31 Dec 9999 23:59:59 GMT; path=/`;
  };

  const updateHeadingText = (locale) => {
    if (locale === 'en') {
      businessIdHeading.innerText = "Business ID";
      amountHeading.innerText = "Amount (AED)";
      ratingHeading.innerText = "Rating";
      reviewHeading.innerText = "Review";
      ratings.innerText = "Ratings";
      payButton.innerText = "Pay";
    }
    if (locale === 'fr') {
      businessIdHeading.innerText = "Carte de visite";
      amountHeading.innerText = "Montant (AED)";
      ratingHeading.innerText = "Note";
      reviewHeading.innerText = "Commentaires";
      ratings.innerText = "Notes";
      payButton.innerText = "Paiement";
    }
    if (locale === 'ar') {
      businessIdHeading.innerText = "بطاقة العمل";
      amountHeading.innerText = "المبلغ (درهم)";
      ratingHeading.innerText = "ملاحظة";
      reviewHeading.innerText = "تعليق";
      ratings.innerText = "ملاحظات";
      payButton.innerText = "Pay";
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

