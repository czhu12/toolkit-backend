import { Controller } from "@hotwired/stimulus"
import ClipboardJS from "clipboard"
import tippy from "tippy.js";

export default class extends Controller {
  static values = {
    successMessage: { type: String, default: "Copied!" },
    errorMessage: { type: String, default: "Failed!" }
  }

  connect() {
    this.clipboard = new ClipboardJS(this.element)
    this.clipboard.on("success", (e) => this.tooltip(this.successMessageValue))
    this.clipboard.on("error",   (e) => this.tooltip(this.errorMessageValue))
  }

  tooltip(message) {
    tippy(this.element, {
      content: message,
      showOnCreate: true,
      onHidden: (instance) => {
        instance.destroy()
      }
    })
  }
}
