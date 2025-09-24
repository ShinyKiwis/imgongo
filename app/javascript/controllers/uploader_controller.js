import { Controller } from "@hotwired/stimulus";
import { post } from '@rails/request.js';
import { Uploader } from "utils/uploader";

export default class extends Controller {
    static targets = ['fileUploader', 'fileList', 'submitButton']

    connect() {
        this.remainingFiles = document.getElementById('remaining-files');
        this.uploadedFiles = [];
    }

    trigger() {
        this.fileUploaderTarget.click();
    }

    filesChange() {
        const files = Array.from(this.fileUploaderTarget.files);
        files.forEach(file => {
            this.uploadedFiles.push({
                id: this.generateFileId(),
                file: file
            })
            this.fileListTarget.appendChild(this.createPreviewItem(this.uploadedFiles[this.uploadedFiles.length - 1]));
        })

        this.remainingFiles.querySelector('span').textContent = files.length;
        this.remainingFiles.classList.remove('hidden');
        this.submitButtonTarget.classList.remove('hidden');
        this.fileUploaderTarget.value = '';
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

    async submitForm(event) {
        event.preventDefault();
        const form = event.target;

        const uploaders = this.uploadedFiles.map(uploadedFile => {
            return new Uploader(uploadedFile.file, this.fileUploaderTarget.dataset.directUploadUrl);
        })

        try {
            const signedIds = await Promise.all(uploaders.map(uploader => uploader.uploadFile()))

            const formData = new FormData()
            signedIds.forEach(id => {
                formData.append('attachment[signed_ids][]', id)
            })

            const response = await post(form.action, {
                body: formData,
                responseKind: 'turbo-stream'
            });

            if(response.ok) {
                this.clearUploader();
                this.closeModal();
            }

        } catch(error) {
            console.error('Upload failed: ', error);
        }
    }

    clearUploader() {
        this.uploadedFiles = [];
        this.fileListTarget.innerHTML = '';
        this.remainingFiles.classList.add('hidden');
        this.submitButtonTarget.classList.add('hidden');
    }

    closeModal() {
        this.element.closest('dialog').close();
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
