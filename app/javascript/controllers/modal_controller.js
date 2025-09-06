import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['dialog'];
    static values = { hidden: Boolean };

    connect() {
        console.log(this.dialogTarget)
        if(!this.hiddenValue) {
            console.log('HEREEE')
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
