import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["addressElement", "paymentElement", "error", "form"]
  static values = {
    clientSecret: String,
    returnUrl: String,
    name: String
  }

  connect() {
    this.stripe = Stripe(this.stripeKey)
    let theme = document.documentElement.classList.contains("dark") ? "night" : "light";
    console.log(theme)
    this.elements = this.stripe.elements({
      appearance: {
        theme: theme,
        variables: {
          fontSizeBase: "14px"
        }
      },
      clientSecret: this.clientSecretValue
    })

    this.paymentElement = this.elements.create("payment")
    this.paymentElement.mount(this.paymentElementTarget)

    if (this.hasAddressElementTarget) {
      this.addressElement = this.elements.create('address', {
        mode: 'billing',
        defaultValues: {
          name: this.nameValue
        }
      });
      this.addressElement.mount(this.addressElementTarget)
    }
  }

  changed(event) {
    if (event.error) {
      this.errorTarget.textContent = event.error.message
    } else {
      this.errorTarget.textContent = ""
    }
  }

  async submit(event) {
    event.preventDefault()
    Rails.disableElement(this.formTarget)

    // Payment Intents
    if (this.clientSecretValue.startsWith("pi_")) {
      const { error } = await this.stripe.confirmPayment({
        elements: this.elements,
        confirmParams: {
          return_url: this.returnUrlValue,
        },
      });
      this.showError(error)

    // Setup Intents
    } else {
      const { error } = await this.stripe.confirmSetup({
        elements: this.elements,
        confirmParams: {
          return_url: this.returnUrlValue,
        },
      });
      this.showError(error)
    }
  }

  showError(error) {
    this.errorTarget.textContent = error.message
    setTimeout(() => {
      Rails.enableElement(this.formTarget)
    }, 100)
  }

  get stripeKey() {
    return document.querySelector('meta[name="stripe-key"]').getAttribute("content")
  }
}
