import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['fileUploader']

    trigger() {
        this.fileUploaderTarget.click();
    }

    filesChange() {
        const files = this.fileUploaderTarget.files;
        this.remainingFiles.classList.remove('hidden');
        const badgeCounter = this.remainingFiles.querySelector('span');
        badgeCounter.textContent = files.length;
    }
}
