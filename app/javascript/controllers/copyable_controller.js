import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = { source: String };

    connect() {
        this.element.addEventListener('click', () => {
            this.copy(this.sourceValue);
        });
    }

    async copy(sourceContent) {
        try {
            const url = new URL(sourceContent);

            const response = await fetch(url);
            const originalBlob = await response.blob();
            const universalBlob = await this.convertToPng(originalBlob);

            const clipboardItem = new ClipboardItem({
                'image/png': universalBlob
            });

            await navigator.clipboard.write([clipboardItem]);
        } catch(error) {
            console.error(error.name, error.message)
        }
    }

    async convertToPng(blob) {
        return new Promise((resolve, reject) => {
            const img = new Image();

            img.onerror = () => {
                reject(new Error('Failed to load imaeg for PNG conversion'));
                URL.revokeObjectURL(img.src)
            }

            img.onload = () => {
                try {
                    const canvas = document.createElement('canvas');
                    canvas.width = img.naturalWidth;
                    canvas.height = img.naturalHeight;
                    const ctx = canvas.getContext('2d');
                    ctx.drawImage(img, 0, 0);

                    canvas.toBlob(pngBlob => {
                        URL.revokeObjectURL(img.src);
                        if (pngBlob) {
                            resolve(pngBlob);
                        } else {
                            reject(new Error('Canvas failed to create Blob'));
                        }
                    }, 'image/png');
                } catch(error) {
                    reject(error);
                }
            }

            img.src = URL.createObjectURL(blob);
        })
    }
}
    
