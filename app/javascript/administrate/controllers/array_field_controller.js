import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template"]

  add(e) {
    e.preventDefault()
    console.log(e.target)
    e.target.insertAdjacentHTML('beforebegin', this.templateTarget.innerHTML)
  }

  remove(e) {
    e.preventDefault()
    console.log(e.target.closest(".row"))
    e.target.closest(".row").remove()
  }
}
