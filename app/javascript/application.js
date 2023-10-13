/* eslint no-console:0 */

import "@hotwired/turbo-rails"
require("@rails/activestorage").start()
require("local-time").start()

import "./channels"
import "./controllers"
import "./src/**/*"
