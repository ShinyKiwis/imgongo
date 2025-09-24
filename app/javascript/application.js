// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import * as ActiveStorage from "@rails/activestorage"
import "@hotwired/turbo-rails"
import "controllers"

ActiveStorage.start();
Turbo.config.forms.confirm = () => {
    let dialog = document.getElementById('turbo-confirm')
    dialog.showModal()

    return new Promise((resolve, reject) => {
        dialog.addEventListener('close', () => {
            resolve(dialog.returnValue == 'confirm')
        }, { once: true })
    })
}
