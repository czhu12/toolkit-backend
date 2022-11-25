import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template"]

  add(e) {
    e.preventDefault()
    e.target.insertAdjacentHTML('beforebegin', this.templateTarget.innerHTML)
  }

  remove(e) {
    e.preventDefault()
    e.target.closest(".row").remove()
  }
}
