import Component from "./component";
import {Marked} from "marked";
import {markedHighlight} from "marked-highlight";
import hljs from 'highlight.js';

const marked = new Marked(
  markedHighlight({
    langPrefix: 'hljs language-',
    highlight(code, lang) {
      const language = hljs.getLanguage(lang) ? lang : 'plaintext';
      return hljs.highlight(code, { language }).value;
    }
  })
);

export default class Text extends Component {
  static name = 'Text';
  constructor(options={}) {
    super(options);
  }

  createElement() {
    const div = this._createElement("div");
    if (this.options.text) {
      div.innerHTML = marked.parse(this.options.text);
    }
    return div;
  }
}