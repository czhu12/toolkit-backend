import { Controller } from "@hotwired/stimulus"
import Tribute from "tributejs"
import Trix from "trix"

export default class extends Controller {
  static targets = [ "field" ]
  static values = {
    url: { type: String, default: '/users/mentions.json'}
  }

  connect() {
    this.initializeTribute()
  }

  initializeTribute() {
    this.tribute = new Tribute({
      allowSpaces: true,
      lookup: 'name',
      values: (text, callback) => {
        fetch(`${this.urlValue}?query=${text}`)
          .then(response => response.json())
          .then(users => callback(users))
          .catch(error => callback([]))
      },
      menuShowMinLength: 1,
    })
    this.tribute.attach(this.fieldTarget)
    this.fieldTarget.addEventListener('tribute-replaced', this.replaced.bind(this))
    this.tribute.range.pasteHtml = this._pasteHtml.bind(this)
  }

  disconnect() {
    this.tribute.detach(this.fieldTarget)
  }

  // Inserts ActionText Attachment when a Tribute entry is selected
  replaced(e) {
    let mention = e.detail.item.original
    let attachment = new Trix.Attachment({
      content: mention.content,
      sgid: mention.sgid,
    })
    this.editor.insertAttachment(attachment)
    this.editor.insertString(" ")
  }

  // Remove text user typed for the mention
  _pasteHtml(html, startPos, endPos) {
    let range = this.editor.getSelectedRange()
    let position = range[0]
    let length = endPos - startPos

    this.editor.setSelectedRange([position - length, position])
    this.editor.deleteInDirection("backward")
  }

  // Lazily lookup the Trix editor
  get editor() {
    return this.fieldTarget.editor
  }
}
