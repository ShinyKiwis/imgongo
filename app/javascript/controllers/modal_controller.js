import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['dialog'];
    static values = { hidden: Boolean };

    connect() {
        if(!this.hiddenValue) {
            this.dialogTarget.showModal();
        }
    }

    toggle() {
        if(this.dialogTarget.open) {
            this.dialogTarget.close();
        } else {
            this.dialogTarget.showModal();
        }
    }
}
