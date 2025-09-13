import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ['fileUploader', 'fileList', 'submitButton']

    connect() {
        this.remainingFiles = document.getElementById('remaining-files');
    }

    trigger() {
        this.fileUploaderTarget.click();
    }

    filesChange() {
        const files = Array.from(this.fileUploaderTarget.files);
        this.remainingFiles.querySelector('span').textContent = files.length;
        this.remainingFiles.classList.remove('hidden');

        this.uploadedFiles = files.map(file => ({
            id: this.generateFileId(),
            file: file
        }));

        this.submitButtonTarget.classList.remove('hidden');

        this.uploadedFiles.forEach((uploadedFile) => {
            const previewItem = this.createPreviewItem(uploadedFile);
            this.fileListTarget.appendChild(previewItem);
        });

        this.fileUploaderTarget.value = "";
    }

    createPreviewItem(item) {
        const previewTemplate = document.getElementById('previewTemplate');
        const previewItemContainer = document.importNode(previewTemplate.content, true);
        previewItemContainer.querySelector('.preview-name').textContent = item.file.name;
        previewItemContainer.querySelector('.preview-size').textContent = this.humanFileSize(item.file.size);

        const removeButton = previewItemContainer.querySelector('.remove-action');
        removeButton.dataset.targetId = item.id;
        removeButton.addEventListener('click', (event) => {
            const targetId = event.currentTarget.dataset.targetId;
            event.currentTarget.closest('.preview-item').remove();
            this.uploadedFiles = this.uploadedFiles.filter(uploadedFile => uploadedFile.id != targetId);
            if (this.uploadedFiles.length > 0) {
                this.remainingFiles.querySelector('span').textContent = this.uploadedFiles.length;
            } else {
                this.remainingFiles.classList.add('hidden');
                this.submitButtonTarget.classList.add('hidden')
            }
        });

        return previewItemContainer;
    }

    // Credit: https://stackoverflow.com/a/14919494
    humanFileSize(bytes, si = true, dp = 1) {
        const thresh = si ? 1000 : 1024;
        if (Math.abs(bytes) < thresh) {
            return bytes + ' B';
        }
        const units = si
            ? ['KB', 'MB']
              : ['KiB', 'MiB'];
        let u = -1;
        const r = 10 ** dp;
        do {
            bytes /= thresh;
            ++u;
        } while (Math.round(Math.abs(bytes) * r) / r >= thresh && u < units.length - 1)

        return bytes.toFixed(dp) + ' ' + units[u];
    }

    generateFileId() {
        return crypto.randomUUID();
    }
}
