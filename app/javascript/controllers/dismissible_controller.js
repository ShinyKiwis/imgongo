import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        this.timer = setTimeout(() => {
            this.dismiss();
        }, 5000);
    }

    disconnect() {
        clearTimeout(this.timer);
    }

    dismiss() {
        this.element.remove();
    }
}
