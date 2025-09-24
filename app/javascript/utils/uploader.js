import { DirectUpload } from '@rails/activestorage';

export class Uploader {
    constructor(file, url) {
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
        console.log(`Progress: ${event.loaded / event.total * 100}%`)
    }
}
