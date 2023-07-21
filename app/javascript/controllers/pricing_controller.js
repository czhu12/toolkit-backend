// Options:
//
// Use data-pricing-active="yearly" to select yearly by default

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggle", "frequency", "plans"]
  static values = { frequency: String }
  static classes = ["activeFrequency", "inactiveFrequency", "activePlans", "inactivePlans"]

  connect() {
    if (!this.hasFrequencyValue) {
      this.frequencyValue = this.frequencyTargets[0].dataset.frequency
    }

    // Remove any targets without plans in them
    this.frequencyTargets.forEach(target => {
      let frequency = target.dataset.frequency
      let index = this.plansTargets.findIndex((element) => element.dataset.frequency == frequency && element.childElementCount > 0)
      if (index == -1) target.remove()
    })

    // Hide frequency toggle if we have less than 2 frequencies with plans
    if (this.frequencyTargets.length < 2) this._hideFrequencyToggle()

    this._toggle(this.frequencyValue)
  }

  // Switches visible plans
  switch(event) {
    event.preventDefault()
    this._toggle(event.target.dataset.frequency)
  }

  // Hides frequency toggle
  _hideFrequencyToggle() {
    this.toggleTarget.classList.add("hidden")
  }

  // Toggles visible plans and selected frequency
  // Expects: "monthly", "yearly", etc
  _toggle(frequency) {
    // Keep track of active frequency on a data attribute
    this.frequencyValue = frequency

    this.frequencyTargets.forEach(target => {
      if (target.dataset.frequency == frequency) {
        this.showFrequency(target)
      } else {
        this.hideFrequency(target)
      }
    })

    this.plansTargets.forEach(target => {
      if (target.dataset.frequency == frequency) {
        this.showPlans(target)
      } else {
        this.hidePlans(target)
      }
    })
  }

  showFrequency(element) {
    element.classList.add(...this.activeFrequencyClasses)
    element.classList.remove(...this.inactiveFrequencyClasses)
  }

  hideFrequency(element) {
    element.classList.remove(...this.activeFrequencyClasses)
    element.classList.add(...this.inactiveFrequencyClasses)
  }

  showPlans(element) {
    element.classList.add(...this.activePlansClasses)
    element.classList.remove(...this.inactivePlansClasses)
  }

  hidePlans(element) {
    element.classList.remove(...this.activePlansClasses)
    element.classList.add(...this.inactivePlansClasses)
  }
}
