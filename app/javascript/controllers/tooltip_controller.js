// Example usage:
// <div data-controller="tooltip" data-tooltip-content-value="Hello world"></div>
//
// Or using Tippy data attributes
// See: https://atomiks.github.io/tippyjs/v6/constructor/#attribute
//      https://atomiks.github.io/tippyjs/v6/customization/
// <div data-controller="tooltip" data-tippy-content="Hello world"></div>

import { Controller } from "@hotwired/stimulus"
import tippy from "tippy.js";

export default class extends Controller {
  static values = {
    content: String
  }

  connect() {
    let options = {}
    if (this.hasContentValue) {
      options['content'] = this.contentValue
    }
    this.tippy = tippy(this.element, options);
  }

  disconnect() {
    this.tippy.destroy();
  }
}
