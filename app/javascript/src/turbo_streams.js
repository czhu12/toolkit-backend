// Add your own Custom Turbo StreamActions
// Define Rails helpers in `app/helpers/turbo_stream_actions_helper.rb`
//
// These actions run in the context of a turbo-stream element. You have access to methods like the following:
//
//   this.action - The action attribute value (for example: "append")
//   this.target - The target attribute value (the target element ID)
//   this.targetElements - An array of target elements the template will be rendered to
//   this.templateContent - The contents of the main `<template>`
//
// Source code for the stream element can be found here:
// https://github.com/hotwired/turbo/blob/main/src/elements/stream_element.ts

import { StreamActions } from "@hotwired/turbo"

// Remove elements after X milliseconds
// <%= turbo_stream.remove_later, target: "my-id", after: "2000" %>
StreamActions.remove_later = function() {
  setTimeout(() => {
    this.targetElements.forEach((element) => element.remove())
  }, this.getAttribute("after"))
}

// Resets a form
// <%= turbo_stream.reset_form "new_post"
StreamActions.reset_form = function() {
  this.targetElements.forEach((element) => element.reset())
}

// Scrolls an element into view
// <%= turbo_stream.scroll_to "comment_1"
StreamActions.scroll_to = function() {
  this.targetElements.forEach((element) => element.scrollIntoView({behavior: 'smooth'}))
}
