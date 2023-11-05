import { Controller } from "@hotwired/stimulus"
import { get } from '@rails/request.js'

export default class extends Controller {
  static targets = [ "input" ]

  connect() {
    console.log("Hello");
  }

  async search(event) {
    await get("/search", {
      contentType: "application/json",
      headers: {},
      query: {q: event.target.value},
      responseKind: "turbo-stream"
    })
  }
}

