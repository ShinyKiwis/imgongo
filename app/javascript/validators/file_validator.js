export default function fileValidator(fileInput) {
    const maxFileSizeInBytes = 5 * 1024 * 1024 // 3 megabytes

    const files = Array.from(fileInput.files);

    if (files.length == 0)  {
        return true;
    }

    for (let i = 0; i < files.length; i++) {
        if (files[i].size >= maxFileSizeInBytes || !files[i].type.startsWith('image/')) {
            const maxSizeMb = maxFileSizeInBytes / (1024 * 1024);
            const errorMessage = `Only images are accepted, and the size must be under ${maxSizeMb} MB.`;

            fileInput.setCustomValidity(errorMessage);
            fileInput.reportValidity();

            return false;
        }
    }

    return true;
}
