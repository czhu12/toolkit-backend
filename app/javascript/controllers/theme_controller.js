// Switches dark/light theme based upon the preference

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    preference: String
  }

  connect() {
    window.matchMedia("(prefers-color-scheme: dark)").addEventListener("change", this.preferenceValueChanged.bind(this))
  }

  disconnect() {
    window.matchMedia("(prefers-color-scheme: dark)").removeEventListener("change", this.preferenceValueChanged)
  }

  preferenceValueChanged() {
    document.documentElement.classList.toggle('dark', this.preferenceValue === "dark" || (this.preferenceValue === "" && this.systemInDarkMode))
  }

  get systemInDarkMode() {
    return window.matchMedia('(prefers-color-scheme: dark)').matches
  }
}
