import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['fileUploader']

    trigger() {
        this.fileUploaderTarget.click();
    }

    filesChange() {
        const files = this.fileUploaderTarget.files;
        console.log(files);
    }
}
