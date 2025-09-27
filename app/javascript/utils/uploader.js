import { DirectUpload } from '@rails/activestorage';

export class Uploader {
    constructor(file_id, file, url, progressCallback) {
        this.file_id = file_id;
        this.progressCallback = progressCallback;
        this.upload = new DirectUpload(file, url, this);
    }

    uploadFile(file) {
        return new Promise((resolve, reject) => {
            this.upload.create((error, blob) => {
                if(error) {
                    reject(error);
                } else {
                    resolve(blob.signed_id);
                }
            })
        })
    }

    directUploadWillStoreFileWithXHR(request) {
        request.upload.addEventListener("progress", event => this.directUploadDidProgress(event))
    }

    directUploadDidProgress(event) {
        if (this.progressCallback) {
            const percentage = Math.round(event.loaded / event.total * 100);
            this.progressCallback(this.file_id, percentage)
        }
    }
}
