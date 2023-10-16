import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "form" ]

  connect() {
    let displayModeTheme = document.documentElement.classList.contains("dark") ? "dark" : "light";
    let params = {
      method: 'inline',
      allowQuantity: false,
      disableLogout: true,
      frameTarget: "paddle-checkout",
      frameInitialHeight: 416,
      frameStyle: 'width:100%; background-color: transparent; border: none;',
      successCallback: this.checkoutComplete.bind(this),
      displayModeTheme: displayModeTheme
    }

    if (this.data.get("action") == "create-subscription") {
      Paddle.Checkout.open({
        ...params,
        product: this.data.get("product"),
        email: this.data.get("email"),
        passthrough: this.data.get("passthrough")
      });
    } else if (this.data.get("action") == "update-payment-details") {
      Paddle.Checkout.open({
        ...params,
        override: this.data.get("update-url")
      });
    }
  }

  // Webhooks will set the customer ID and subscription using the `passthrough` parameter
  checkoutComplete(data) {
    this.addHiddenField("processor", "paddle")
    this.formTarget.submit()
  }

  addHiddenField(name, value) {
    let hiddenInput = document.createElement("input")
    hiddenInput.setAttribute("type", "hidden")
    hiddenInput.setAttribute("name", name)
    hiddenInput.setAttribute("value", value)
    this.formTarget.appendChild(hiddenInput)
  }
}
