var form = document.querySelector("#payment-form");
var client_token = "<%= @client_token %>";

braintree.dropin.create(
  {
    authorization: client_token,
    container: "#bt-dropin",
    paypal: {
      flow: "vault",
    },
  },
  function (createErr, instance) {
    form.addEventListener("submit", function (event) {
      event.preventDefault();

      instance.requestPaymentMethod(function (err, payload) {
        if (err) {
          console.log("Error", err);
          return;
        }

        // Add the nonce to the form and submit
        document.querySelector("#nonce").value = payload.nonce;
        form.submit();
      });
    });
  }
);
