// Switches dark/light theme based upon the preference
//
// Set storage value to "localStorage" for saving the preference in the browser
// Otherwise, preference is saved on User profile in database
//
// For localStorage, your head tag should include the following JS to apply the dark class before paint
// document.documentElement.classList.toggle("dark", localStorage.theme === 'dark' || (localStorage.theme !== "light" && window.matchMedia('(prefers-color-scheme: dark)').matches))

import { Controller } from "@hotwired/stimulus"
import { patch } from "@rails/request.js"

export default class extends Controller {
  static values = {
    preference: String,
    storage: { type: String, default: "user" }
  }

  connect() {
    if (this.storageValue == "localStorage") this.preferenceValue = localStorage.theme
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

  light() {
    this.preferenceValue = "light"
    this.save()
  }

  dark() {
    this.preferenceValue = "dark"
    this.save()
  }

  system() {
    this.preferenceValue = ""
    this.save()
  }

  // This isn't called on preferenceValueChanged callback because that is fired on load which would trigger a save every page load
  save() {
    this.storageValue == "localStorage" ? this.saveToLocalStorage() : this.saveToUser()
  }

  saveToLocalStorage() {
    localStorage.theme = this.preferenceValue
  }

  saveToUser() {
    patch("/users", {
      body: {user: {"theme": this.preferenceValue }},
      contentType: "application/json"}
    )
  }
}
