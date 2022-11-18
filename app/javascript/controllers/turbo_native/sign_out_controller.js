import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  signOut(event) {
    if (this._isTurboNativeApp) {
      event.preventDefault()
      event.stopImmediatePropagation()
      window.TurboNativeBridge.postMessage("signOut")
    }
  }

  deleteAccount(event) {
    if (this._isTurboNativeApp) {
      event.preventDefault()
      event.stopImmediatePropagation()
      window.TurboNativeBridge.postMessage("deleteAccount")
    }
  }

  get _isTurboNativeApp() {
    return navigator.userAgent.indexOf("Turbo Native") !== -1
  }
}
