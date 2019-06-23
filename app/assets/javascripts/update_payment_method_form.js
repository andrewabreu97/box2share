$(document).on('turbolinks:load', function(){

  // Retrieve language
  var locale = 'es'

  // Retrieve the Stripe publishable key.
  const STRIPE_PUBLISHABLE_KEY = $("meta[name='stripe-publishable-key']").attr("content");

  // Create a Stripe client.
  var stripe = Stripe(STRIPE_PUBLISHABLE_KEY);

  // Create an instance of Elements.
  var elements = stripe.elements({locale: locale});

  // Custom styling can be passed to options when creating an Element.
  var style = {
    base: {
      color: '#495057',
      fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
      fontSmoothing: 'antialiased',
      fontSize: '16px',
      '::placeholder': {
        color: '#aab7c4'
      },
      lineHeight: '1.55'
    },
    invalid: {
      color: '#dc3545 ',
      iconColor: '#dc3545'
    }
  };

  // Create an instance of the card Element.
  var card = elements.create('card', { style: style, hidePostalCode: true });

  // Add an instance of the card Element into the `card-element` <div>.
  card.mount('#card-element');

  // Handle real-time validation errors from the card Element.
  card.on('change', function (event) {
    if (event.error) {
      $('#card-errors').removeClass('d-none');
      $('#card-errors').text(event.error.message);
    } else {
      $('#card-errors').addClass('d-none');
      $('#card-errors').text('');
    }
  });

  // Handle form submission.
  $('#update-card-form').on('submit', function (event) {
    event.preventDefault();

    stripe.createToken(card).then(function (result) {
      if (result.error) {
        // Inform the user if there was an error.
        $('#card-errors').removeClass('d-none');
        $('#card-errors').text(result.error.message);
      } else {
        // Send the token to your server.
        $('#card-errors').addClass('d-none');
        updateCardFormStripeTokenHandler(result.token);
      }
    });
  });

  // Submit the form with the token ID.
  function updateCardFormStripeTokenHandler(token) {
      // Insert the token ID into the form so it gets submitted to the server
      var hiddenInput = $('<input>')
      .attr('type', 'hidden')
      .attr('name', 'stripe_token')
      .val(token.id);

      $('#update-card-form').append(hiddenInput);
      alert("Estoy en el stripe token handler: " + token.id);
      // Submit the form
      $('#update-card-form').get(0).submit();
    }

});
