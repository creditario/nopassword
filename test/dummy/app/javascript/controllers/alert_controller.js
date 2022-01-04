import { Controller } from "@hotwired/stimulus"
import { useTransition } from "stimulus-use"

/**
 * Alert Controller
 *
 * Este controlador funciona con el template _notification.html.erb que es utilizado
 * en el layout NoPassword.
 * Cuando hay información en el objeto Flash de Rails se muestra con una animación
 * el mensaje y desaparece solo después de 10 segundos o cerrándolo con la X.
 */

export default class extends Controller {
  static targets = ["notification"];

  connect() {
    let element = this.element;
    if (this.hasNotificationTarget) {
      element = this.notificationTarget
    }
    useTransition(this, { element: element })

    this.enter()

    setTimeout(this.close.bind(this), 10000)
  }

  close() {
    this.leave()
  }
}