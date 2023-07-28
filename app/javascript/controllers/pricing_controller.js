// Options:
//
// Use data-pricing-active="yearly" to select yearly by default

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggle", "frequency", "plans"]
  static values = { frequency: String }
  static classes = ["activeFrequency", "inactiveFrequency", "activePlans", "inactivePlans"]

  connect() {
    this.removeEmptyFrequencies()
    this.defaultFrequency()
    if (this.frequencyTargets.length < 2) this.hideFrequencyToggle()
  }

  // Switches visible plans
  switch(event) {
    this.frequencyValue = event.target.dataset.frequency
  }

  // Removes frequencies that have no plans in them
  removeEmptyFrequencies() {
    this.frequencyTargets.forEach(target => {
      let frequency = target.dataset.frequency
      let index = this.plansTargets.findIndex((element) => element.dataset.frequency == frequency && element.childElementCount > 0)
      if (index == -1) target.remove()
    })
  }

  defaultFrequency() {
    if (!this.hasFrequencyValue) this.frequencyValue = this.frequencyTargets[0].dataset.frequency
  }

  hideFrequencyToggle() {
    this.toggleTarget.classList.add("hidden")
  }

  frequencyValueChanged() {
    this.frequencyTargets.forEach(target => {
      if (target.dataset.frequency == this.frequencyValue) {
        this.showFrequency(target)
      } else {
        this.hideFrequency(target)
      }
    })

    this.plansTargets.forEach(target => {
      if (target.dataset.frequency == this.frequencyValue) {
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
