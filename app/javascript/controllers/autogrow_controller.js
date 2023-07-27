// Autogrows textareas based on content
//
// Example Usage:
// <%= form.text_area :value, data: {controller: "autogrow", action: "input->autogrow#autogrow"} %>

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.autogrow()
  }

  autogrow() {
    this.element.style.height = 'auto';
    this.element.style.height = `${this.element.scrollHeight}px`;
  }
}
