import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    toggle() {
        const modal = document.getElementById(this.element.dataset.toggle)
        if(modal) {
            modal.classList.toggle('hidden')
        }
    }
}
