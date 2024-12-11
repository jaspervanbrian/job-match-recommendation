import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="top-candidates-modal"
export default class extends Controller {
  static targets = ["backdrop"]

  connect() {
  }
}
