import { Controller } from "@hotwired/stimulus";

// シンプルなトースト通知（自動で数秒後に消える）
export default class extends Controller {
  static targets = ["toast"];
  static values = { timeout: { type: Number, default: 3500 } };

  connect() {
    this.show();
    this.hideTimer = setTimeout(() => this.hide(), this.timeoutValue);
  }

  disconnect() {
    if (this.hideTimer) clearTimeout(this.hideTimer);
  }

  // フェードイン表示
  show() {
    this.toastTarget.style.opacity = 1;
    this.toastTarget.style.transform = "translateY(0)";
  }

  // フェードアウトしてDOMから除去
  hide(event) {
    if (event) event.preventDefault();
    this.toastTarget.style.opacity = 0;
    this.toastTarget.style.transform = "translateY(-10px)";
    setTimeout(() => {
      this.element.remove();
    }, 250);
  }
}
